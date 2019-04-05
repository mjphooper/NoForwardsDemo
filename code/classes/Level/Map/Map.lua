local Layer = Class("Layer") --@reactive

function Layer:initialize(x,y,image,movementSpeedOffset)
    self.x = x
    self.y = y
    self.image = image
    self.movementSpeedOffset = movementSpeedOffset
end

function Layer:move(speed)
    local s = math.sign(speed)
    --Move the x axis
    self.x = time:deltaInc(self.x,-1*(speed*self.movementSpeedOffset))
    self.boundaryCheck(self)
end

function Layer:boundaryCheck()
    --Check if the right boundary has been reached.
    if self.x <= -self.image:getWidth() then self.x = 0
    --Check if the left boundary has been reached.
    elseif self.x > 0 then self.x = -self.image:getWidth()
    end
end

function Layer:draw()
    love.graphics.draw(self.image,self.x,self.y)
    love.graphics.draw(self.image,self.x+self.image:getWidth(),self.y)
end

------------------------------------------------------------------------------------------------
------------------------MAP---------------------------------------------------------------------
------------------------------------------------------------------------------------------------
local Map = Class("Map")
--Parallax layers:
--{background,background-1,background-2......foreground}
function Map:initialize(backgroundID,level)

    --Reference information
    self.level = level
    self.floorLevel = (1450/1536) * love.graphics.getHeight() / self.level.scale.y --arbitary sum for accurate scale.
    self.level.mapDetails.floorLevel = self.floorLevel


    --Generation and setup variables
    self.x = 0
    self.layers = self.generateLayers(self,backgroundID)
    self.directionBoundary = 0.3*(love.graphics.getWidth()) --1 means all reverse!

    --Speed variables
    self.speed_pixels = 0

    --Metre variables
    self.distanceTravelled_metres = 0
    self.mapSize_metres = 500

    --Pixel variables
    self.distanceTravelled_pixels = 0
    self.PIXELS_PER_METRE = 20 / self.level.scale.x
    self.mapSize_pixels = (self.mapSize_metres * self.PIXELS_PER_METRE)

    --Population variables
    self.objects = {}

    --Progress variables
    self.progress = 0


end

--GENERATION FUNCTIONS----------------------------------------------------------
--------------------------------------------------------------------------------

function Map:generateLayers(backgroundID)
    return fold(self.assets.config[backgroundID],function(layer_CONFIG) return Layer:new(0,0,layer_CONFIG.sprite,layer_CONFIG.speedOffset) end ,true)
end

function Map:populateMap()
    self.classes.collectables.MapPiece:populateMap(self)
    self.classes.collectables.Coin:populateMap(self)
    self.classes.collectables.Egg:populateMap(self)
end

--CALCULATION FUNCTIONS---------------------------------------------------------
--------------------------------------------------------------------------------
function Map:calculateProgress()
    self.progress = self.distanceTravelled_metres / self.mapSize_metres
    print("PROGRESS RETURN:"..self.progress)
    return self.progress
end

function Map:getProgress()
    return self.progress
end

function Map:calculateDecisionDistance()
    return (self.level.player.x * self.level.scale.x) - self.directionBoundary
end

function Map:calculateSpeed()
    local ref = self.calculateDecisionDistance(self)
    local scalar = ref/(self.directionBoundary)
    self.speed_pixels = self.level.player.movementSpeed * scalar * 1.5 * 10
end

function Map:metreToPixel(m)
    return m*self.PIXELS_PER_METRE
end

function Map:pixelToMetre(p)
    return p/self.PIXELS_PER_METRE
end

--UPDATE FUNCTIONS--------------------------------------------------------------
--------------------------------------------------------------------------------
function Map:move() -- +ve speed means right, -ve speed means left.
    --Progress the level
    self.distanceTravelled_pixels = math.keepPositive(time:deltaInc(self.distanceTravelled_pixels,self.speed_pixels*6))
    self.distanceTravelled_metres = math.keepPositive(self.pixelToMetre(self,self.distanceTravelled_pixels))




    --Move the layers, provided not at the ends
    print(self.speed_pixels)
    if self.distanceTravelled_metres <= 0 and self.speed_pixels < 0 then
        return
    elseif self.distanceTravelled_metres >= self.mapSize_metres and self.speed_pixels > 0 then
        return
    end
    fold(self.layers,function(layerObj) layerObj:move(self.speed_pixels) end)

end

function Map:update()
    --Apply update methods
    self.calculateSpeed(self)
    self.calculateProgress(self)
    --Update the objects in the map
    fold(self.objects,function(obj) obj:update(self.distanceTravelled_pixels) end)
    --Update the layers
    self.move(self)
    --Trash collectables

    self.classes.Collectable:collectTrash(self.objects)
end

--DRAW FUNCTIONS----------------------------------------------------------------
--------------------------------------------------------------------------------

function Map:drawMapPopulates()
    local function onScreen(x,w)
        if x > self.distanceTravelled_pixels + (love.graphics.getWidth() / self.level.scale.x) and (x + w) < self.distanceTravelled_pixels then
            return false
        end
        return true
    end
    fold(self.objects,function(obj) if onScreen(obj.x,obj.w*obj.scale.x) then obj:draw(self.distanceTravelled_pixels) end end)
end

function Map:drawProgressBar()
    setColor(0,255,0)
    love.graphics.rectangle("fill",0,0,self.progress*lg.getWidth(),25)
    flushColor()
end

function Map:draw()
    fold(self.layers,function(layerObj) layerObj:draw() end)
    self.drawMapPopulates(self)
end



--@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
--STATIC FUNCTIONS@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
--@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

function Map:requirement_loader()
    self.classes = {
        Collectable = require "code.classes.Level.Collectables.Collectable",
        collectables = {
            MapPiece = require "code.classes.Level.Collectables.MapPiece",
            Egg = require "code.classes.Level.Collectables.Egg",
            Coin = require "code.classes.Level.Collectables.Coin",
            Health = require "code.classes.Level.Collectables.Health",
            Power = require "code.classes.Level.Collectables.Power"
        }
    }
end Map:requirement_loader()

function Map:resource_loader()
    self.assets = {}
    local function lgn(n,l) return love.graphics.appropriateImage("Backgrounds/Background"..n.."/Layer-"..l..".png") end
    self.assets.config = {
        background1 = {{sprite=lgn("1","1"),speedOffset=6},{sprite=lgn("1","2"),speedOffset=5},
                       {sprite=lgn("1","3"),speedOffset=4},{sprite=lgn("1","4"),speedOffset=1},
                       {sprite=lgn("1","5"),speedOffset=0.5},{sprite=lgn("1","6"),speedOffset=0.1}},
        background2 = {{sprite=lgn("2","1"),speedOffset=6},{sprite=lgn("2","2"),speedOffset=5},
                        {sprite=lgn("2","3"),speedOffset=2}}

    }

end Map:resource_loader()


return Map
