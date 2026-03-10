local colors = require("colors")

-- SketchyBar on this build does not decode raw SVGs for item images.
-- Keep the SVG in assets as the source of truth and use a 2x raster export
-- so the icon still looks sharp on Retina displays.
local knight_icon = os.getenv("HOME") .. "/.config/sketchybar/assets/knightIconNoShadow.bar.png"

-- Keep the left edge compact so the floating bar does not look over-inset.
sbar.add("item", { width = 10 })

local apple = sbar.add("item", {
	width = 20,
	icon = { drawing = false },
	label = { drawing = false },
	background = {
		drawing = true,
		color = colors.transparent,
		height = 24,
		corner_radius = 0,
		x_offset = -4,
			image = {
				string = knight_icon,
				drawing = true,
				scale = 0.54,
				corner_radius = 0,
			border_width = 0,
			border_color = colors.transparent,
			padding_left = 0,
			padding_right = 0,
			y_offset = 0,
		},
	},
	padding_left = 0,
	padding_right = 0,
	click_script = "$CONFIG_DIR/helpers/menus/bin/menus -s 0",
})

-- Match the tighter left-side spacing after the apple group.
sbar.add("item", { width = 8 })
