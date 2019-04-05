--INHERITANCE REQUIREMENTS------------------------------------------------------
local Collectable = require "code.classes.Level.Collectables.Collectable"
--------------------------------------------------------------------------------

local Coin = Class("Coin",Collectable)
function Coin:initialize(map,player,x,y)
    Collectable.initialize(self,map,player,x,y,w,h)

    --Initialize the coin animation and get information from it.
    local scale = love.math.random(20,35) / 100
    local frameSpeed = love.math.random(2,4)
    self.scale = {x=scale,y=scale}

    self.animation = Animator:new(self.assets.coinAnimation.default,frameSpeed,{loop=true})
    self.animation:setDrawScale(self.scale)
    self.animation:scrambleFrames()

    self.w, self.h = self.animation:getDimensions()
    
end

function Coin:pickUp()
    self.player.coinsCollected = self.player.coinsCollected + 1
end

function Coin:update()
    self.collectable_update(self)
    self.animation:update()
end

function Coin:draw(xOffset)
    self.animation:draw(self.x-xOffset,self.y)
    self.collectable_draw(self)
end

--@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
--STATIC FUNCTIONS@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
--@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

function Coin:populateMap(map)
    for i = 0,map.mapSize_pixels,1000 do --for every segment
        local x = love.math.random(i,i+500)
        local y = love.math.random(150,map.floorLevel-300)
        local coinAdd = Coin:new(map,map.level.player,x,y)
        table.insert(map.objects,coinAdd)
    end
end

function Coin:load_resources()
    local f = "Level/Map/Collectables/Coin Animation/a"
    local lgn = love.graphics.appropriateImage
    self.assets = {
        coinAnimation = {
            default = {name="default",spriteTable={lgn(f.."1.png"),lgn(f.."2.png"),lgn(f.."3.png"),lgn(f.."4.png"),lgn(f.."5.png"),lgn(f.."6.png"),
                       lgn(f.."7.png"),lgn(f.."8.png")}}
        }
    }
end Coin:load_resources()

return Coin
