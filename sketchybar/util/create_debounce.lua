local sbar = require("sketchybar")
local logger = require("util.logger")

return function()
  local timer_id = 0

  return function(delay, fn)
    return function(...)
      local args = { ... }
      local current_id = timer_id + 1
      timer_id = current_id

      logger(string.format("[DEBOUNCE] Schedule #%d (%.2fs)", current_id, delay))

      sbar.delay(delay, function()
        if timer_id == current_id then
          logger(string.format("[DEBOUNCE] Execute #%d", current_id))
          fn(table.unpack(args))
        else
          logger(string.format("[DEBOUNCE] Cancel #%d (now #%d)", current_id, timer_id))
        end
      end)
    end
  end
end
