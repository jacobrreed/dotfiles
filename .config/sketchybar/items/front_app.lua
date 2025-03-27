local colors = require("colors").sections.front_app

local front_app = sbar.add("item", "front_app", {
  display = "active",
  position = "center",
  icon = { drawing = false },
  label = {
    color = colors.label,
    padding_left = 15,
    padding_right = 15,
    font = {
      size = 16.0,
    },
  },
  background = {
    border_color = colors.border,
    border_width = 1,
  },
  updates = true,
})

front_app:subscribe("front_app_switched", function(env)
  sbar.exec()
  sbar.exec([[aerospace list-windows --focused --format "%{window-title}"]], function(app_name)
    front_app:set {
      label = {
        string = app_name or env.INFO,
      },
    }
  end)

  front_app:set { label = { string = env.INFO } }
end)

front_app:subscribe("mouse.clicked", function()
  sbar.trigger "swap_menus_and_spaces"
end)
