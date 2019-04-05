local BirdDeath = Class("BirdDeath")

function BirdDeath:initialize(bird)
    self.bird = bird
end

function BirdDeath:pollForDeath()
    if self.bird.dead then return true end
    if self.bird:isDead() then
        self.onDeath(self)
        return true
    end
    return false
end

function BirdDeath:trashCondition(bool)
    if bool then
        self.bird:discard()
    end
end

--FUNCTIONS TO BE OVERRIDEN IN SUPER.

function BirdDeath:all_onDeath() --The one time event to run once the bird has died.
    self.bird.dead = true
    self.bird.targets = {}
end

function BirdDeath:updateDeath()
end

function BirdDeath:drawDeath()
end


--EZ branching funciton
function BirdDeath:branch(f)
    if self.bird.dead then
        if f == "update" then self.update(self)
        elseif f == "draw" then self.draw(self) end
        return true
    end
    self.pollForDeath(self)
    return false
end

--UPDATE & DRAW

function BirdDeath:update()
    self.updateDeath(self)
end

function BirdDeath:draw()
    self.drawDeath(self)
end


--@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
--STATIC FUNCTIONS@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
--@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

return BirdDeath
