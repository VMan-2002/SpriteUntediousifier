-- [[ Sprite Untediousifier by VMan_2002 ]]
-- Version 0.2

-- [[ Controls ]]
-- I: Make the sprites
-- Q: Export individual sprites (Currently broken dont use it)
-- W: Export sprite strip for Rivals of Aether
-- F: Open work dir
-- Left/Right: Switch frames
-- Up/Down: Switch animation to export

require("edit_this_options")

local infotx

function love.load()
	love.graphics.setDefaultFilter("nearest", "nearest")
	infotx = table.concat({
		"Welcome to Sprite Untediousifier.",
		"Drag your project folder here, or continue reading to to learn how to use this.",
		"--------",
		"Press F to open the dedicated folder.",
		"To do: Instructions"
	}, "\n")
	imagename = "unnamed_sprite"
	anx = 1
	love.keypressed("i")
end

function love.draw()
	if abp then
		local bright = 0.5 + (math.sin(love.timer.getTime() * 3) / 24)
		love.graphics.clear(bright, bright, bright)
		love.graphics.draw(frames[frame], 0, 20)
		love.graphics.draw(color_orig[frame], 0, 20)
		love.graphics.print("Current anim export: "..anx.." ("..animnames[anx]..")")
	else
		love.graphics.print("Current Name: "..imagename)
		love.graphics.print(infotx, 0, 60)
	end
end

