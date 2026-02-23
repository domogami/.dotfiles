local colors = require("colors")
local icons = require("icons")

return {
	paddings = 3,
	group_paddings = 5,
	modes = {
		main = {
			icon = icons.apple,
			color = colors.rainbow[1],
		},
		service = {
			icon = icons.nuke,
			color = 0xffff9e64,
		},
	},
	bar = {
		height = 36,
		padding = {
			x = 10,
			y = 0,
		},
		background = colors.bar.bg,
	},
	items = {
		height = 26,
		gap = 5,
		padding = {
			right = 12,
			left = 8,
			top = 0,
			bottom = 0,
		},
		default_color = function(workspace)
			-- return colors.rainbow[workspace + 1]
			return colors.grey
		end,
		highlight_color = function(workspace)
			return colors.blue
		end,
		colors = {
			background = colors.bg1,
		},
		corner_radius = 6,
	},

	icons = "sketchybar-app-font:Regular:15.0", -- alternatively available: NerdFont

	font = {
		text = "FiraCode Nerd Font Propo", -- Used for text
		numbers = "FiraCode Nerd Font Propo", -- Used for numbers
		style_map = {
			["Regular"] = "Regular",
			["Semibold"] = "Medium",
			["Bold"] = "SemiBold",
			["Heavy"] = "Bold",
			["Black"] = "ExtraBold",
		},
	},
	default_font = {
		text = "SF Pro", -- Used for text
		numbers = "SF Mono", -- Used for numbers
		style_map = {
			["Regular"] = "Regular",
			["Semibold"] = "Semibold",
			["Bold"] = "Bold",
			["Heavy"] = "Heavy",
			["Black"] = "Black",
		},
	},
}
