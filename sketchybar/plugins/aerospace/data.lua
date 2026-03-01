local function transform(raw_workspaces)
  local workspaces = {}
  local workspace_lookup = {}

  for _, item in ipairs(raw_workspaces or {}) do
    local ws_key = tostring(item.workspace)

    if not workspace_lookup[ws_key] then
      table.insert(workspaces, {
        id = item.workspace,
        display = item["monitor-appkit-nsscreen-screens-id"],
        focused = item["workspace-is-focused"] or false,
        apps = {}
      })
      workspace_lookup[ws_key] = #workspaces
    end

    if item["app-name"] then
      local ws_index = workspace_lookup[ws_key]
      table.insert(workspaces[ws_index].apps, {
        name = item["app-name"],
        count = 1,
        window_id = item["window-id"],
        title = item["window-title"],
        bundle_path = item["app-bundle-path"],
        bundle_id = "app." .. item["app-bundle-id"]
      })
    end
  end

  table.sort(workspaces, function(left, right)
    if left.focused ~= right.focused then return left.focused end
    local l_num, r_num = tonumber(left.id), tonumber(right.id)
    if l_num and r_num then return l_num < r_num end
    return tostring(left.id) < tostring(right.id)
  end)

  return workspaces
end

return {
  transform = transform,
}
