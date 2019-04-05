local Level = Class("Level")

function Level:initialize() --Everything in here should be shared data between the classes. NOT SHARED? PLACE SOMEWHERE MORE SPEICIFC.
    --Scaling
    self.scale = mapScale
    self.functions = self.classes.LevelFunctions:new(self)

    --Spawn variables
    self.spawnCounter = 0
    self.spawnRate = 0 --spawn one every n seconds
    self.maxEnemies = 5

    --Is the level active?
    self.active = true --used to prevent events such as shooting bullets etc.

    --Initialize the shared information
    self.mapDetails = {}
    self.friendlyProjectiles = {}
    self.enemyProjectiles = {}
    self.friendlyBirds = {}
    self.enemyBirds = {}

    --Initialize the level effects
    self.shake = Shake:new({growth=5,amplitude=1,frequency=50})

    --Time!
    self.time = 1
    self.paused = false

    --Initialize the objects that will be used in the level.
    self.map = self.classes.Map:new("background1",self)
    self.enemyStream = self.classes.EnemyStream:new(self)
    self.player = self.classes.Player:new({mass=250,x=100,y=50},self,{x=0.6,y=0.6})
    self.map:populateMap()

    --Table containing the decorations
    self.decorations = {}

    --Vars about the drawing w/ shaders.
    self.backgroundShader = shaders.blur
    self.foregroundShader = nil

    --Initialize the GUI
    self.gui = self.classes.GUI:new(self)

    --Things to take away
    self.mapsCollected = 0

end



function Level:update(dt)
    --Scale the mouse
    self.functions:scaleMouse()

    --Set the time
    time:push(self.time)

    --Update the single objects
    self.gui:update()
    --self.player:update()
    self.map:update()
    self.enemyStream:update()
    self.functions:updateShake()

    --Update all projectile objects
    fold(self.friendlyProjectiles,function(missileObj) missileObj:update() end )
    self.classes.Projectile:collectTrash(self.friendlyProjectiles) --Trash must be collected seperately to avoid problems with the table.
    fold(self.enemyProjectiles,function(missileObj) missileObj:update() end )
    self.classes.Projectile:collectTrash(self.enemyProjectiles) --Trash must be collected seperately to avoid problems with the table.

    --Update all friendly & unfriendly bird objects
    fold(self.friendlyBirds,function(bird) bird:update() end)
    fold(self.enemyBirds,function(bird) bird:update() end)
    self.player:update()

    --Update the decorations
    fold(self.decorations,function(decoration) decoration:update() end)
    self.classes.Decoration:collectTrash(self.decorations)

    --Check for pause!
    self.functions:togglePause()

    --Update the shader code
    shaders.grayscale:send("factor",self.functions:calculateShaderLevel())

    --reset time
    time:pop()

    --Reset with r!
    if keyboard.keyDown == "r" then
        self.player:initialize({mass=250,x=100,y=50},self,{x=0.6,y=0.6})
    end
    --SPAWNING CHEETS
    if keyboard.keyDown == "left" then (require "code.classes.Level.Birds.FriendlyBird"):generateNew("player1",self,30,30)
    elseif keyboard.keyDown == "right" then (require "code.classes.Level.Birds.EnemyBird"):generateNew(self) end


end

function Level:draw()
    --DRAW THINGS TO BE A PART OF THE BLUR
    --self.backgroundShader(function()


        love.graphics.push()
        love.graphics.setShader(shaders.grayscale)
        love.graphics.scale(self.scale.x,self.scale.y)
        self.shake:preDraw()

        --Draw map
        self.map:draw()
        --Draw all projectile objects
        fold(self.friendlyProjectiles,function(missileObj) missileObj:draw() end)
        fold(self.enemyProjectiles,function(missileObj) missileObj:draw() end)
        --Draw all bird objects
        fold(self.friendlyBirds,function(bird) bird:draw() end)
        fold(self.enemyBirds,function(bird) bird:draw() end)
        --Draw the decorations
        fold(self.decorations,function(decoration) decoration:draw() end)

        self.shake:postDraw()
        love.graphics.pop()
    --end)

    love.graphics.scale(self.scale.x,self.scale.y)
    self.player:draw()
    self.gui:draw()


    --Draw the wave controller
    --self.waveController:draw()

    if love.keyboard.isDown("`") then self.drawDebug(self) end
end








function Level:drawDebug()
    --GRAPHICAL DEBUGG
    lg.rectangle("fill",0,0,100,80)
    setColor(0,0,0)
    love.graphics.print("frames.."..love.timer.getFPS(),10,10)
    love.graphics.print("scale.."..math.round(self.scale.x,2).." "..math.round(self.scale.y,2),10,30)
    love.graphics.print(love.graphics.getWidth().."x"..love.graphics.getHeight(),10,50)
    flushColor()
    --AI TARGETING DEBG
    local function visualizeTargeting(ls,col,t)
        for i=1,#ls,1 do
            local bird = ls[i]
            setColor(col)
            love.graphics.setLineWidth(4)
            if #bird.targets > 0 then
                lg.push()
                lg.scale(self.scale.x,self.scale.y)
                local oy = 0
                if t == "enemy" then oy = 10 end
                for i=1,#bird.targets,1 do
                    love.graphics.line(bird.x+bird.w/2,bird.y+bird.h/2-oy,bird.targets[i].x+bird.targets[i].w/2 ,bird.targets[i].y+bird.targets[i].h/2-oy)
                end
                lg.pop()
            end
            flushColor()
        end
    end

    visualizeTargeting(self.enemyBirds,{255,0,0},"enemy")
    visualizeTargeting(self.friendlyBirds,{0,0,255},"friendly")
end


--@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
--STATIC FUNCTIONS@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
--@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

function Level:requirement_loader()
    self.classes = {
        LevelFunctions = require "code.classes.Level.LevelFunctions",
        Map = require "code.classes.Level.Map.Map",
        GUI = require "code.classes.Level.GUI.GUI",
        EnemyStream = require "code.classes.Level.Map.EnemyStream",
        Player = require "code.classes.Level.Birds.Player",
        Boss = require "code.classes.Level.Birds.Boss",
        Decoration = require "code.classes.Level.Decoration.Decoration",
        Projectile = require "code.classes.Level.Birds.Weapons and Projectiles.Projectile"
    }
end Level:requirement_loader()

return Level
