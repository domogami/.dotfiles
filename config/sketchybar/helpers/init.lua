-- Launchd provides HOME reliably, while USER may be unset for background agents.
local home = os.getenv("HOME")
if not home then
  local user = os.getenv("USER")
  if user then
    home = "/Users/" .. user
  else
    error("Neither HOME nor USER is available for SketchyBar Lua setup")
  end
end

local config_dir = os.getenv("CONFIG_DIR") or (home .. "/.config/sketchybar")

package.cpath = package.cpath .. ";" .. home .. "/.local/share/sketchybar_lua/?.so"

os.execute('(cd "' .. config_dir .. '/helpers" && make)')
