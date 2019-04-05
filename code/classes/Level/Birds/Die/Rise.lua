--INHERITANCE REQUIREMENTS------------------------------------------------------
local BirdDeath = require "code.classes.Level.Birds.Die.BirdDeath"
--------------------------------------------------------------------------------

local Rise = Class("Rise",BirdDeath)

function Rise:initialize(bird)
    BirdDeath.initialize(self,bird)
end

function Rise:onDeath()
    self.all_onDeath(self)
    --self.bird.animation:replaceDefault("dead")
    self.bird.animation:setDrawColor(255,255,255,120)
end

function Rise:updateDeath()
    self.bird.y = time:deltaDec(self.bird.y,500)
    self.trashCondition(self,(self.bird.y < -self.bird.h))
end

return Rise
