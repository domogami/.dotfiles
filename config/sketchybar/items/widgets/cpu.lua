local icons = require("icons")
local colors = require("colors")
local settings = require("settings")

local cpu_color = colors.blue
local cpu_hover = false

-- Event provider emits "cpu_update" every 2 seconds.
sbar.exec("killall cpu_load >/dev/null; $CONFIG_DIR/helpers/event_providers/cpu_load/bin/cpu_load cpu_update 2.0")

local cpu = sbar.add("graph", "widgets.cpu", 58, {
	position = "right",
	padding_left = 0,
	padding_right = 4,
	y_offset = 0,
	graph = {
		color = colors.blue,
		fill_color = colors.with_alpha(colors.blue, 0.2),
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
})

local cpu_meta = sbar.add("item", "widgets.cpu.meta", {
	position = "right",
	padding_left = 0,
	padding_right = 2,
	icon = {
		string = icons.cpu,
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
		color = colors.blue,
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

local cpu_bracket = sbar.add("bracket", "widgets.cpu.bracket", { cpu_meta.name, cpu.name }, {
	background = {
		drawing = true,
		color = colors.transparent,
		border_width = 0,
		border_color = colors.transparent,
		corner_radius = 9,
		height = 24,
	},
})

local function apply_cpu_style()
	local fill_alpha = cpu_hover and 0.30 or 0.20
	cpu:set({
		graph = {
			color = cpu_color,
			fill_color = colors.with_alpha(cpu_color, fill_alpha),
			line_width = cpu_hover and 1.25 or 1.0,
		},
	})

	cpu_meta:set({
		icon = {
			color = colors.white,
		},
		label = {
			color = cpu_color,
		},
	})

	cpu_bracket:set({
		background = {
			color = cpu_hover and colors.with_alpha(colors.bg2, 0.22) or colors.transparent,
			border_width = cpu_hover and 1 or 0,
			border_color = cpu_hover and colors.with_alpha(cpu_color, 0.55) or colors.transparent,
		},
	})
end

local function set_cpu_hover(active)
	if cpu_hover == active then
		return
	end
	cpu_hover = active
	sbar.animate("tanh", 10, apply_cpu_style)
end

local function open_activity_monitor()
	sbar.exec("open -a 'Activity Monitor'")
end

cpu:subscribe("cpu_update", function(env)
	local load = tonumber(env.total_load) or 0
	cpu:push({ load / 100.0 })

	local color = colors.blue
	if load > 30 then
		if load < 60 then
			color = colors.yellow
		elseif load < 80 then
			color = colors.orange
		else
			color = colors.red
		end
	end

	cpu_color = color
	cpu_meta:set({
		label = {
			string = string.format("%d%%", math.floor(load + 0.5)),
		},
	})
	apply_cpu_style()
end)

cpu:subscribe("mouse.clicked", open_activity_monitor)
cpu_meta:subscribe("mouse.clicked", open_activity_monitor)

cpu:subscribe("mouse.entered", function()
	set_cpu_hover(true)
end)
cpu_meta:subscribe("mouse.entered", function()
	set_cpu_hover(true)
end)

cpu:subscribe({ "mouse.exited", "mouse.exited.global" }, function()
	set_cpu_hover(false)
end)
cpu_meta:subscribe({ "mouse.exited", "mouse.exited.global" }, function()
	set_cpu_hover(false)
end)

sbar.add("item", "widgets.cpu.padding", {
	position = "right",
	width = settings.group_paddings,
})

apply_cpu_style()
