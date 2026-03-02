local sbar = require("sketchybar")
local theme = require("theme")
local globals = require("globals")

sbar.bar({
  height = globals.BAR_HEIGHT,
  margin = 8,
  color = theme.transparent,
  blur_radius = 2,
  corner_radius = 11,
  padding_right = -100, -- negative offset for bar alignment
  padding_left = 0,
  position = "top",
  border_width = 1,
  y_offset = 2,
  border_color = theme.border_active,
})
