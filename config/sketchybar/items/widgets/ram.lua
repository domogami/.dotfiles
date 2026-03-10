local icons = require("icons")
local colors = require("colors")
local settings = require("settings")

local ram_color = colors.green
local ram_hover = false

local page_size = 16384
local total_memory_gb = 0

sbar.exec("sysctl -n hw.memsize", function(output)
	local bytes = tonumber(output)
	if bytes then
		total_memory_gb = bytes / (1024 ^ 3)
	end
end)

local ram = sbar.add("graph", "widgets.ram", 58, {
	position = "right",
	update_freq = 5,
	padding_left = 0,
	padding_right = 4,
	y_offset = 0,
	graph = {
		color = colors.green,
		fill_color = colors.with_alpha(colors.green, 0.2),
		line_width = 1.0,
	},
	background = {
		drawing = true,
		color = colors.transparent,
		border_width = 0,
		height = 16,
		y_offset = 0,
	},
	icon = {
		drawing = false,
	},
	label = {
		drawing = false,
	},
	popup = {
		align = "center",
	},
})

local ram_meta = sbar.add("item", "widgets.ram.meta", {
	position = "right",
	padding_left = 0,
	padding_right = 2,
	icon = {
		string = icons.ram,
		color = colors.white,
		padding_left = 0,
		padding_right = 4,
		font = {
			style = settings.font.style_map["Regular"],
			size = 18.0,
		},
		y_offset = 0,
	},
	label = {
		string = "??%",
		color = colors.green,
		font = {
			family = settings.font.numbers,
			style = settings.font.style_map["Bold"],
			size = 11.0,
		},
		align = "left",
		padding_left = 0,
		padding_right = 6,
		width = 30,
		y_offset = 0,
	},
	background = {
		drawing = false,
	},
})

local ram_bracket = sbar.add("bracket", "widgets.ram.bracket", { ram_meta.name, ram.name }, {
	background = {
		drawing = true,
		color = colors.transparent,
		border_width = 0,
		border_color = colors.transparent,
		corner_radius = 9,
		height = 24,
	},
})

local function apply_ram_style()
	local fill_alpha = ram_hover and 0.30 or 0.20
	ram:set({
		graph = {
			color = ram_color,
			fill_color = colors.with_alpha(ram_color, fill_alpha),
			line_width = ram_hover and 1.25 or 1.0,
		},
	})

	ram_meta:set({
		icon = {
			color = colors.white,
		},
		label = {
			color = ram_color,
		},
	})

	ram_bracket:set({
		background = {
			color = ram_hover and colors.with_alpha(colors.bg2, 0.22) or colors.transparent,
			border_width = ram_hover and 1 or 0,
			border_color = ram_hover and colors.with_alpha(ram_color, 0.55) or colors.transparent,
		},
	})
end

local function set_ram_hover(active)
	if ram_hover == active then
		return
	end
	ram_hover = active
	sbar.animate("tanh", 10, apply_ram_style)
end

local ram_details = sbar.add("item", {
	position = "popup." .. ram.name,
	icon = {
		string = "memory",
		width = 95,
		align = "left",
	},
	label = {
		string = "calculating",
		width = 110,
		align = "right",
	},
})

local function update_ram_widget()
	sbar.exec("memory_pressure", function(output)
		local reported_page_size = output:match("page size of (%d+)")
		if reported_page_size then
			page_size = tonumber(reported_page_size) or page_size
		end

		local pages_free = tonumber(output:match("Pages free:%s+(%d+)") or 0)
		local pages_active = tonumber(output:match("Pages active:%s+(%d+)") or 0)
		local pages_inactive = tonumber(output:match("Pages inactive:%s+(%d+)") or 0)
		local pages_speculative = tonumber(output:match("Pages speculative:%s+(%d+)") or 0)
		local pages_wired = tonumber(output:match("Pages wired down:%s+(%d+)") or 0)
		local pages_compressed = tonumber(
			output:match("Pages used by compressor:%s+(%d+)")
				or output:match("Pages occupied by compressor:%s+(%d+)")
				or 0
		)

		local total_pages = pages_free + pages_active + pages_inactive + pages_speculative + pages_wired + pages_compressed
		if total_pages == 0 then
			return
		end

		local used_pages = pages_active + pages_wired + pages_compressed
		local usage_percent = math.floor((used_pages / total_pages) * 100 + 0.5)
		local used_gb = (used_pages * page_size) / (1024 ^ 3)

		local color = colors.green
		if usage_percent > 60 then
			color = colors.yellow
		end
		if usage_percent > 80 then
			color = colors.orange
		end
		if usage_percent > 90 then
			color = colors.red
		end

		ram_color = color
		ram:push({ usage_percent / 100.0 })
		ram_meta:set({
			label = {
				string = usage_percent .. "%",
			},
		})
		apply_ram_style()

		if total_memory_gb > 0 then
			ram_details:set({
				label = string.format("%.1f / %.1f GB", used_gb, total_memory_gb),
			})
		else
			ram_details:set({
				label = string.format("%.1f GB used", used_gb),
			})
		end
	end)
end

local function on_ram_click(env)
	if env.BUTTON == "right" then
		sbar.exec("open -a 'Activity Monitor'")
		return
	end

	ram:set({
		popup = {
			drawing = "toggle",
		},
	})
	update_ram_widget()
end

ram:subscribe({ "routine", "forced", "system_woke" }, update_ram_widget)

ram:subscribe("mouse.clicked", on_ram_click)
ram_meta:subscribe("mouse.clicked", on_ram_click)

ram:subscribe("mouse.entered", function()
	set_ram_hover(true)
end)
ram_meta:subscribe("mouse.entered", function()
	set_ram_hover(true)
end)

ram:subscribe({ "mouse.exited", "mouse.exited.global" }, function()
	set_ram_hover(false)
	ram:set({
		popup = {
			drawing = false,
		},
	})
end)
ram_meta:subscribe({ "mouse.exited", "mouse.exited.global" }, function()
	set_ram_hover(false)
	ram:set({
		popup = {
			drawing = false,
		},
	})
end)

sbar.add("item", "widgets.ram.padding", {
	position = "right",
	width = settings.group_paddings,
})

apply_ram_style()
update_ram_widget()
