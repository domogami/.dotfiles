local spaces = require("items.spaces")

sbar.add("item", "space_observer", {
  drawing = false,
  updates = true,
  subscribe = { "space_windows_change" },
  script = string.format("%s/plugins/space_metadata.sh", os.getenv("CONFIG_DIR"))
})