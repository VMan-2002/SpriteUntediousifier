local a = {}

--Frame count from 1 to this
a.frames = 30

--Minimum amount of digits in a frame image name, example: 4 is 0001.png or 0020.png
a.framedigits = 4

--If not set then no outline pixel is done
a.segment_default = "none"

--Start and end frames of seprated animations
a.anims = {
	broom_intro = {1, 15},
	dspecial = {16, 30}
}

--What each color in the segment map does for outlines
a.segments = {
	none = {col = {0, 0, 0, 0}, tol = 30, nears = {red = true, green = true, blue = true, cyan = true, yellow = true, pink = true}},
	red = {col = {206, 0, 0, 255}, tol = 90, nears = {}}, --fr leg
	green = {col = {0, 206, 0, 255}, tol = 90, nears = {red = true}}, --bl leg
	blue = {col = {1, 1, 207, 255}, tol = 90, nears = {red = true, green = true}}, --head
	cyan = {col = {0, 207, 207, 255}, tol = 90, nears = {blue = true, red = true, yellow = true}}, --fl leg
	yellow = {col = {207, 207, 0, 255}, tol = 90, nears = {blue = true, red = true}}, --br leg
	pink = {col = {207, 0, 207, 255}, tol = 90, nears = {blue = true, green = true}} --broom
}

--Each color, the sprite colors will automatically snap to the 1st nearest color
a.cols = {
	{0, 0, 0, 0},
	{144, 65, 20, 255},
	{109, 40, 11, 255},
	{76, 21, 6, 255},
	{166, 166, 166, 255},
	{76, 76, 76, 255}
}

--How much to multiply the size of the orig image
a.scale = 1/5

return a