local colors = require("colors")
local icons = require("icons")
local settings = require("settings")

local function resolve_knight_icon()
	local variant = (settings.custom_icons and settings.custom_icons.knight_variant) or "without_eyes"
	return icons.knight_glyph(variant)
end

-- Keep the left edge compact so the floating bar does not look over-inset.
sbar.add("item", { width = 10 })

local apple = sbar.add("item", {
	width = 20,
	icon = {
		string = resolve_knight_icon(),
		color = colors.white,
		padding_left = 0,
		padding_right = 0,
		font = {
			family = settings.custom_icons.family,
			style = settings.custom_icons.style,
			size = settings.custom_icons.knight_size,
		},
	},
	label = { drawing = false },
	background = { drawing = false },
	padding_left = 0,
	padding_right = 0,
	click_script = "$CONFIG_DIR/helpers/menus/bin/menus -s 0",
})

-- Match the tighter left-side spacing after the icon.
sbar.add("item", { width = 8 })
