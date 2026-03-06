-- Rewritten on disk by plugins/bar_resize.lua (bar_height_change event).
-- Hotload restarts the config with the new value.
local BAR_HEIGHT = 33
local ITEM_HEIGHT = BAR_HEIGHT - 8
local PADDING = math.max(2, math.floor(BAR_HEIGHT * 0.15))

return {
  BAR_HEIGHT = BAR_HEIGHT,
  ITEM_HEIGHT = ITEM_HEIGHT,
  ITEM_OFFSET = -math.floor(ITEM_HEIGHT / 2) + 1,
  PADDING = PADDING,

  -- workspace (shared: workspace.lua + mode.lua)
  WS_FONT_SIZE = math.floor(BAR_HEIGHT * 0.5),
  WS_WIDTH = BAR_HEIGHT - 12,
  APP_ICON_SCALE = ITEM_HEIGHT / 32,
}
