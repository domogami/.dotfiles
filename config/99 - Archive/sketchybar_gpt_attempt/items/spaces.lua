local colors = require("colors")
local icons = require("icons")
local settings = require("settings")
local app_icons = require("helpers.app_icons")

local workspaces = {}

-- Create and configure workspace items for Aerospace workspaces
for i = 1, 10 do
  local ws = sbar.add("item", "workspace." .. i, {
    icon = {
      font = { family = settings.font.numbers },
      string = tostring(i),
      padding_left = 15,
      padding_right = 8,
      color = colors.white,
      highlight_color = colors.red,
    },
    label = {
      padding_right = 20,
      color = colors.grey,
      highlight_color = colors.white,
      font = "sketchybar-app-font:Regular:16.0",
      y_offset = -1,
    },
    padding_right = 1,
    padding_left = 1,
    background = {
      color = colors.bg1,
      border_width = 1,
      height = 26,
      border_color = colors.black,
    },
    popup = { background = { border_width = 5, border_color = colors.black } }
  })

  -- HIGHLIGHT on workspace focus change
  ws:subscribe("aerospace_workspace_change", function(env)
    local selected = (env.INFO.space == tostring(i))
    ws:set({
      background = { border_color = selected and colors.black or colors.bg2 },
      icon       = { highlight    = selected },
      label      = { highlight    = selected },
    })
  end)

  -- ICON UPDATE on apps‐in‐workspace change
  ws:subscribe("space_windows_change", function(env)
    if env.INFO.space ~= tostring(i) then return end
    local icons_line = ""
    for app in env.INFO.apps:gmatch("%S+") do
      local ic = app_icons[app] or app_icons.Default
      icons_line = icons_line .. ic
    end
    if icons_line == "" then icons_line = " —" end
    ws:set({ label = icons_line })
  end)

  workspaces[i] = ws

  -- Double-border bracket for selected workspace
  sbar.add("bracket", { ws.name }, {
    background = {
      color = colors.transparent,
      border_color = colors.bg2,
      height = 28,
      border_width = 2,
    }
  })

  -- Padding between workspace items
  sbar.add("item", "workspace.padding." .. i, {
    width = settings.group_paddings,
    drawing = false,
  })

  -- Popup image for workspace preview
  sbar.add("item", {
    position = "popup." .. ws.name,
    padding_left = 5,
    padding_right = 0,
    background = {
      drawing = true,
      image = {
        corner_radius = 9,
        scale = 0.2,
      }
    }
  })

  -- Subscribe to Aerospace workspace change to update highlight
  ws:subscribe("aerospace_workspace_change", function(env)
    local selected = (env.INFO.space == tostring(i))
    ws:set({
      icon = { highlight = selected },
      label = { highlight = selected },
      background = { border_color = selected and colors.black or colors.bg2 }
    })
  end)

  -- Click to focus workspace in Aerospace
  ws:subscribe("mouse.clicked", function(_)
    sbar.exec("aerospace workspace " .. i)
  end)
end

-- (Optional) Toggle indicator for spaces/app view
local spaces_indicator = sbar.add("item", {
  padding_left = -3,
  padding_right = 0,
  icon = {
    padding_left = 8,
    padding_right = 9,
    color = colors.grey,
    string = icons.switch.on,
  },
  label = {
    width = 0,
    padding_left = 0,
    padding_right = 8,
    string = "Workspaces",
    color = colors.bg1,
  },
  background = {
    color = colors.with_alpha(colors.grey, 0.0),
    border_color = colors.with_alpha(colors.bg1, 0.0),
  }
})

spaces_indicator:subscribe("swap_menus_and_spaces", function(env)
  local current = spaces_indicator:query().icon.value == icons.switch.on
  spaces_indicator:set({ icon = current and icons.switch.off or icons.switch.on })
end)

spaces_indicator:subscribe("mouse.entered", function(env)
  sbar.animate("tanh", 30, function()
    spaces_indicator:set({
      background = { color = { alpha = 1.0 }, border_color = { alpha = 1.0 } },
      icon = { color = colors.bg1 },
      label = { width = "dynamic" }
    })
  end)
end)

spaces_indicator:subscribe("mouse.exited", function(env)
  sbar.animate("tanh", 30, function()
    spaces_indicator:set({
      background = { color = { alpha = 0.0 }, border_color = { alpha = 0.0 } },
      icon = { color = colors.grey },
      label = { width = 0 }
    })
  end)
end)

spaces_indicator:subscribe("mouse.clicked", function(env)
  sbar.trigger("swap_menus_and_spaces")
end)