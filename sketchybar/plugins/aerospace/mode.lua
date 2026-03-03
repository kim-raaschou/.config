local logger  = require("util.logger")
local sbar    = require("sketchybar")
local theme   = require("theme")
local globals = require("globals")

sbar.add("event", "aerospace_mode_change")

local modes = {
  ["apps"] = "􀀄",
  ["main"] = "􀀜",
  ["window"] = "􀀰",
  ["layout"] = "􀀚"
}

local mode_item = sbar.add("item", "space.mode.event_handler", {
  label = {
    string = modes["main"],
    color = theme.mode_main,
    y_offset = 1,
    font = {
      family = "SF Pro",
      style = "Bold",
      size = globals.WS_FONT_SIZE
    }
  },
})

mode_item:subscribe("aerospace_mode_change", function(env)
  logger("[EVENT] aerospace_mode_changed", env)

  local mode = env.MODE or "main"
  mode_item:set({
    label = {
      string = modes[mode] or string.upper(string.sub(mode, 1, 1)),
      color = mode == "main" and theme.mode_main or theme.mode_active,
    }
  })
end)
