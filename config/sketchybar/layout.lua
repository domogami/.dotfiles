local colors = require("colors")
local settings = require("settings")

local state = {
	mode = nil,
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

local function set_unified_bar()
	remove_split_brackets()
	sbar.bar({
		color = settings.bar.background,
		border_color = settings.bar.border_color,
		border_width = settings.bar.border_width,
		corner_radius = settings.bar.corner_radius,
		blur_radius = settings.bar.blur_radius,
		notch_width = 0,
	})
end

local function add_split_bracket(name, members)
	if #members == 0 then
		return
	end

	local pill_padding = settings.bar.padding.x + 4

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

local function set_split_bar(left_members, right_members)
	remove_split_brackets()
	sbar.bar({
		color = colors.transparent,
		border_color = colors.transparent,
		border_width = 0,
		corner_radius = 0,
		blur_radius = 0,
		notch_width = settings.bar.notch_width,
	})

	add_split_bracket("bar.pill.left", left_members)
	add_split_bracket("bar.pill.right", right_members)
end

local function apply_layout()
	local split_mode = is_notched_main_display()
	local left_members = collect_members("left")
	local right_members = collect_members("right")
	local left_signature = members_signature(left_members)
	local right_signature = members_signature(right_members)

	if split_mode then
		if state.mode ~= "split" or state.left_signature ~= left_signature or state.right_signature ~= right_signature then
			set_split_bar(left_members, right_members)
			state.mode = "split"
			state.left_signature = left_signature
			state.right_signature = right_signature
		end
		return
	end

	if state.mode ~= "unified" then
		set_unified_bar()
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
