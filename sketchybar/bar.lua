local sbar = require("sketchybar")
local theme = require("theme")

sbar.bar({
  height = 33,
  color = theme.bar_bg,
  blur_radius = 1,
  padding_right = 6,
  padding_left = 10,
  position = "top"
})
