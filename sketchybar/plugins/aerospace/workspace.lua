local sbar = require("sketchybar")
local theme = require("theme")
local globals = require("globals")

local MAX_APPS_IN_WS = 10
local created = {}

local BUNDLE_ID_OVERRIDES = {
  ["app.net.java.openjdk.java"] = "app.com.apple.JavaLauncher",
}

local function create(ws)
  local prefix = "space." .. ws.id
  sbar.add("item", prefix, { icon = { drawing = false }, click_script = "aerospace workspace " .. ws.id })
  for i = 1, MAX_APPS_IN_WS do sbar.add("item", prefix .. ".app." .. i, { drawing = false }) end
  created[ws.id] = true
end

local function update_ws(ws)
  sbar.set("space." .. ws.id, {
    drawing = ws.focused or #ws.apps > 0,
    display = ws.display,
    label = {
      align = "center",
      string = ws.id,
      width = globals.WS_WIDTH,
      font = { style = "bold", size = globals.WS_FONT_SIZE },
      color = ws.focused and theme.active_foreground or theme.inactive_foreground,
      background = ws.focused and {
        drawing = true,
        height = 3,
        color = theme.active_foreground,
        y_offset = globals.ITEM_OFFSET,
        corner_radius = 3,
      } or { drawing = false },
    },
    background = ws.focused and {
      drawing = true,
      corner_radius = 3,
      color = theme.workspace_background,
      height = globals.ITEM_HEIGHT,
    } or { drawing = false },
  })
end

local function update_app(name, app, display, focused_wid)
  sbar.set(name, {
    drawing = true,
    display = display,
    click_script = "aerospace focus --window-id " .. app.window_id,
    label = {
      drawing = app.count > 1,
      string = "􀕩",
      color = theme.active_foreground,
      y_offset = -8,
      padding_left = -6,
      font = { size = 6 },
    },
    icon = { background = { drawing = true, image = {
      scale = globals.APP_ICON_SCALE,
      border_width = 1,
      corner_radius = 7,
      string = BUNDLE_ID_OVERRIDES[app.bundle_id] or app.bundle_id,
      border_color = app.window_id == focused_wid and theme.active_foreground,
    }}},
  })
end

local function update_apps(ws, focused_wid)
  local prefix = "space." .. ws.id

  for i, app in ipairs(ws.apps) do
    update_app(prefix .. ".app." .. i, app, ws.display, focused_wid)
  end

  for i = #ws.apps + 1, MAX_APPS_IN_WS do
    sbar.set(prefix .. ".app." .. i, { drawing = false, display = ws.display })
  end
end

return function(workspace_data, focused_window_id)
  local focused_wid = tonumber(focused_window_id or 0)
  for _, ws in ipairs(workspace_data) do
    if not created[ws.id] then create(ws) end
    update_ws(ws)
    update_apps(ws, focused_wid)
  end
end
