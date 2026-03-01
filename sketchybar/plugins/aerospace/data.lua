local function transform(raw_workspaces)
  local workspaces = {}
  local workspace_lookup = {}
  local app_counts = {}

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
      local bundle_id = "app." .. item["app-bundle-id"]
      app_counts[bundle_id] = (app_counts[bundle_id] or 0) + 1

      local ws_index = workspace_lookup[ws_key]
      table.insert(workspaces[ws_index].apps, {
        name = item["app-name"],
        window_id = item["window-id"],
        title = item["window-title"],
        bundle_path = item["app-bundle-path"],
        bundle_id = bundle_id
      })
    end
  end

  for _, ws in ipairs(workspaces) do
    for _, app in ipairs(ws.apps) do
      app.count = app_counts[app.bundle_id] or 0
    end
  end

  table.sort(workspaces, function(left, right)
    local l_num, r_num = tonumber(left.id), tonumber(right.id)
    if l_num and r_num then return l_num < r_num end
    return tostring(left.id) < tostring(right.id)
  end)

  return workspaces
end

return {
  transform = transform,
}
