return {
	black = 0xff212337,
	white = 0xffebfafa,
	red = 0xfff16c75,
	pink = 0xfff265b5,
	green = 0xff37f499,
	blue = 0xff04d1f9,
	yellow = 0xfff1fc79,
	orange = 0xfff7c67f,
	magenta = 0xff04d1f9,
	grey = 0xff7081d0,
	transparent = 0x00000000,

	bar = {
		bg = 0xf0212337,
		border = 0xffa48cf2,
	},
	popup = {
		bg = 0xc02c2e34,
		border = 0xff7f8490,
	},
	bg1 = 0xff212337,
	bg2 = 0xff323449,

	with_alpha = function(color, alpha)
		if alpha > 1.0 or alpha < 0.0 then
			return color
		end
		return (color & 0x00ffffff) | (math.floor(alpha * 255.0) << 24)
	end,
}
