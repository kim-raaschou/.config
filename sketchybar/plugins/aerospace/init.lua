require("plugins.aerospace.mode")
require("plugins.aerospace.app_open")


local sbar = require("sketchybar")
local data_builder = require("plugins.aerospace.data")
local setup = require("plugins.aerospace.setup")
local update = require("plugins.aerospace.update")
local cli = require("plugins.aerospace.cli")
local logger = require("logger")

local WINDOW_CHANGE_DEBOUNCE = 0.15  -- Wait for AeroSpace to settle

local function on_focus_change(env)
  logger("[EVENT] aerospace_focus_change", env)
  cli.fetch_workspaces(function(raw_workspaces)
    local workspace_data = data_builder.transform(raw_workspaces)
    update(workspace_data, env.FOCUSED_WINDOW_ID)
  end)
end

local function on_workspace_change(env)
  logger("[EVENT] aerospace_workspace_change", env)
  cli.fetch_workspaces(function(raw_workspaces)
    local workspace_data = data_builder.transform(raw_workspaces)
    update(workspace_data)
  end)
end

local function on_windows_change(env)
  logger("[EVENT] space_windows_change.", env)
  sbar.exec(string.format("sleep %.2f", WINDOW_CHANGE_DEBOUNCE), function()
    cli.fetch_workspaces(function(raw_workspaces)
      local workspace_data = data_builder.transform(raw_workspaces)
      update(workspace_data)
    end)
  end)
end

local function register_event_handlers()
  sbar.add("event", "aerospace_focus_change")
  sbar.add("event", "aerospace_workspace_change")

  local event_handler_item = sbar.add("item", "spaces.event_handler", { drawing = false })
  event_handler_item:subscribe("aerospace_focus_change", on_focus_change)
  event_handler_item:subscribe("aerospace_workspace_change", on_workspace_change)
  event_handler_item:subscribe("space_windows_change", on_windows_change)
end

cli.fetch_workspaces(function(raw_workspaces)
  local workspace_data = data_builder.transform(raw_workspaces)

  logger("[INIT] initial data:", workspace_data)

  setup(workspace_data)
  update(workspace_data)
  register_event_handlers()
end)
