local function glyph(codepoint)
	if utf8 and utf8.char then
		return utf8.char(codepoint)
	end
	return ""
end

local custom = {
	knight = glyph(0xe000),
	knight_eyes = glyph(0xe001),
	seconds = {},
}

for second = 0, 59 do
	custom.seconds[second] = glyph(0xe002 + second)
end

local function second_glyph(second)
	local normalized = math.floor(tonumber(second) or 0)
	if normalized < 0 then
		normalized = 0
	elseif normalized > 59 then
		normalized = 59
	end
	return custom.seconds[normalized]
end

local function knight_glyph(variant)
	if variant == "with_eyes" or variant == "eyes" then
		return custom.knight_eyes
	end
	return custom.knight
end

return {
	plus = "􀅼",
	loading = "􀖇",
	apple = "􀣺",
	rebel = "",
	empire = "",
	gear = "􀍟",
	cpu = "􀫥",
	ram = "􀫦",
	nuke = "",
	clipboard = "􀉄",

	switch = {
		on = "􁏮",
		off = "􁏯",
	},
	volume = {
		_100 = "􀊩",
		_66 = "􀊧",
		_33 = "􀊥",
		_10 = "􀊡",
		_0 = "􀊣",
	},
	battery = {
		_100 = "􀛨",
		_75 = "􀺸",
		_50 = "􀺶",
		_25 = "􀛩",
		_0 = "􀛪",
		charging = "􀢋",
	},
	wifi = {
		upload = "􀄨",
		download = "􀄩",
		connected = "􀙇",
		disconnected = "􀙈",
		router = "􁓤",
	},
	media = {
		back = "􀊊",
		forward = "􀊌",
		play_pause = "􀊈",
	},
	custom = custom,
	second_glyph = second_glyph,
	knight_glyph = knight_glyph,
}
