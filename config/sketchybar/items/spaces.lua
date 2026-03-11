local colors = require("colors")
local icons = require("icons")
local settings = require("settings")
local app_icons = require("helpers.app_icons")

local spaces = {}
local workspace_index = {}

local workspaces = get_workspaces()
local current_workspace = tostring(get_current_workspace())
local active_workspace = current_workspace
local sketchybar_bin = "/opt/homebrew/opt/sketchybar/bin/sketchybar"

local function split(str, sep)
    local result = {}
    local regex = ("([^%s]+)"):format(sep)
    for each in str:gmatch(regex) do
        table.insert(result, each)
    end
    return result
end

local function round(value)
    return math.floor(value + 0.5)
end

local function highlighted_background(index, x_offset)
    return {
        drawing = true,
        color = settings.items.colors.background,
        border_width = 1,
        corner_radius = settings.items.corner_radius,
        height = settings.items.height,
        border_color = settings.items.highlight_color(index),
        x_offset = x_offset or 0
    }
end

local function inactive_background()
    return {
        drawing = false,
        color = colors.transparent,
        border_width = 0,
        corner_radius = settings.items.corner_radius,
        height = settings.items.height,
        border_color = colors.transparent,
        x_offset = 0
    }
end

local function first_bounding_rect(query)
    if not query or not query.bounding_rects then
        return nil
    end

    for _, rect in pairs(query.bounding_rects) do
        return rect
    end

    return nil
end

local function find_highlight_owner()
    local active_index = workspace_index[tostring(active_workspace)]
    if active_index and spaces[active_index] then
        local active_query = spaces[active_index]:query()
        if active_query then
            return active_index, active_query
        end
    end

    for index, space in ipairs(spaces) do
        local query = space:query()
        if query
            and query.geometry
            and query.geometry.background
            and (
                (query.icon and query.icon.highlight == "on")
                or tonumber(query.geometry.background.border_width or 0) > 0
            ) then
            return index, query
        end
    end

    return nil, nil
end

local function apply_text_highlights(target_index)
    for index, space in ipairs(spaces) do
        local selected = index == target_index
        space:set({
            icon = {
                highlight = selected
            },
            label = {
                highlight = selected
            }
        })
    end
end

local function animate_highlight_to(target_workspace)
    local target_index = workspace_index[tostring(target_workspace)]
    if not target_index then
        return
    end

    local source_index, source_query = find_highlight_owner()
    apply_text_highlights(target_index)

    if not source_index or source_index == target_index then
        for index, space in ipairs(spaces) do
            space:set({
                background = index == target_index and highlighted_background(index) or inactive_background()
            })
        end
        active_workspace = tostring(target_workspace)
        return
    end

    local target_space = spaces[target_index]
    local target_query = target_space:query()
    local source_rect = first_bounding_rect(source_query)
    local target_rect = first_bounding_rect(target_query)

    if not source_rect or not target_rect then
        for index, space in ipairs(spaces) do
            space:set({
                background = index == target_index and highlighted_background(index) or inactive_background()
            })
        end
        active_workspace = tostring(target_workspace)
        return
    end

    local source_visual_x = source_rect.origin[1] + (source_query.geometry.background.x_offset or 0)
    local target_x = target_rect.origin[1]
    local initial_offset = round(source_visual_x - target_x)
    local overshoot = initial_offset < 0 and settings.items.animation.overshoot or -settings.items.animation.overshoot

    for index, space in ipairs(spaces) do
        if index == target_index then
            space:set({
                background = highlighted_background(index, initial_offset)
            })
        else
            space:set({
                background = inactive_background()
            })
        end
    end

    sbar.exec(string.format(
        "%s --animate tanh %d --set %s background.x_offset=%d background.x_offset=0",
        sketchybar_bin,
        settings.items.animation.frames,
        target_space.name,
        overshoot
    ))

    active_workspace = tostring(target_workspace)
end

for i, workspace in ipairs(workspaces) do
    local workspace_name = tostring(workspace)
    local selected = workspace_name == current_workspace
    workspace_index[workspace_name] = i
    local space = sbar.add("item", "item." .. i, {
        icon = {
            font = {
                family = settings.font.numbers
            },
            string = i,
            padding_left = settings.items.padding.left,
            padding_right = settings.items.padding.left / 2,
            color = settings.items.default_color(i),
            highlight_color = settings.items.highlight_color(i),
            highlight = selected
        },
        label = {
            padding_right = settings.items.padding.right,
            color = settings.items.default_color(i),
            highlight_color = settings.items.highlight_color(i),
            font = settings.icons,
            y_offset = -1,
            highlight = selected
        },
        padding_right = 1,
        padding_left = 1,
        background = selected and highlighted_background(i) or inactive_background(),
        popup = {
            background = {
                border_width = 5,
                border_color = colors.black
            }
        }
    })

    spaces[i] = space

    -- Define the icons for open apps on each space initially
    sbar.exec("aerospace list-windows --workspace " .. i .. " --format '%{app-name}' --json ", function(apps)
        local icon_line = ""
        local no_app = true
        for i, app in ipairs(apps) do
            no_app = false
            local app_name = app["app-name"]
            local lookup = app_icons[app_name]
            local icon = ((lookup == nil) and app_icons["default"] or lookup)
            icon_line = icon_line .. " " .. icon
        end

        if no_app then
            icon_line = " —"
        end

        sbar.animate("tanh", 10, function()
            space:set({
                label = icon_line
            })
        end)
    end)

    -- Padding space between each item
    sbar.add("item", "item." .. i .. "padding", {
        script = "",
        width = settings.items.gap
    })

    -- Item popup
    local space_popup = sbar.add("item", {
        position = "popup." .. space.name,
        padding_left = 5,
        padding_right = 0,
        background = {
            drawing = true,
            image = {
                corner_radius = 9,
                scale = 0.2
            }
        }
    })

    space:subscribe("aerospace_workspace_change", function(env)
        if tostring(env.FOCUSED_WORKSPACE) == workspace_name then
            animate_highlight_to(workspace_name)
        end
    end)

    space:subscribe("mouse.clicked", function(env)
        local SID = split(env.NAME, ".")[2]
        if env.BUTTON == "other" then
            space_popup:set({
                background = {
                    image = "item." .. SID
                }
            })
            space:set({
                popup = {
                    drawing = "toggle"
                }
            })
        else
            sbar.exec("aerospace workspace " .. SID)
        end
    end)

    space:subscribe("mouse.exited", function(_)
        space:set({
            popup = {
                drawing = false
            }
        })
    end)
