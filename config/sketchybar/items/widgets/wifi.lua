local icons = require("icons")
local colors = require("colors")
local settings = require("settings")

local active_interface = "en0"
local wifi_up_color = colors.grey
local wifi_down_color = colors.grey
local wifi_status_color = colors.white
local wifi_hover = false

local function trim(value)
    return (value or ""):gsub("^%s+", ""):gsub("%s+$", "")
end

local function start_network_provider(interface)
    sbar.exec(
        "killall network_load >/dev/null; $CONFIG_DIR/helpers/event_providers/network_load/bin/network_load "
            .. interface
            .. " network_update 2.0"
    )
end

local function detect_active_interface(callback)
    sbar.exec("route -n get default 2>/dev/null | awk '/interface:/{print $2}'", function(output)
        local detected = trim(output)
        if detected ~= "" then
            active_interface = detected
        end
        start_network_provider(active_interface)
        if callback then
            callback()
        end
    end)
end

local function rate_to_bits(rate)
    local raw = trim(rate)
    local value, unit = raw:match("^(%d+)%s*([KMG]?Bps)$")
    if not value then
        return 0
    end

    local bytes_per_second = tonumber(value) or 0
    if unit == "KBps" then
        bytes_per_second = bytes_per_second * 1000
    elseif unit == "MBps" then
        bytes_per_second = bytes_per_second * 1000000
    elseif unit == "GBps" then
        bytes_per_second = bytes_per_second * 1000000000
    end

    return bytes_per_second * 8
end

local function format_bits(bits_per_second)
    if bits_per_second >= 1000000 then
        return string.format("%.1fMbps", bits_per_second / 1000000.0)
    end
    if bits_per_second >= 1000 then
        return string.format("%03dKbps", math.floor((bits_per_second / 1000.0) + 0.5))
    end
    return string.format("%03dbps", math.floor(bits_per_second + 0.5))
end

local popup_width = 250

local wifi_up = sbar.add("item", "widgets.wifi1", {
    position = "right",
    padding_left = -5,
    width = 0,
    icon = {
        padding_right = 0,
        font = {
            style = settings.font.style_map["Bold"],
            size = 9.0
        },
        string = icons.wifi.upload
    },
    label = {
        font = {
            family = settings.font.numbers,
            style = settings.font.style_map["Bold"],
            size = 9.0
        },
        color = colors.red,
        string = "??? Bps"
    },
    y_offset = 4
})

local wifi_down = sbar.add("item", "widgets.wifi2", {
    position = "right",
    padding_left = -5,
    icon = {
        padding_right = 0,
        font = {
            style = settings.font.style_map["Bold"],
            size = 9.0
        },
        string = icons.wifi.download
    },
    label = {
        font = {
            family = settings.font.numbers,
            style = settings.font.style_map["Bold"],
            size = 9.0
        },
        color = colors.blue,
        string = "??? Bps"
    },
    y_offset = -4
})

local wifi = sbar.add("item", "widgets.wifi.padding", {
    position = "right",
    label = {
        drawing = false
    }
})

-- Background around the item
local wifi_bracket = sbar.add("bracket", "widgets.wifi.bracket", {wifi.name, wifi_up.name, wifi_down.name}, {
    background = {
        drawing = true,
        color = colors.transparent,
        border_color = colors.transparent,
        border_width = 0,
        corner_radius = 8,
        height = 24
    },
    popup = {
        align = "center",
        height = 30
    }
})

local ssid = sbar.add("item", {
    position = "popup." .. wifi_bracket.name,
    icon = {
        font = {
            style = settings.font.style_map["Bold"]
        },
        string = icons.wifi.router
    },
    width = popup_width,
    align = "center",
    label = {
        font = {
            size = 15,
            style = settings.font.style_map["Bold"]
        },
        max_chars = 18,
        string = "????????????"
    },
    background = {
        height = 2,
        color = colors.grey,
        y_offset = -15
    }
})

local hostname = sbar.add("item", {
    position = "popup." .. wifi_bracket.name,
    icon = {
        align = "left",
        string = "Hostname:",
        width = popup_width / 2
    },
    label = {
        max_chars = 20,
        string = "????????????",
        width = popup_width / 2,
        align = "right"
    }
})

local ip = sbar.add("item", {
    position = "popup." .. wifi_bracket.name,
    icon = {
        align = "left",
        string = "IP:",
        width = popup_width / 2
    },
    label = {
        string = "???.???.???.???",
        width = popup_width / 2,
        align = "right"
    }
})

local mask = sbar.add("item", {
    position = "popup." .. wifi_bracket.name,
    icon = {
        align = "left",
        string = "Subnet mask:",
        width = popup_width / 2
    },
    label = {
        string = "???.???.???.???",
        width = popup_width / 2,
        align = "right"
    }
})

local router = sbar.add("item", {
    position = "popup." .. wifi_bracket.name,
    icon = {
        align = "left",
        string = "Router:",
        width = popup_width / 2
    },
    label = {
        string = "???.???.???.???",
        width = popup_width / 2,
        align = "right"
    }
})

