local sbar = require("sketchybar")
local cli = require("plugins.aerospace.cli")

local event_handler = function(env)
  local target_ws = env.TARGET_WS or "1"

  -- Get focused window ID (will be nil if no window is focused, e.g., empty workspace)
  sbar.exec("aerospace list-windows --focused --format '%{window-id}'", function(focused_wid)
    focused_wid = focused_wid and tonumber(focused_wid)

    cli.fetch_workspaces(function(data)
      if not data then return end

      local window_ids = {}
      for _, item in ipairs(data) do
        if item["window-id"] then
          table.insert(window_ids, item["window-id"])
        end
      end

      if #window_ids == 0 then return end

      local moved = 0
      for _, wid in ipairs(window_ids) do
        sbar.exec("aerospace move-node-to-workspace --window-id " .. wid .. " " .. target_ws,
          function()
            moved = moved + 1
            if moved == #window_ids then
              if focused_wid then
                -- If focused_wid exists: restore focus (auto-switches to target workspace)
                sbar.exec("aerospace focus --window-id " .. focused_wid)
              else
                -- If nil: set layout explicitly (happens when no window was focused)
                sbar.exec("aerospace layout tiles accordion")
              end
            end
          end)
      end
    end)
  end)
end

sbar.add("item", "aerospace.workspace_manager", { drawing = false })
    :subscribe("aerospace_reset_layout", event_handler)
