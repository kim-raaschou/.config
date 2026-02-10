local sbar = require("sketchybar")
local cli = require("plugins.aerospace.cli")
local logger = require("util.logger")

local event_handler = function(env)
  local target_ws = env.TARGET_WS or "1"

  sbar.exec("aerospace list-windows --focused --format '%{window-id}'", function(focused_wid)
    focused_wid = focused_wid and tonumber(focused_wid)

    cli.fetch_workspaces(function(data)
      if not data then return end
      local steps = {}

      -- Build move commands for all windows not on target workspace
      for _, item in ipairs(data) do
        if item["workspace"] ~= target_ws and item["window-id"] then
          table.insert(steps, "aerospace move-node-to-workspace --window-id " .. item["window-id"] .. " " .. target_ws)
        end
      end

      if #steps == 0 then
        sbar.exec(
          "aerospace layout h_accordion. && " ..
          "aerospace flatten-workspace-tree && " ..
          "sketchybar --trigger space_windows_change")
        logger("[WS_MGR] No windows to move; performed layout reset only.")
        return
      end

      if focused_wid then
        table.insert(steps, "aerospace focus --window-id " .. focused_wid)
      else
        -- Edge case: If focused_wid is nil: set layout explicitly (happens when no window was focused)
        table.insert(steps, "aerospace layout h_accordion")
      end

      table.insert(steps, "aerospace flatten-workspace-tree")
      table.insert(steps, "sketchybar --trigger space_windows_change")

      local aerospace_commands = table.concat(steps, " && ")
      sbar.exec(aerospace_commands, function(_, exit_code)
        if exit_code == 0 then
          logger("[WS_MGR] Layout reset complete. Executed:\n  " ..
            aerospace_commands:gsub(" && ", " && \n "))
        else
          logger("[WS_MGR] Failed (exit=" .. exit_code .. "). Commands:\n  " ..
            aerospace_commands:gsub(" && ", " && \n "))
        end
      end)
    end)
  end)
end

sbar.add("item", "aerospace.workspace_manager", { drawing = false })
    :subscribe("aerospace_reset_layout", event_handler)
