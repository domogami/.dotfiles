local colors = require("colors")
local settings = require("settings")
local density_settings = settings.density or {}

local state = {
	mode = nil,
	density_mode = nil,
	left_signature = "",
	right_signature = "",
}

local function get_main_display()
	local displays = sbar.query("displays")
	if type(displays) ~= "table" or #displays == 0 then
		return nil
	end

	for _, display in ipairs(displays) do
		local arrangement = tonumber(display["arrangement-id"] or display.arrangement_id)
		if arrangement == 1 then
			return display
		end
	end

	return displays[1]
end

local function is_notched_main_display()
	local display = get_main_display()
	if not display or type(display.frame) ~= "table" then
		return false
	end

	local width = tonumber(display.frame.w) or 0
	local height = tonumber(display.frame.h) or 0
	if width <= 0 or height <= 0 then
		return false
	end

	local rounded_width = math.floor(width + 0.5)
	local known_notched_widths = {
		[1512] = true,
		[1728] = true,
		[1800] = true,
		[2056] = true,
		[2234] = true,
	}

	if known_notched_widths[rounded_width] then
		return true
	end

	local ratio = width / height
	return width >= 1400 and width <= 2300 and ratio > 1.50 and ratio < 1.58
end

local function get_density_mode()
	local display = get_main_display()
	if not display or type(display.frame) ~= "table" then
		return "normal"
	end

	local width = tonumber(display.frame.w) or 0
	local threshold = tonumber(density_settings.compact_max_width or 1800) or 1800
	if width > 0 and width <= threshold then
		return "compact"
	end

	return "normal"
end

local function get_density_profile(mode)
	local fallback = density_settings.normal or {}
	return density_settings[mode] or fallback
end

local function collect_members(position)
	local members = {}
	local bar_query = sbar.query("bar")
	if not bar_query or type(bar_query.items) ~= "table" then
		return members
	end

	for _, item_name in ipairs(bar_query.items) do
		if item_name ~= "bar.pill.left" and item_name ~= "bar.pill.right" and item_name ~= "bar.layout.watcher" then
			local item = sbar.query(item_name)
			if item and item.type ~= "bracket" and item.geometry then
				local drawing = tostring(item.geometry.drawing or "on")
				if item.geometry.position == position and drawing == "on" then
					table.insert(members, item_name)
				end
			end
		end
	end

	return members
end

local function members_signature(members)
	return table.concat(members, "|")
end

local function remove_split_brackets()
	sbar.remove("bar.pill.left")
	sbar.remove("bar.pill.right")
end

local function apply_density(profile)
	if not profile then
		return
	end

	sbar.set("/item\\.[0-9]+padding/", {
		width = profile.space_gap or settings.items.gap,
	})

	sbar.set("/item\\.[0-9]+/", {
		icon = {
			padding_left = profile.space_icon_padding_left or settings.items.padding.left,
			padding_right = profile.space_icon_padding_right or (settings.items.padding.left / 2),
		},
		label = {
			padding_right = profile.space_label_padding_right or settings.items.padding.right,
			max_chars = profile.space_label_max_chars or 16,
		},
	})

	sbar.set("front_app", {
		label = {
			max_chars = profile.front_app_max_chars or 22,
		},
	})

	sbar.set("widgets.cpu", {
		width = profile.widget_graph_width or 56,
	})

	sbar.set("widgets.ram", {
		width = profile.widget_graph_width or 56,
	})

	sbar.set("calendar", {
		label = {
			width = profile.calendar_label_width or 58,
		},
	})

	sbar.set("calendar.seconds", {
		width = profile.calendar_seconds_width or 34,
	})

	sbar.set("calendar.edge_pad", {
		width = profile.calendar_edge_pad or (settings.group_paddings + 6),
	})

	sbar.set("calendar.cluster_pad", {
		width = profile.calendar_cluster_pad or (settings.group_paddings + 5),
	})
end

local function set_unified_bar(profile)
	local bar_padding = profile.bar_padding_x or settings.bar.padding.x
	remove_split_brackets()
	sbar.bar({
		color = settings.bar.background,
		border_color = settings.bar.border_color,
		border_width = settings.bar.border_width,
		corner_radius = settings.bar.corner_radius,
		blur_radius = settings.bar.blur_radius,
		padding_left = bar_padding,
		padding_right = bar_padding,
		notch_width = 0,
	})
end

local function add_split_bracket(profile, name, members)
	if #members == 0 then
		return
	end

	local pill_padding = profile.split_pill_padding or (settings.bar.padding.x + 4)

	sbar.add("bracket", name, members, {
		background = {
			drawing = true,
			color = settings.bar.background,
			border_color = settings.bar.border_color,
			border_width = settings.bar.border_width,
			corner_radius = settings.bar.corner_radius,
			height = settings.bar.height,
		},
		padding_left = pill_padding,
		padding_right = pill_padding,
	})
end

local function set_split_bar(profile, left_members, right_members)
	local bar_padding = profile.bar_padding_x or settings.bar.padding.x
	remove_split_brackets()
	sbar.bar({
		color = colors.transparent,
		border_color = colors.transparent,
		border_width = 0,
		corner_radius = 0,
		blur_radius = 0,
		padding_left = bar_padding,
		padding_right = bar_padding,
		notch_width = settings.bar.notch_width,
	})

	add_split_bracket(profile, "bar.pill.left", left_members)
	add_split_bracket(profile, "bar.pill.right", right_members)
end

local function apply_layout()
	local density_mode = get_density_mode()
	local density_profile = get_density_profile(density_mode)
	if state.density_mode ~= density_mode then
		apply_density(density_profile)
		settings.active_density_mode = density_mode
		state.density_mode = density_mode
		state.left_signature = ""
		state.right_signature = ""
	end

	local split_mode = is_notched_main_display()
	local left_members = collect_members("left")
	local right_members = collect_members("right")
	local left_signature = members_signature(left_members)
	local right_signature = members_signature(right_members)

	if split_mode then
		if state.mode ~= "split" or state.left_signature ~= left_signature or state.right_signature ~= right_signature then
			set_split_bar(density_profile, left_members, right_members)
			state.mode = "split"
			state.left_signature = left_signature
			state.right_signature = right_signature
		end
		return
	end

	if state.mode ~= "unified" then
		set_unified_bar(density_profile)
		state.mode = "unified"
		state.left_signature = ""
		state.right_signature = ""
	end
end

local layout_watcher = sbar.add("item", "bar.layout.watcher", {
	drawing = false,
	updates = true,
	update_freq = 5,
})

layout_watcher:subscribe({
	"forced",
	"routine",
	"display_change",
	"swap_menus_and_spaces",
}, function()
	apply_layout()
end)

sbar.delay(0.3, apply_layout)
