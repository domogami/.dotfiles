local icons = require("icons")
local colors = require("colors")
local settings = require("settings")

-- Execute the event provider binary which provides the event "cpu_update" for
-- the cpu load data, which is fired every 2.0 seconds.
sbar.exec("killall cpu_load >/dev/null; $CONFIG_DIR/helpers/event_providers/cpu_load/bin/cpu_load cpu_update 2.0")

local cpu = sbar.add("graph", "widgets.cpu", 56, {
    position = "right",
    padding_left = 1,
    y_offset = 0,
    graph = {
        color = colors.blue,
        fill_color = colors.with_alpha(colors.blue, 0.2),
        line_width = 1.0
    },
    background = {
        drawing = true,
        color = colors.transparent,
        border_width = 0,
        height = 15,
        y_offset = 5
    },
    icon = {
        string = icons.cpu,
        color = colors.white,
        padding_left = 0,
        padding_right = 4,
        font = {
            style = settings.font.style_map["Regular"],
            size = 18.0
        },
        y_offset = 0
    },
    label = {
        string = "??%",
        font = {
            family = settings.font.numbers,
            style = settings.font.style_map["Bold"],
            size = 11.0
        },
        align = "left",
        padding_left = 4,
        padding_right = 2,
        width = "dynamic",
        y_offset = 0
    },
    padding_right = settings.paddings + 8
})

cpu:subscribe("cpu_update", function(env)
    -- Also available: env.user_load, env.sys_load
    local load = tonumber(env.total_load)
    cpu:push({load / 100.})

    local color = colors.blue
    if load > 30 then
        if load < 60 then
            color = colors.yellow
        elseif load < 80 then
            color = colors.orange
        else
            color = colors.red
        end
    end

    cpu:set({
        graph = {
            color = color,
            fill_color = colors.with_alpha(color, 0.2)
        },
        label = {
            string = env.total_load .. "%",
            color = color
        },
        icon = {
            color = colors.white
        }
    })
end)

cpu:subscribe("mouse.clicked", function(env)
    sbar.exec("open -a 'Activity Monitor'")
end)

sbar.add("item", "widgets.cpu.padding", {
    position = "right",
    width = settings.group_paddings
})
