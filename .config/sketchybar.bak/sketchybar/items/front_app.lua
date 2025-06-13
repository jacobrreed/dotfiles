local colors = require("colors")
local settings = require("settings")

local front_app = sbar.add("item", "front_app", {
	position = "center",
	display = "active",
	icon = { drawing = false },
	label = {
		color = colors.green,
		font = {
			style = settings.font.style_map["Black"],
			size = 16.0,
		},
	},
	updates = true,
})

front_app:subscribe("front_app_switched", function(env)
	front_app:set({ label = { string = env.INFO } })
end)

front_app:subscribe("mouse.clicked", function(env)
	sbar.trigger("swap_menus_and_spaces")
end)
