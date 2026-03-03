require("plugins.aerospace.mode")
require("plugins.aerospace.app_open")
require("plugins.aerospace.workspace_manager")

local sbar = require("sketchybar")
local data_builder = require("plugins.aerospace.data")
local workspace = require("plugins.aerospace.workspace")
local cli = require("plugins.aerospace.cli")
local logger = require("util.logger")

local function handle_update(focused_window_id)
  cli.fetch_workspaces(function(raw_workspaces)
    workspace(data_builder.transform(raw_workspaces), focused_window_id)
  end)
end

local function register_event_handlers()
  sbar.add("event", "aerospace_focus_change")
  sbar.add("event", "aerospace_workspace_change")

  local event_handler_item = sbar.add("item", "spaces.event_handler", { drawing = false })

  event_handler_item:subscribe("aerospace_focus_change", function(env)
    logger("[EVENT] aerospace_focus_change", env)
    handle_update(env.FOCUSED_WINDOW_ID)
  end)

  event_handler_item:subscribe("aerospace_workspace_change", function(env)
    logger("[EVENT] aerospace_workspace_change", env)
    handle_update()
  end)

  event_handler_item:subscribe("space_windows_change", function(env)
    -- wait for windows to settle before querying aerospace
    sbar.exec("sleep 0.20", function()
      logger("[EVENT] space_windows_change (debounced)", env)
      handle_update()
    end)
  end)
end

cli.fetch_workspaces(function(raw_workspaces)
  local workspace_data = data_builder.transform(raw_workspaces)
  logger("[INIT] initial data:", workspace_data)
  workspace(workspace_data)
  register_event_handlers()
end)
