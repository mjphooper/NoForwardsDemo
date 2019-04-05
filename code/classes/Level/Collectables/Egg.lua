--INHERITANCE REQUIREMENTS------------------------------------------------------
local Collectable = require "code.classes.Level.Collectables.Collectable"
--------------------------------------------------------------------------------

local Egg = Class("Egg",Collectable)

function Egg:initialize(eggIdentity,map,player,x,y) --where eggIdentity is a string of either "player1", "player2" etc.
    Collectable.initialize(self,map,player,x,y)
    self.x = x
    self.y = y

    --Calculate which bird the egg belongs to!
    self.identity = eggIdentity
    self.sprite = self.assets.eggs[self.identity] --Which player is this egg.

    --Get w and h
    self.w = self.sprite:getWidth() * (self.map.level.scale.x)
    self.h = self.sprite:getHeight() * (self.map.level.scale.y)

    --Shakey!
    self.eggShake = Shake:new({growth=5,amplitude=3,frequency=love.math.random(7,13)})
    self.eggShake:setAmount(1)
    self.eggShake:setAmplitude(love.math.random(70,90))

end

function Egg:pickUp()
    --DO SOMETHING TO ADD THE EGG TO THE HATCH PILE.
end

function Egg:update(xOffset)
    self.collectable_update(self)
    self.eggShake:update()
end

function Egg:draw(xOffset)
    self.eggShake:preDraw()
    love.graphics.draw(self.sprite,self.x-xOffset,self.y,0,1/self.map.level.scale.x,1/self.map.level.scale.y)
    self.eggShake:postDraw()

end


--@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
--STATIC FUNCTIONS@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
--@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

function Egg:populateMap(map)
    local eggNumber = love.math.random(6,12)
    for i = 1,eggNumber,1 do
        local x = love.math.random(love.graphics.getWidth(),map.mapSize_pixels)
        local y = love.math.random(150,map.floorLevel-300)
        local possibleEggs = {"player1","player2","player3","player4","player5"}
        local eggAdd = Egg:new(possibleEggs[love.math.random(1,#possibleEggs)],map,map.level.player,x,y)
        table.insert(map.objects,eggAdd)
    end
end

function Egg:resource_loader()
    self.assets = {
        eggs = {
            player1 = love.graphics.appropriateImage("Birds/FriendlyPlayers/Player 1/Egg.png"),
            player2 = love.graphics.appropriateImage("Birds/FriendlyPlayers/Player 2/Egg.png"),
            player3 = love.graphics.appropriateImage("Birds/FriendlyPlayers/Player 3/Egg.png"),
            player4 = love.graphics.appropriateImage("Birds/FriendlyPlayers/Player 4/Egg.png"),
            player5 = love.graphics.appropriateImage("Birds/FriendlyPlayers/Player 5/Egg.png"),
        }
    }
end Egg:resource_loader()

return Egg
