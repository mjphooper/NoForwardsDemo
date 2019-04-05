--Very, very, VERY initializy things.
io.stdout:setvbuf("no")




local function load_requires()
	--External library requires--Global classes-------------------------------------
	--------------------------------------------------------------------------------
	Class = require 'libraries.Middleclass'
	Animations = require 'libraries.Animator'
	Queue = require "libraries.Queue"
	Stack = require "libraries.Stack"
	Shake = require "libraries.Shake"
	Moonshine = require "libraries.Moonshine"


	--Custom requires---------------------------------------------------------------
	--------------------------------------------------------------------------------
	require "code.standalone.resources.resource_loader"
	require "code.standalone.functions"
	require "code.standalone.shaders"

	--Global classes----------------------------------------------------------------
	--------------------------------------------------------------------------------
	--GUI
	require "code.classes.GUI.Parents"
	require "code.classes.GUI.Button"
	require "code.classes.GUI.Container"
	require "code.classes.GUI.ItemWheel"
	require "code.classes.GUI.Draggable"
	--General
	require "code.classes.SimpleGravityObject"
	require "code.classes.StateController"
	require "code.classes.CirclePosition"
	require "code.classes.PlayerData"
	require "code.classes.Time"

end



--@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
--------------------------------------------------------------------------------
--MAIN.LUA------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@


function love.load()
	local sizes = {{x=1366,y=768},{x=1920,y=1080},{x=4096,y=1536},{x=400,y=300}}
	standardSize = sizes[2]
	love.window.setMode(standardSize.x,standardSize.y,{fullscreen=false,vsync=true})
	--SHORTCUTS
	lg = love.graphics
	--LOAD GLOBAL THINGS
	arrangeSize()
	load_requires()

	f = 0
	--Helpful global constants
	gravity = 6.67
	time = Time:new()

	fps = {draw = function() lg.printcustom(love.timer.getFPS(),10,10,{0,0,0},fonts.large) end}
	--Glboal classes
	playerData = PlayerData:new()
	stateControl = StateController:new("level")
	--Mouse
	mouse.setVisible(true)

	--Test area

end


function love.update(dt)
	globaldt = dt
	stateControl:update(dt)
	mouse.update()
	keyboard.update()
end

function love.draw(dt)
	stateControl:draw()
end

function love.focus(f)
	if not f then
		love.event.quit()
	end
end

function love.keypressed(k)
	keyboard.keyDown = k
end

--Unlövely functions.

local function findNearestSize() --This is all going to be in terms of height. Assumes a 16:9 resolution!
	local rawScreenHeight = love.graphics.getHeight()
	local possibleSizes = {"small","medium"}
	local matchings = {small={x=2048,y=768},medium={x=2880,y=1080}}
	for i = 1,#possibleSizes,1 do
		if rawScreenHeight <= matchings[possibleSizes[i]].y then --if height <= each size, then we match to that! so we always downscale asap.
			return {size=possibleSizes[i],mapSize=matchings[possibleSizes[i]]}
		end
	end
	return {size="large",mapSize={x=4096,y=1536}}
end


function arrangeSize()
	--Decide the asset size depending on the screen.
	local sizing = findNearestSize()
	sizing = {size="large",mapSize={x=4096,y=1536}}
	assetSize, mapSize = sizing.size, sizing.mapSize

	--assetSize = "large";mapSize = {x=4096,y=1536}

    mapScale = {
        x = (love.graphics.getHeight() * (2048/768)) / mapSize.x, --The sum being the map scalar ration, how many x's per y.
        y = love.graphics.getHeight() / mapSize.y
    }

end






--[[ barry the bear

_
(\\  _                      ___
.-"`"(\\                _.""`   `"-.
/      ` `-._        _.-"            `\__
6   6)        `-.__.-'                    `",
/                                         `;-`
/     ,                                     |
()    /  /`                                  |
`---`"~``\                                  |
	\                                 |
	 \            \      /           /
	 /`,   ,      |     |           /
	/   "-.|      |     |         /'
   /     / |     /,__   |       /`\
jgs /    /'  |    /    `"'\      (   \
__/   /'    |   |         `\     \   \
\    /      |   |           `\    \   \
`-,/      /    |            /     |-"`
		 `"""^^^           `^^""""`
]]
