local settings = require("settings")
local colors = require("colors")
local calendar_hover = false

-- Trailing inset at the right end of the pill.
sbar.add("item", "calendar.edge_pad", {
	position = "right",
	width = settings.group_paddings + 6,
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
	update_freq = 30,
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

cal:subscribe({ "forced", "routine", "system_woke" }, function(env)
	cal:set({ icon = os.date("%a. %d %b."), label = os.date("%I:%M") })
end)

local function apply_calendar_hover()
	cal:set({
		background = {
			color = calendar_hover and colors.with_alpha(colors.bg2, 0.22) or colors.transparent,
			border_width = calendar_hover and 1 or 0,
			border_color = calendar_hover and colors.with_alpha(colors.blue, 0.50) or colors.transparent,
		},
		icon = {
			color = calendar_hover and colors.blue or colors.white,
		},
	})
end

cal:subscribe("mouse.entered", function()
	calendar_hover = true
	sbar.animate("tanh", 10, apply_calendar_hover)
end)

cal:subscribe({ "mouse.exited", "mouse.exited.global" }, function()
	calendar_hover = false
	sbar.animate("tanh", 10, apply_calendar_hover)
end)
