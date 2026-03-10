local colors = require("colors")
local settings = require("settings")
local density_settings = settings.density or {}
local normal_density = density_settings.normal or {}
local fallback_max_chars = normal_density.front_app_max_chars or 22

local function trim(value)
	return (value or ""):gsub("^%s+", ""):gsub("%s+$", "")
end

local function char_count(value)
	local ok, count = pcall(utf8.len, value)
	if ok and count then
		return count
	end
	return #value
end

local function utf8_sub(value, start_char, end_char)
	if not utf8 or not utf8.offset then
		return value:sub(start_char, end_char)
	end

	local start_index = utf8.offset(value, start_char)
	if not start_index then
		return ""
	end

	local end_index = utf8.offset(value, end_char + 1)
	if not end_index then
		return value:sub(start_index)
	end

	return value:sub(start_index, end_index - 1)
end

local function simplify_title(value)
	local simplified = trim(value)
	simplified = simplified:gsub("%s+[%-–—|:·].*$", "")
	if simplified == "" then
		return trim(value)
	end
	return simplified
end

local function get_density_profile()
	local mode = settings.active_density_mode or "normal"
	return density_settings[mode] or normal_density
end

local function get_current_max_chars()
	local profile = get_density_profile()
	return profile.front_app_max_chars or fallback_max_chars
end

local function truncate_title(value, max_chars)
	local title = simplify_title(value)
	if max_chars <= 1 then
		return title, false
	end
	if char_count(title) <= max_chars then
		return title, false
	end
	return utf8_sub(title, 1, max_chars - 1) .. "…", true
end

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
		max_chars = fallback_max_chars,
		scroll_duration = 80,
		font = {
			style = settings.font.style_map["Bold"],
			size = 13.0,
		},
	},
	updates = true,
})

front_app:subscribe("front_app_switched", function(env)
	local profile = get_density_profile()
	local max_chars = get_current_max_chars()
	local truncation_alpha = profile.front_app_truncation_alpha or 0.90
	local title, truncated = truncate_title(env.INFO, max_chars)
	front_app:set({
		label = {
			string = title,
			color = truncated and colors.with_alpha(colors.white, truncation_alpha) or colors.white,
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
