local settings = require("settings")
local colors = require("colors")
local icons = require("icons")

local calendar_hover = false
local clock_roll_active = false
local last_minute_key = nil
local last_time_text = nil
local current_second = 0

local clock_palette = {
	accent = colors.blue,
	date = colors.white,
	time = colors.white,
}

local onedark_clock = {
	fg = 0xffcfd6e4,
	fg_bright = 0xffeef3fb,
	blue = 0xff61afef,
	cyan = 0xff56b6c2,
	yellow = 0xffe5c07b,
	orange = 0xffd19a66,
}

local function clamp(value, minimum, maximum)
	if value < minimum then
		return minimum
	end
	if value > maximum then
		return maximum
	end
	return value
end

local function split_argb(color)
	local alpha = (color >> 24) & 0xff
	local red = (color >> 16) & 0xff
	local green = (color >> 8) & 0xff
	local blue = color & 0xff
	return alpha, red, green, blue
end

local function pack_argb(alpha, red, green, blue)
	return ((alpha & 0xff) << 24) | ((red & 0xff) << 16) | ((green & 0xff) << 8) | (blue & 0xff)
end

local function mix_color(from_color, to_color, factor)
	local t = clamp(factor, 0.0, 1.0)
	local fa, fr, fg, fb = split_argb(from_color)
	local ta, tr, tg, tb = split_argb(to_color)
	local alpha = math.floor(fa + (ta - fa) * t + 0.5)
	local red = math.floor(fr + (tr - fr) * t + 0.5)
	local green = math.floor(fg + (tg - fg) * t + 0.5)
	local blue = math.floor(fb + (tb - fb) * t + 0.5)
	return pack_argb(alpha, red, green, blue)
end

local function clock_warmth(hour, minute, second)
	local daytime = hour + (minute / 60.0) + (second / 3600.0)
	local phase = ((daytime - 14.0) / 24.0) * (2.0 * math.pi)
	return (math.cos(phase) + 1.0) / 2.0
end

local function refresh_clock_palette(hour, minute, second)
	local cool_accent = mix_color(onedark_clock.blue, onedark_clock.cyan, 0.35)
	local warm_accent = mix_color(onedark_clock.yellow, onedark_clock.orange, 0.40)
	local warmth = clock_warmth(hour, minute, second)
	local accent = mix_color(cool_accent, warm_accent, warmth)
	clock_palette.accent = mix_color(accent, onedark_clock.fg_bright, 0.10)
	clock_palette.date = mix_color(onedark_clock.fg, clock_palette.accent, 0.42)
	clock_palette.time = mix_color(onedark_clock.fg_bright, clock_palette.accent, 0.30)
end

-- Trailing inset at the right end of the pill.
sbar.add("item", "calendar.edge_pad", {
	position = "right",
	width = settings.group_paddings + 6,
})

local seconds = sbar.add("item", "calendar.seconds", {
	position = "right",
	padding_left = 0,
	padding_right = 3,
	width = 14,
	icon = {
		string = icons.second_glyph(0),
		color = colors.white,
		padding_left = 0,
		padding_right = 0,
		font = {
			family = settings.custom_icons.family,
			style = settings.custom_icons.style,
			size = settings.custom_icons.seconds_size,
		},
	},
	label = {
		drawing = false,
	},
	background = {
		drawing = false,
	},
	click_script = "open -a 'Notion Calendar'",
})

sbar.add("item", "calendar.seconds.gap", {
	position = "right",
	width = 4,
})

local cal = sbar.add("item", "calendar", {
	icon = {
		color = colors.white,
		padding_left = 6,
		padding_right = 6,
		font = {
			style = settings.default_font.style_map["Bold"],
			size = 13.0,
		},
	},
	label = {
		color = colors.white,
		padding_left = 6,
		padding_right = 8,
		width = 58,
		align = "right",
		font = { family = settings.default_font.numbers },
	},
	position = "right",
	update_freq = 1,
	padding_left = 2,
	padding_right = 2,
	background = {
		drawing = true,
		color = colors.transparent,
		border_width = 0,
		border_color = colors.transparent,
		height = 24,
		corner_radius = 7,
	},
	click_script = "open -a 'Notion Calendar'",
})

-- Breathing room between battery and calendar cluster.
sbar.add("item", "calendar.cluster_pad", {
	position = "right",
	width = settings.group_paddings + 5,
})

local function apply_calendar_style()
	cal:set({
		background = {
			color = calendar_hover and colors.with_alpha(colors.bg2, 0.22) or colors.transparent,
			border_width = calendar_hover and 1 or 0,
			border_color = calendar_hover and colors.with_alpha(clock_palette.accent, 0.55) or colors.transparent,
		},
		icon = {
			color = calendar_hover and clock_palette.accent or clock_palette.date,
		},
	})

	if not clock_roll_active then
		cal:set({
			label = {
				color = calendar_hover and colors.white or clock_palette.time,
			},
		})
	end

	seconds:set({
		icon = {
			string = icons.second_glyph(current_second),
			color = calendar_hover and colors.white or clock_palette.time,
		},
	})
end

local function animate_minute_roll(new_time)
	if last_time_text == nil then
		cal:set({
			label = {
				string = new_time,
				y_offset = 0,
				color = calendar_hover and colors.white or clock_palette.time,
			},
		})
		return
	end

	clock_roll_active = true
	local faded = colors.with_alpha(clock_palette.time, 0.0)

	sbar.animate("tanh", 10, function()
		cal:set({
			label = {
				y_offset = -8,
				color = faded,
			},
		})
	end)

	sbar.delay(0.10, function()
		cal:set({
			label = {
				string = new_time,
				y_offset = 8,
				color = faded,
			},
		})
		sbar.animate("tanh", 12, function()
			cal:set({
				label = {
					y_offset = 0,
					color = calendar_hover and colors.white or clock_palette.time,
				},
			})
		end)
		sbar.delay(0.14, function()
			clock_roll_active = false
		end)
	end)
end

local function update_calendar_clock()
	local hour = tonumber(os.date("%H")) or 0
	local minute = tonumber(os.date("%M")) or 0
	local second = tonumber(os.date("%S")) or 0
	local minute_key = os.date("%Y-%m-%d %H:%M")
	local date_text = os.date("%a. %d %b.")
	local time_text = os.date("%I:%M")

	refresh_clock_palette(hour, minute, second)
	current_second = second

	cal:set({
		icon = date_text,
	})

	if minute_key ~= last_minute_key then
		animate_minute_roll(time_text)
		last_minute_key = minute_key
		last_time_text = time_text
	elseif time_text ~= last_time_text then
		cal:set({
			label = {
				string = time_text,
				y_offset = 0,
				color = calendar_hover and colors.white or clock_palette.time,
			},
		})
		last_time_text = time_text
	end

	apply_calendar_style()
end

cal:subscribe({ "forced", "routine", "system_woke" }, function()
	update_calendar_clock()
end)

local function set_calendar_hover(active)
	if calendar_hover == active then
		return
	end
	calendar_hover = active
	sbar.animate("tanh", 10, apply_calendar_style)
end

cal:subscribe("mouse.entered", function()
	set_calendar_hover(true)
end)
seconds:subscribe("mouse.entered", function()
	set_calendar_hover(true)
end)

cal:subscribe({ "mouse.exited", "mouse.exited.global" }, function()
	set_calendar_hover(false)
end)
seconds:subscribe({ "mouse.exited", "mouse.exited.global" }, function()
	set_calendar_hover(false)
end)

update_calendar_clock()