sbar.add("item", {
    position = "right",
    width = settings.group_paddings
})

local function apply_wifi_hover()
    wifi_bracket:set({
        background = {
            color = wifi_hover and colors.with_alpha(colors.bg2, 0.22) or colors.transparent,
            border_width = wifi_hover and 1 or 0,
            border_color = wifi_hover and colors.with_alpha(colors.blue, 0.50) or colors.transparent
        }
    })

    wifi:set({
        icon = {
            color = wifi_hover and colors.white or wifi_status_color
        }
    })

    wifi_up:set({
        icon = {
            color = wifi_up_color
        },
        label = {
            color = wifi_up_color
        }
    })

    wifi_down:set({
        icon = {
            color = wifi_down_color
        },
        label = {
            color = wifi_down_color
        }
    })
end

local function set_wifi_hover(active)
    if wifi_hover == active then
        return
    end
    wifi_hover = active
    sbar.animate("tanh", 10, apply_wifi_hover)
end

wifi_up:subscribe("network_update", function(env)
    local upload_bits = rate_to_bits(env.upload)
    local download_bits = rate_to_bits(env.download)
    wifi_up_color = (upload_bits == 0) and colors.grey or colors.red
    wifi_down_color = (download_bits == 0) and colors.grey or colors.blue

    wifi_up:set({
        icon = {
            color = wifi_up_color
        },
        label = {
            string = format_bits(upload_bits),
            color = wifi_up_color
        }
    })
    wifi_down:set({
        icon = {
            color = wifi_down_color
        },
        label = {
            string = format_bits(download_bits),
            color = wifi_down_color
        }
    })
    apply_wifi_hover()
end)

wifi:subscribe({"wifi_change", "system_woke"}, function(env)
    detect_active_interface(function()
        sbar.exec("ipconfig getifaddr " .. active_interface, function(ip)
            local connected = not (ip == "")
            wifi_status_color = connected and colors.white or colors.red
            wifi:set({
                icon = {
                    string = connected and icons.wifi.connected or icons.wifi.disconnected,
                    color = wifi_status_color
                }
            })
            apply_wifi_hover()
        end)
    end)
end)

local function hide_details()
    wifi_bracket:set({
        popup = {
            drawing = false
        }
    })
end

local function toggle_details()
    local should_draw = wifi_bracket:query().popup.drawing == "off"
    if should_draw then
        wifi_bracket:set({
            popup = {
                drawing = true
            }
        })
        sbar.exec("networksetup -getcomputername", function(result)
            hostname:set({
                label = result
            })
        end)
        sbar.exec("ipconfig getifaddr " .. active_interface, function(result)
            ip:set({
                label = result
            })
        end)
        sbar.exec("networksetup -getairportnetwork Wi-Fi | sed 's/^Current Wi-Fi Network: //'", function(result)
            ssid:set({
                label = result
            })
        end)
        sbar.exec("networksetup -getinfo Wi-Fi | awk -F 'Subnet mask: ' '/^Subnet mask: / {print $2}'", function(result)
            mask:set({
                label = result
            })
        end)
        sbar.exec("networksetup -getinfo Wi-Fi | awk -F 'Router: ' '/^Router: / {print $2}'", function(result)
            router:set({
                label = result
            })
        end)
    else
        hide_details()
    end
end

wifi_up:subscribe("mouse.clicked", toggle_details)
wifi_down:subscribe("mouse.clicked", toggle_details)
wifi:subscribe("mouse.clicked", toggle_details)
wifi_up:subscribe("mouse.entered", function() set_wifi_hover(true) end)
wifi_down:subscribe("mouse.entered", function() set_wifi_hover(true) end)
wifi:subscribe("mouse.entered", function() set_wifi_hover(true) end)
wifi_up:subscribe({ "mouse.exited", "mouse.exited.global" }, function() set_wifi_hover(false) end)
wifi_down:subscribe({ "mouse.exited", "mouse.exited.global" }, function() set_wifi_hover(false) end)
wifi:subscribe("mouse.exited.global", function()
    set_wifi_hover(false)
    hide_details()
end)

local function copy_label_to_clipboard(env)
    local label = sbar.query(env.NAME).label.value
    sbar.exec("echo \"" .. label .. "\" | pbcopy")
    sbar.set(env.NAME, {
        label = {
            string = icons.clipboard,
            align = "center"
        }
    })
    sbar.delay(1, function()
        sbar.set(env.NAME, {
            label = {
                string = label,
                align = "right"
            }
        })
    end)
end

ssid:subscribe("mouse.clicked", copy_label_to_clipboard)
hostname:subscribe("mouse.clicked", copy_label_to_clipboard)
ip:subscribe("mouse.clicked", copy_label_to_clipboard)
mask:subscribe("mouse.clicked", copy_label_to_clipboard)
router:subscribe("mouse.clicked", copy_label_to_clipboard)

apply_wifi_hover()
detect_active_interface()
