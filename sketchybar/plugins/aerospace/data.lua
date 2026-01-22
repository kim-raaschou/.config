local function transform(raw_workspaces)
  local workspaces = {}
  local app_entry_count = {}
  local workspace_lookup = {}
  local app_lookup = {}

  for _, item in pairs(raw_workspaces or {}) do
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
      local lookup_key = ws_key .. ":" .. app_name
      local app_entry = app_lookup[lookup_key]

      if not app_entry then
        app_entry = {
          name = app_name,
          count = 0,
          windows = {},
          bundle_id = "app." .. item["app-bundle-id"],
          bundle_path = item["app-bundle-path"]
        }

        local ws_index = workspace_lookup[ws_key]
        table.insert(workspaces[ws_index].apps, app_entry)
        app_lookup[lookup_key] = app_entry
      end

      app_entry_count[app_entry.name] = (app_entry_count[app_entry.name] or 0) + 1

      table.insert(app_entry.windows, {
        id = item["window-id"],
        title = item["window-title"]
      })
    end
  end

  for _, ws in ipairs(workspaces) do
    for _, app in ipairs(ws.apps) do
      app.count = app_entry_count[app.name] or 0
    end
  end

  return workspaces
end

return {
  transform = transform,
}
