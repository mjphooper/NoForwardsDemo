--INHERITANCE REQUIREMENTS------------------------------------------------------
local BirdDeath = require "code.classes.Level.Birds.Die.BirdDeath"
--------------------------------------------------------------------------------

local Explode = Class("Explode",BirdDeath)

function Explode:initialize(bird)
    BirdDeath.initialize(self,bird)
    --Prepare the exploding
    self.bird.explodeAnimation = Animator:new(self.assets.yellowExplosion.default,6,{paused=false,loop=false,hibernate=true})
    local scale = love.math.random(1,1.5)
    self.bird.explodeAnimation:setDrawScale({x=scale,y=scale})
end

function Explode:chooseSign(a,b)
    if a > b then return 1 else return -1 end
end


function Explode:onDeath(x,y) --Where x,y is the centre of the explosion. If these are passed, they override all.
    self.all_onDeath(self)
    self.bird.animation = self.bird.explodeAnimation
    --Now need to adjust the position of the explode to make it correspond to the middle of the bird.
    if not notnil(x) then
        local xw,xh = self.bird.animation:getDimensions()
        self.bird.x = self.bird.x - self.chooseSign(self,xw,self.bird.w) * ((xw*self.bird.level.scale.x/2)-(self.bird.w/2))
        self.bird.y = self.bird.y - self.chooseSign(self,xh,self.bird.h) * ((xh*self.bird.level.scale.y/2)-(self.bird.h/2))
    else
        self.bird.x, self.bird.y = x,y
    end

    self.bird.animation:awake()
end

function Explode:updateDeath()
    self.bird.animation:update()
    self.trashCondition(self,self.bird.animation:isAwake())
end

--@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
--STATIC FUNCTIONS@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
--@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

function Explode:resource_loader()
    local f = "Level/Special Effects/Explosion Yellow/a"
    self.assets = {
        yellowExplosion = {
            default = {name="default",spriteTable={love.graphics.appropriateImage(f.."1.png"),
                                                   love.graphics.appropriateImage(f.."2.png"),
                                                   love.graphics.appropriateImage(f.."3.png"),
                                                   love.graphics.appropriateImage(f.."4.png")}}
        }
    }
end Explode:resource_loader()


return Explode
