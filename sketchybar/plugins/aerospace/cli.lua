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

local function fetch_workspaces(callback)
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

  exec(workspaces_command, function(workspace_data)
    exec(windows_command, function(window_data)
      local combined = workspace_data or {}
      for _, window in ipairs(window_data or {}) do
        table.insert(combined, window)
      end
      callback(combined)
    end)
  end)
end

return {
  fetch_workspaces = fetch_workspaces
}
