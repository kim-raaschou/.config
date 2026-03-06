local logger  = require("util.logger")
local sbar    = require("sketchybar")
local theme   = require("theme")
local globals = require("globals")

sbar.add("event", "aerospace_mode_change")

local circled = {
  A = "􀀄",
  B = "􀀆",
  C = "􀀈",
  D = "􀀊",
  E = "􀀌",
  F = "􀀎",
  G = "􀀐",
  H = "􀀒",
  I = "􀀔",
  J = "􀀖",
  K = "􀀘",
  L = "􀀚",
  M = "􀀜",
  N = "􀀞",
  O = "􀀠",
  P = "􀀢",
  Q = "􀀤",
  R = "􀀦",
  S = "􀀨",
  T = "􀀪",
  U = "􀀬",
  V = "􀀮",
  W = "􀀰",
  X = "􀀲",
  Y = "􀀴",
  Z = "􀀶"
}

local function mode_symbol(mode)
  local letter = string.upper(string.sub(mode, 1, 1))
  return circled[letter] or letter
end

local function mode_color(mode)
  return mode == "main" and theme.inactive_foreground or theme.active_foreground
end

local mode_item = sbar.add("item", "space.mode.event_handler", {
  label = {
    string = mode_symbol("main"),
    color = mode_color("main"),
    font = { family = "SF Pro", style = "SemiBold", size = globals.WS_FONT_SIZE },
  },
})

mode_item:subscribe("aerospace_mode_change", function(env)
  logger("[EVENT] aerospace_mode_changed", env)

  local mode = env.MODE or "main"
  mode_item:set({
    label = {
      string = mode_symbol(mode),
      color = mode_color(mode),
    },
  })
end)
