--INHERITANCE REQUIREMENTS------------------------------------------------------
local Collectable = require "code.classes.Level.Collectables.Collectable"
--------------------------------------------------------------------------------

local Power = Class("Power",Collectable)

function Power:initialize(map,player,x,y)
    Collectable.initialize(self,map,player,x,y,w,h)

    --Move the raw x and y to acommidate for the map movement
    self.x = self.x + self.map.distanceTravelled_pixels

    --Important
    local base = love.math.random()
    self.amount = 20 + (40 * base) --min of 20, max of 60.d
    local scale = (30 + (15 * base))/100
    self.scale = {x=scale,y=scale}

    --Get w and h
    self.w = self.assets.sprite:getWidth() * self.scale.x *(self.map.level.scale.x)
    self.h = self.assets.sprite:getHeight() * self.scale.y * (self.map.level.scale.y)

    --Shakey!
    self.shake = Shake:new({growth=5,amplitude=3,frequency=love.math.random(7,13)})
    self.shake:setAmount(1)
    self.shake:setAmplitude(love.math.random(70,90))

    --Fluff about starting location
    self.x = self.x + love.math.random(-40,40)
    self.y = self.y + love.math.random(-40,40)
end

 --UPDATE FUNCTIONS-------------------------------------------------------------
 -------------------------------------------------------------------------------

function Power:pickUp()
    self.player:changePower(self.amount)
end

function Power:update()
    self.collectable_update(self)
    self.shake:update()

end

 --DRAW FUNCTIONS---------------------------------------------------------------
 -------------------------------------------------------------------------------

function Power:draw(xOffset)
    self.shake:preDraw()
    love.graphics.draw(self.assets.sprite,self.x-xOffset,self.y,0,self.scale.x,self.scale.y)
    self.shake:postDraw()
end

--@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
--STATIC FUNCTIONS@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
--@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

function Power:resource_loader()
    self.assets = {
        sprite = love.graphics.appropriateImage("Level/Map/Collectables/Drops/power-up.png")
    }
end Power:resource_loader()

return Power
