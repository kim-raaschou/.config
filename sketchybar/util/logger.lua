local ENABLED = false

local function encode(obj, indent)
  indent = indent or 0
  local spacing = string.rep("  ", indent)

  if type(obj) == "table" then
    if #obj > 0 then
      -- Array
      local items = {}
      for _, v in ipairs(obj) do
        table.insert(items, encode(v, indent + 1))
      end
      return "[\n" .. spacing .. "  " .. table.concat(items, ",\n" .. spacing .. "  ") .. "\n" .. spacing .. "]"
    else
      -- Object
      local items = {}
      for k, v in pairs(obj) do
        table.insert(items, string.format('"%s": %s', k, encode(v, indent + 1)))
      end
      return "{\n" .. spacing .. "  " .. table.concat(items, ",\n" .. spacing .. "  ") .. "\n" .. spacing .. "}"
    end
  elseif type(obj) == "string" then
    return string.format('"%s"', obj)
  elseif type(obj) == "boolean" then
    return obj and "true" or "false"
  elseif type(obj) == "nil" then
    return "null"
  else
    return tostring(obj)
  end
end

return function(message, ...)
  if not ENABLED then return end

  local parts = { message }

  for i = 1, select("#", ...) do
    local arg = select(i, ...)
    if type(arg) == "table" then
      table.insert(parts, " " .. encode(arg, 0))
    else
      table.insert(parts, " " .. tostring(arg))
    end
  end

  print(os.date("%H:%M:%S") .. " " .. table.concat(parts))
end
