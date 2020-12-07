local a = {}

--Frame count from 1 to this
a.frames = 20

--Minimum amount of digits in a frame image name, example: 4 is 0001.png or 0020.png
a.framedigits = 4

--If not set then no outline pixel is done
a.segment_default = "none"

--What each color in the segment map does for outlines
a.segments = {
	none = {col = {0, 0, 0, 0}, tol = 30, nears = {red = true, green = true, blue = true}},
	red = {col = {206, 0, 0, 255}, tol = 30, nears = {}},
	green = {col = {0, 206, 0, 255}, tol = 30, nears = {red = true}},
	blue = {col = {0, 0, 206, 255}, tol = 30, nears = {}}
}

--Each color, the sprite colors will automatically snap to the 1st nearest color
a.cols = {
	{0, 0, 0, 0},
	{255, 0, 0, 255},
	{0, 255, 0, 255},
	{0, 0, 255, 255}
}

--How much to multiply the size of the orig image
a.scale = 1/6

return a