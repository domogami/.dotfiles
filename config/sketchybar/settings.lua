local colors = require("colors")
local icons = require("icons")

return {
	paddings = 3,
	group_paddings = 3,
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
			x = 8,
			y = 0,
		},
		background = colors.bar.bg,
		border_color = colors.bar.border,
		border_width = 1,
		corner_radius = 14,
		margin = 6,
		y_offset = 6,
		blur_radius = 20,
		notch_width = 210,
		shadow = false,
	},
	density = {
		compact_max_width = 1800,
		normal = {
			bar_padding_x = 8,
			split_pill_padding = 12,
			space_gap = 5,
			space_icon_padding_left = 8,
			space_icon_padding_right = 4,
			space_label_padding_right = 12,
			space_label_max_chars = 16,
			front_app_max_chars = 22,
			front_app_truncation_alpha = 0.90,
			widget_graph_width = 58,
			calendar_label_width = 58,
			calendar_seconds_width = 14,
			calendar_edge_pad = 11,
			calendar_cluster_pad = 8,
		},
		compact = {
			bar_padding_x = 6,
			split_pill_padding = 10,
			space_gap = 3,
			space_icon_padding_left = 6,
			space_icon_padding_right = 3,
			space_label_padding_right = 8,
			space_label_max_chars = 10,
			front_app_max_chars = 14,
			front_app_truncation_alpha = 0.85,
			widget_graph_width = 52,
			calendar_label_width = 52,
			calendar_seconds_width = 12,
			calendar_edge_pad = 9,
			calendar_cluster_pad = 6,
		},
	},
	active_density_mode = "normal",
	items = {
		height = 24,
		gap = 5,
		animation = {
			frames = 22,
			overshoot = 6,
		},
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
	custom_icons = {
		family = "SketchybarCustomIconsV2",
		style = "Regular",
		-- Options: "without_eyes" (default), "with_eyes"
		knight_variant = "with_eyes",
		knight_size = 17.0,
		seconds_size = 14.0,
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
