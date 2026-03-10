local colors = require("colors")
local settings = require("settings")

local front_app = sbar.add("item", "front_app", {
	display = "active",
	padding_left = 6,
	padding_right = 12,
	icon = {
		drawing = false,
	},
	label = {
		padding_left = 4,
		padding_right = 7,
		font = {
			style = settings.font.style_map["Bold"],
			size = 13.0,
		},
	},
	updates = true,
})

front_app:subscribe("front_app_switched", function(env)
	front_app:set({
		label = {
			string = env.INFO,
		},
	})
end)

front_app:subscribe("mouse.clicked", function(env)
	sbar.trigger("swap_menus_and_spaces")
end)

-- Keep visible breathing room between the front-app title and the notch gap.
sbar.add("item", "front_app.tail_pad", {
	position = "left",
	width = 10,
	drawing = false,
})
