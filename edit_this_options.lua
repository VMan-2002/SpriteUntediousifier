-- [[ Sprite Untediousifier by VMan_2002 ]]
-- Version 0.2

-- [[ Controls ]]
-- I: Make the sprites
-- Q: Export individual sprites (Currently broken dont use it)
-- W: Export sprite strip for Rivals of Aether
-- F: Open work dir
-- Left/Right: Switch frames
-- Up/Down: Switch animation to export

-- Folder containing the frames to convert
current_framestrip = "broom_intro"

-- [[ What does it do ]]
-- You need Love2D from https://love2d.org/ to use this.
-- Drop your 3D renders in the folder marked with "current_framestrip"
-- and you can turn em into 2D sprites for games like Rivals of Aether
-- You need 2 sets of renders, 1 with color and 1 with "segments" which
-- are used to generate the outlines.
-- Read opt.lua in the "current_framestrip" marked folder for more info

-- Drag this folder to love.exe to start it, or you can create a shortcut