local logger = require("util.logger")
local sbar   = require("sketchybar")
local theme  = require("theme")

sbar.add("event", "aerospace_mode_change")

local modes = {
  ["apps"] = "􀀄",
  ["main"] = "􀀜",
  ["window"] = "􀀰",
}

local event_handler_item = sbar.add("item", "space.mode.event_handler", {
  label = {
    string = modes["main"],
    color = theme.mode_main,
    width = 28,
    y_offset = 1,
    font = {
      family = "SF Pro",
      style = "Semibold",
      size = 18.0
    }
  },
})

local function on_mode_change(env)
  logger("[EVENT] aerospace_mode_changed", env)

  local mode = env.MODE or "main"
  event_handler_item:set({
    label = {
      string = modes[mode],
      color = mode == "main" and theme.mode_main or theme.mode_active,
    }
  })
end

event_handler_item:subscribe("aerospace_mode_change", on_mode_change)
