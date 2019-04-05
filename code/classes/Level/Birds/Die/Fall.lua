--INHERITANCE REQUIREMENTS------------------------------------------------------
local BirdDeath = require "code.classes.Level.Birds.Die.BirdDeath"
--------------------------------------------------------------------------------

local Fall = Class("Fall",BirdDeath)

function Fall:initialize(bird)
    BirdDeath.initialize(self,bird)
end

function Fall:onDeath()
    self.all_onDeath(self)
    --self.bird.animation:replaceDefault("dead")
    self.bird.animation:setDrawColor(255,255,255,120)
end

function Fall:updateDeath()
    self.bird:applyDownwardForce(5)
    self.bird:applyForces()
    self.bird.animation:setDrawColor(255,255,255,time:deltaDec(self.bird.animation.drawColor.a,100))
    self.trashCondition(self,self.bird.animation.drawColor.a <= 0)

end

function Fall:drawDeath()
end

return Fall
