local state = {}
local source_dir = debug.getinfo(1, 'S').source:sub(2):match('(.*/)')

vis.events.subscribe(vis.events.FILE_OPEN, function(file)
  if not file.path then
    return
  end
  local cr = file.lines[0]:find('\r$')
  local bom = file.lines[0]:find('^\239\187\191')
  state[file.path] = {
    cr = cr,
    bom = bom,
  }
  -- Don't bother removing just the BOM - it's not as annoying
  if cr then
    local crs = {}
    local pos = 0
    for line in file:lines_iterator() do
      local len = #line
      pos = pos + len
      if line:sub(len, len) == '\r' then
        table.insert(crs, pos)
      end
    end
    for _, dpos in ipairs(crs) do
      file:delete(dpos - 1, 1)
    end
    if bom then
      file:delete(0, 3)
    end
    file.modified = false
  end
end)

vis.events.subscribe(vis.events.FILE_CLOSE, function(file)
  if not file.path then
    return
  end
  if state[file.path].cr then
    vis:pipe(file, { start = 0, finish = 0 }, [[
      sh ']] .. source_dir:gsub("'", "'\\''") .. [[/txtconv/txtconv.sh' \
        -i]] .. (state[file.path].bom and 'b' or '') .. [[c \
        ']] .. file.path:gsub("'", "'\\''") .. [['
    ]])
  end
end)
