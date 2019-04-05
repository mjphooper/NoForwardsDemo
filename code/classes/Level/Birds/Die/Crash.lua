--INHERITANCE REQUIREMENTS------------------------------------------------------
local BirdDeath = require "code.classes.Level.Birds.Die.BirdDeath"
--------------------------------------------------------------------------------


local Crash = Class("Crash",BirdDeath)

function Crash:initialize(bird)
    BirdDeath.initialize(self,bird)
end

function Crash:onDeath()
    self.all_onDeath(self)
    --self.bird.animation:replaceDefault("dead")
    self.bird.animation:setDrawColor(255,255,255,120)
    self.bird.animation.rotationPoint = "middle"
    self.bird.x = self.bird.x + self.bird.w/2
    self.bird.y = self.bird.y + self.bird.h/2

end

function Crash:trashCondition()
    --Doesn't have one, as Explode trashes the bird for us!
end

function Crash:updateDeath()
    self.bird:applyDownwardForce(5)
    self.bird:applyLeftForce(30)
    self.bird:applyForces()

    --Make him spin!
    self.bird.animation:addRotation(math.pi/50)

    --The trash condition
    local w,h = self.bird.animation:getDimensions()
    if self.bird.y > self.bird.level.mapDetails.floorLevel - h then
        self.bird.deathAction = self.classes.Explode:new(self.bird)
        local w,h = self.bird.explodeAnimation:getDimensions()
        w,h = w * self.bird.level.scale.x, h * self.bird.level.scale.y
        self.bird.deathAction:onDeath(self.bird.x-(self.bird.w/2)-(w/2),self.bird.y-(self.bird.h/2)-(h/2))
    end --doesnt look clean- this is because the rotation moves the image from it's x,y. Set img position to be it's centre?
end

--@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
--STATIC FUNCTIONS@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
--@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

function Crash:requirement_loader()
    self.classes = {
        Explode = require "code.classes.Level.Birds.Die.Explode"
    }
end Crash:requirement_loader()

return Crash
