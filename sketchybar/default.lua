local sbar = require("sketchybar")
local globals = require("globals")

sbar.default({
  padding_left = globals.PADDING,
  padding_right = globals.PADDING,
  label = {
    padding_left = globals.PADDING,
    padding_right = globals.PADDING,
    font = { family = "SF Pro", style = "Regular" }
  },
  icon = {
    padding_left = globals.PADDING,
    padding_right = globals.PADDING,
  }
})
