local sbar = require("sketchybar")
local logger = require("util.logger")

local function exec(command, callback)
  local start_time = os.clock()
  sbar.exec(command, function(result, exit_code)
    local duration = (os.clock() - start_time) * 1000
    if exit_code ~= 0 then
      logger("[CLI] FAILED (" .. string.format("%.1fms", duration) .. ") ", command)
      callback(nil)
    else
      logger("[CLI] OK (" .. string.format("%.1fms", duration) .. ") " .. command)
      callback(result)
    end
  end)
end

local function format(command)
  return command:gsub("\n%s+", " ")
end

local workspaces_command = format([[
    aerospace list-workspaces
      --monitor all
      --json
      --format '
        %{workspace}
        %{workspace-is-focused}
        %{monitor-appkit-nsscreen-screens-id}'
  ]])

local windows_command = format([[
    aerospace list-windows
      --all
      --json
      --format '
        %{workspace}
        %{workspace-is-focused}
        %{monitor-appkit-nsscreen-screens-id}
        %{app-name}
        %{window-id}
        %{window-title}
        %{app-bundle-id}
        %{app-bundle-path} '
  ]])

local fetch_workspaces = function(callback)
  local workspaces, windows = {}, {}
  local pending = 2

  local function try_complete()
    pending = pending - 1
    if pending > 0 then return end

    local data = {}
    for _, window in ipairs(windows) do
      table.insert(data, window)
    end

    for _, ws in ipairs(workspaces) do
      table.insert(data, ws)
    end

    callback(data)
  end

  exec(workspaces_command, function(data)
    workspaces = data
    try_complete()
  end)

  exec(windows_command, function(data)
    windows = data
    try_complete()
  end)
end

return {
  fetch_workspaces = fetch_workspaces
}
