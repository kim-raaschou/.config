local sbar = require("sketchybar")
local globals = require("globals")

local GLOBALS_PATH = os.getenv("HOME") .. "/.config/sketchybar/globals.lua"

sbar.add("event", "bar_height_change")

local handler = sbar.add("item", "bar_resize.handler", { drawing = false })

handler:subscribe("bar_height_change", function(env)
  local height = tonumber(env.HEIGHT)
  if not height or height == globals.BAR_HEIGHT then return end

  local f = io.open(GLOBALS_PATH, "r")
  if not f then return end
  local content = f:read("*a")
  f:close()

  content = content:gsub("local BAR_HEIGHT = %d+", "local BAR_HEIGHT = " .. height)

  io.open(GLOBALS_PATH, "w"):write(content):close()
end)
