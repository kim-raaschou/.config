local function transform(raw_workspaces)
  local workspaces = {}
  local app_entry_count = {}
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
      local app_name = item["app-name"]

      local app_entry = {
        name = app_name,
        count = 1,
        window_id = item["window-id"],
        title = item["window-title"],
        bundle_path = item["app-bundle-path"],
        bundle_id = "app." .. item["app-bundle-id"]
      }

      local ws_index = workspace_lookup[ws_key]
      table.insert(workspaces[ws_index].apps, app_entry)
      app_entry_count[app_entry.name] = (app_entry_count[app_entry.name] or 0) + 1
    end
  end

  local show_all_ws = false
  for ws_key, ws in ipairs(workspaces) do
    for _, app in ipairs(ws.apps) do
      app.count = app_entry_count[app.name]
    end

    if not show_all_ws and ws_key > 1 and #ws.apps > 0 then
      show_all_ws = true
    end
  end

  for _, ws in ipairs(workspaces) do
    ws.showable = show_all_ws;
  end

  table.sort(workspaces, function(left, right)
    local lNum, RNum = tonumber(left.id), tonumber(right.id)
    return (lNum and RNum) and (lNum < RNum) or (tostring(left.id) < tostring(right.id))
  end)

  return workspaces
end

return {
  transform = transform,
}
