local sbar = require("sketchybar")
local theme = require("theme")
local globals = require("globals")

sbar.bar({
  height = globals.BAR_HEIGHT,
  color = theme.bar_bg,
  padding_left = globals.BAR_PADDING,
  position = "top",
})