end

local space_window_observer = sbar.add("item", {
    drawing = false,
    updates = true
})

-- Handles the small icon indicator for spaces / menus changes
local spaces_indicator = sbar.add("item", {
    padding_left = -3,
    padding_right = 0,
    icon = {
        padding_left = 8,
        padding_right = 9,
        color = colors.grey,
        string = icons.switch.on
    },
    label = {
        width = 0,
        padding_left = 0,
        padding_right = 8,
        string = "Spaces",
        color = colors.bg1
    },
    background = {
        color = colors.with_alpha(colors.grey, 0.0),
        border_color = colors.with_alpha(colors.bg1, 0.0)
    }
})

local spaces_indicator_label_width = 55
local spaces_indicator_menu_right_pad = 8
local spaces_indicator_spaces_right_pad = 0

local function apply_spaces_indicator_trailing_padding()
    local in_spaces_mode = spaces_indicator:query().icon.value == icons.switch.on
    spaces_indicator:set({
        padding_right = in_spaces_mode and spaces_indicator_spaces_right_pad or spaces_indicator_menu_right_pad
    })
end

-- Event handles
space_window_observer:subscribe("space_windows_change", function(env)
    for i, workspace in ipairs(workspaces) do
        sbar.exec("aerospace list-windows --workspace " .. i .. " --format '%{app-name}' --json ", function(apps)
            local icon_line = ""
            local no_app = true
            for i, app in ipairs(apps) do
                no_app = false
                local app_name = app["app-name"]
                local lookup = app_icons[app_name]
                local icon = ((lookup == nil) and app_icons["default"] or lookup)
                icon_line = icon_line .. " " .. icon
            end

            if no_app then
                icon_line = " —"
            end

            sbar.animate("tanh", 10, function()
                spaces[i]:set({
                    label = icon_line
                })
            end)
        end)
    end
end)

space_window_observer:subscribe("aerospace_focus_change", function(env)
    for i, workspace in ipairs(workspaces) do
        sbar.exec("aerospace list-windows --workspace " .. i .. " --format '%{app-name}' --json ", function(apps)
            local icon_line = ""
            local no_app = true
            for i, app in ipairs(apps) do
                no_app = false
                local app_name = app["app-name"]
                local lookup = app_icons[app_name]
                local icon = ((lookup == nil) and app_icons["default"] or lookup)
                icon_line = icon_line .. " " .. icon
            end

            if no_app then
                icon_line = " —"
            end

            sbar.animate("tanh", 10, function()
                spaces[i]:set({
                    label = icon_line
                })
            end)
        end)
    end
end)

spaces_indicator:subscribe("swap_menus_and_spaces", function(env)
    local currently_on = spaces_indicator:query().icon.value == icons.switch.on
    spaces_indicator:set({
        icon = currently_on and icons.switch.off or icons.switch.on
    })
    apply_spaces_indicator_trailing_padding()
end)

spaces_indicator:subscribe("mouse.entered", function(env)
    -- Prime the background so it grows with (or slightly ahead of) the text reveal.
    spaces_indicator:set({
        background = {
            color = { alpha = 0.35 },
            border_color = { alpha = 0.35 }
        }
    })

    sbar.animate("tanh", 30, function()
        spaces_indicator:set({
            background = {
                color = {
                    alpha = 1.0
                },
                border_color = {
                    alpha = 1.0
                }
            },
            icon = {
                color = colors.bg1
            },
            label = {
                width = spaces_indicator_label_width
            }
        })
    end)
end)

spaces_indicator:subscribe({ "mouse.exited", "mouse.exited.global" }, function(env)
    sbar.animate("tanh", 30, function()
        spaces_indicator:set({
            background = {
                color = {
                    alpha = 0.0
                },
                border_color = {
                    alpha = 0.0
                }
            },
            icon = {
                color = colors.grey
            },
            label = {
                width = 0
            }
        })
    end)
end)

spaces_indicator:subscribe("mouse.clicked", function(env)
    sbar.trigger("swap_menus_and_spaces")
end)

apply_spaces_indicator_trailing_padding()