function love.keypressed(a)
	if (a == "f") then
		love.filesystem.write("", "")
		love.system.openURL("file://"..love.filesystem.getSaveDirectory())
	end
	if (a == "right") then
		frame = frame + 1
		if (frame > #frames) then
			frame = 1
		end
	elseif a == "left" then
		frame = frame - 1
		if (frame < 1) then
			frame = #frames
		end
	end
	if (a == "up") then
		anx = anx + 1
		if (anx > animcount) then
			anx = 1
		end
	elseif a == "down" then
		anx = anx - 1
		if (anx < 1) then
			anx = animcount
		end
	end
	if a == "q" then
		for k, v in pairs(frames) do
			v:encode("png", "ExportedFrames_"..current_framestrip.."/".."Frame"..k..".png")
		end
		love.window.showMessageBox("Success", "Successfully made exported images")
	end
	if a == "w" then
		local imw = frames[1]:getWidth()
		local animrange = anims[animnames[anx]]
		local fcount = (1 + animrange[2] - animrange[1])
		local strip = SetNewCanvas(imw * 2 * fcount, frames[1]:getHeight()*2)
		local n = 0
		for i = animrange[1], animrange[2] do
			love.graphics.draw(frames[i], imw * n * 2, 0, 0, 2, 2)
			n = n + 1
		end
		love.graphics.setCanvas()
		strip:newImageData():encode("png", animnames[anx].."_strip"..fcount..".png")
		love.window.showMessageBox("Success", "Successfully made the RoA sprite")
	end
	if (a == "i") then
		frame = 1
		frames = {}
		local spriteorig = {}
		color_orig = {}
		local options = require(current_framestrip.."/opt")
		local timelast = love.timer.getTime()
		for i = 1, options.frames do
			local aname = string.rep("0", math.max(4 - string.len(i), 0))..i..".png"
			spriteorig[#spriteorig + 1] = love.graphics.newImage(current_framestrip.."/segment/"..aname)
			abp = love.image.newImageData(math.ceil(spriteorig[1]:getPixelWidth() * options.scale), math.ceil(spriteorig[1]:getPixelHeight() * options.scale))
			cbp = love.image.newImageData(math.ceil(spriteorig[1]:getPixelWidth() * options.scale), math.ceil(spriteorig[1]:getPixelHeight() * options.scale))
			color_orig[#color_orig + 1] = love.graphics.newImage(current_framestrip.."/color/"..aname)
			orig_dp = ImageToImageData(color_orig[i])
			LoadingBar(i, options.frames, love.timer.getTime() - timelast)
			timelast = love.timer.getTime()
			local bdp = ImageToImageData(spriteorig[i])
			--[[bdp:mapPixel(function(x, y, r, g, b, a)
				local seg = GetSegment(r, g, b, a, options)
				if seg then
					local outline = false
					local left = SegmentPixel(bdp, x-1, y, options)
					local right = SegmentPixel(bdp, x+1, y, options)
					local up = SegmentPixel(bdp, x, y-1, options)
					local down = SegmentPixel(bdp, x, y+1, options)
					local segdata = options.segments[seg]
					if segdata.nears[left] or segdata.nears[right] or segdata.nears[up] or segdata.nears[down] then
						outline = true
						abp:setPixel(math.floor(x*options.scale), math.floor(y*options.scale), 0, 0, 0, 1)
					end
					--abp:setPixel(math.floor(x*options.scale), math.floor(y*options.scale), r, g, b, a)
				end
				return r, g, b, a
			end)]]
			mvscale = 1
			--shrink segment map
			bdp:mapPixel(function(x, y, r, g, b, a)
				local px, py = math.floor(x*options.scale), math.floor(y*options.scale)
				--local apix = {abp:getPixel(px, py)}
				--if (apix[4] > 0) then
					abp:setPixel(px, py, r, g, b, a)
				--end
				--return 0, 0, 0, 0
				return r,g,b,a
			end)
			segfound = {}
			--generate outline
			abp:mapPixel(function(x, y, r, g, b, a)
				local seg = GetSegment(r, g, b, a, options)
				if not segfound[seg] then
					segfound[seg] = 1
				else
					segfound[seg] = segfound[seg] + 1
				end
				if seg then
					local left = SegmentPixel(abp, x-mvscale, y, options)
					local right = SegmentPixel(abp, x+mvscale, y, options)
					local up = SegmentPixel(abp, x, y-mvscale, options)
					local down = SegmentPixel(abp, x, y+mvscale, options)
					local segdata = options.segments[seg]
					if segdata.nears[left] or segdata.nears[up] then
						cbp:setPixel(x, y, 0, 0, 0, 1)
					end
					if segdata.nears[down] then
						cbp:setPixel(x, y+1, 0, 0, 0, 1)
					end
					if segdata.nears[right] then
						cbp:setPixel(x+1, y, 0, 0, 0, 1)
					end
				end
				--return color_orig:getPixel(math.floor(x*options.scale), math.floor(y*options.scale))
				return r, g, b, a
			end)
			--generate pixels
			cbp:mapPixel(function(x, y, r, g, b, a)
				if a == 0 then
					--local bpix = {orig_dp:getPixel(math.floor(x/options.scale), math.floor(y/options.scale))}
					--return bpix[1], bpix[2], bpix[3], bpix[4]
					return 0, 0, 0, 0
				end
				return 0, 0, 0, 1
			end)
			--add colors
			colfound = {}
			orig_dp:mapPixel(function(x, y, r, g, b, a)
				local xp, yp = math.floor(x*options.scale), math.floor(y*options.scale)
				local cpix = {cbp:getPixel(xp, yp)}
				if (cpix[4] < 0.1) then
					local colnum = GetCol(r, g, b, a, options.cols)
					if not colfound[colnum] then
						colfound[colnum] = 1
					else
						colfound[colnum] = colfound[colnum] + 1
					end
					local col = options.cols[colnum]
					if (col[4] > 0.1) then
					--print("setting pixel", col[1], col[2], col[3], col[4])
					end
					cbp:setPixel(xp, yp, col[1] / 255, col[2] / 255, col[3] / 255, col[4] / 255)
				end
				return r, g, b, a
			end)
			dbp = love.graphics.newImage(cbp)
			frames[#frames+1] = dbp
		end
		for k, v in pairs(segfound) do
			print("Segment px count", k, v)
		end
		for k, v in pairs(colfound) do
			print("Color px count", k, v)
		end
		local t = {}
		anims = options.anims or {[current_framestrip] = {1, #frames}}
		animnames = {}
		for k, v in pairs(anims) do
			animnames[#animnames + 1] = k
			print("Anim name", k)
		end
		animcount = #animnames
	end
end

function SegmentPixel(idat, x, y, opt)
	if x < 0 or y < 0 or x >= idat:getWidth() or y >= idat:getHeight() then
		return nil
	end
	local r, g, b, a = idat:getPixel(x, y)
	return GetSegment(r, g, b, a, opt)
end

function love.filedropped()
	
end

function SetNewCanvas(w, h)
	local a = love.graphics.newCanvas(w, h)
	love.graphics.setCanvas(a)
	return a
end

function ImageToImageData(image)
	local a = SetNewCanvas(image:getPixelDimensions())
	love.graphics.draw(image)
	love.graphics.setCanvas()
	return a:newImageData()
end

function GetNumberDistance(a, b)
	return math.abs(a - b)
end

function GetSegment(r, g, b, a, opt)
	local ab = opt.segment_default
	for k, v in pairs(opt.segments) do
		if GetNumberDistance(r*255, v.col[1]) + GetNumberDistance(g*255, v.col[2]) + GetNumberDistance(b*255, v.col[3]) + GetNumberDistance(a*255, v.col[4]) <= v.tol then
			ab = k
			break
		end
	end
	return ab
end

function GetCol(r, g, b, a, cols)
	local ab = 0
	local near = 9999
	colfound = colfound or {}
	for k, v in pairs(cols) do
		local thisnear = GetNumberDistance(r*255, v[1]) + GetNumberDistance(g*255, v[2]) + GetNumberDistance(b*255, v[3]) + GetNumberDistance(a*255, v[4])
		if thisnear < near then
			ab = k
			near = thisnear
		end
		if near == 0 then
		break
		end
	end
	return ab
end

function LoadingBar(cur, targ, timelast)
	love.graphics.clear(0, 0, 0)
	love.graphics.rectangle("line", 50, 50, 200, 30)
	love.graphics.rectangle("fill", 50, 50, 200 * (cur / targ), 20)
	love.graphics.print(cur .. "/" .. targ, 50, 90)
	if (timelast) then
		love.graphics.print(timelast * ((targ+1) - cur).." seconds left", 50, 110)
	end
	love.graphics.present()
end