--INHERITANCE REQUIREMENTS------------------------------------------------------
local Collectable = require "code.classes.Level.Collectables.Collectable"
--------------------------------------------------------------------------------

local Health = Class("Health",Collectable)

function Health:initialize(map,player,x,y)
    Collectable.initialize(self,map,player,x,y,w,h)

    --Move the raw x and y to acommidate for the map movement
    self.x = self.x + self.map.distanceTravelled_pixels

    --Important
    local base = love.math.random()
    self.amount = 20 + (40 * base) --min of 20, max of 60.
    local scale = (30 + (15 * base))/100
    self.scale = {x=scale,y=scale}

    --Get w and h
    self.w = self.assets.sprite:getWidth() * self.scale.x *(self.map.level.scale.x)
    self.h = self.assets.sprite:getHeight() * self.scale.y * (self.map.level.scale.y)

    --Shakey!
    self.shake = Shake:new({growth=5,amplitude=3,frequency=love.math.random(7,13)})
    self.shake:setAmount(1)
    self.shake:setAmplitude(love.math.random(70,90))
end

 --UPDATE FUNCTIONS-------------------------------------------------------------
 -------------------------------------------------------------------------------

function Health:pickUp()
    self.player:changeHealth(self.amount)
end

function Health:update()
    self.collectable_update(self)
    self.shake:update()

end

 --DRAW FUNCTIONS---------------------------------------------------------------
 -------------------------------------------------------------------------------

function Health:draw(xOffset)
    self.shake:preDraw()
    love.graphics.draw(self.assets.sprite,self.x-xOffset,self.y,0,self.scale.x,self.scale.y)
    self.shake:postDraw()
end

--@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
--STATIC FUNCTIONS@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
--@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

function Health:resource_loader()
    self.assets = {
        sprite = love.graphics.appropriateImage("Level/Map/Collectables/Drops/health.png")
    }
end Health:resource_loader()

return Health
