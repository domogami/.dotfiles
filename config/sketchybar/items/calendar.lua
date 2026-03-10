local settings = require("settings")
local colors = require("colors")

-- Trailing inset at the right end of the pill.
sbar.add("item", "calendar.edge_pad", {
	position = "right",
	width = settings.group_paddings + 6,
})

local cal = sbar.add("item", {
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
	background = { drawing = false },
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
