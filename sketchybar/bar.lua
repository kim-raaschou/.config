local sbar = require("sketchybar")
local theme = require("theme")
local globals = require("globals")

sbar.bar({
  height = globals.BAR_HEIGHT,
  color = theme.bar_background,
  padding_left = 0,
  position = "top",
})
