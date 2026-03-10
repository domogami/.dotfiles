local settings = require("settings")

-- Equivalent to the --bar domain
sbar.bar({
    topmost = "window",
    height = settings.bar.height,
    color = settings.bar.background,
    border_color = settings.bar.border_color,
    border_width = settings.bar.border_width,
    corner_radius = settings.bar.corner_radius,
    padding_right = settings.bar.padding.x,
    padding_left = settings.bar.padding.x,
    y_offset = settings.bar.y_offset,
    margin = settings.bar.margin,
    blur_radius = settings.bar.blur_radius,
    notch_width = settings.bar.notch_width,
    -- padding_top = settings.bar.padding.y,
    -- padding_bottom = settings.bar.padding.y,
    sticky = true,
    position = "top",
    shadow = settings.bar.shadow
})
