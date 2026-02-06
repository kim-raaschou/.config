local sbar = require("sketchybar")
local cli = require("plugins.aerospace.cli")
local logger = require("util.logger")

local event_handler = function(env)
  local target_ws = env.TARGET_WS or "1"
  local commands = {}

  sbar.exec("aerospace list-windows --focused --format '%{window-id}'", function(focused_wid)
    focused_wid = focused_wid and tonumber(focused_wid)

    cli.fetch_workspaces(function(data)
      if not data then return end

      -- Build move commands for all windows not on target workspace
      for _, item in ipairs(data) do
        if item["workspace"] ~= target_ws and item["window-id"] then
          table.insert(commands, "aerospace move-node-to-workspace --window-id " .. item["window-id"] .. " " .. target_ws)
        end
      end

      if #commands == 0 then return end

      if focused_wid then
        -- If focused_wid exists: restore focus (auto-switches to target workspace)
        table.insert(commands, "aerospace focus --window-id " .. focused_wid)
      else
        -- If nil: set layout explicitly (happens when no window was focused)
        table.insert(commands, "aerospace layout tiles accordion")
      end

      -- Trigger UI refresh (debounced 150ms, full workspace fetch)
      table.insert(commands, "sketchybar --trigger space_windows_change")

      -- Execute all commands sequentially
      local aerospace_commands = table.concat(commands, " && ")
      sbar.exec(aerospace_commands, function(_, exit_code)
        if exit_code == 0 then
          logger("[WORKSPACE_MGR] Layout reset complete. Executed:\n  " ..
            aerospace_commands:gsub(" && ", "\n  && "))
        else
          logger("[WORKSPACE_MGR] Failed (exit=" .. exit_code .. "). Commands:\n  " ..
            aerospace_commands:gsub(" && ", "\n  && "))
        end
      end)
    end)
  end)
end

sbar.add("item", "aerospace.workspace_manager", { drawing = false })
    :subscribe("aerospace_reset_layout", event_handler)
