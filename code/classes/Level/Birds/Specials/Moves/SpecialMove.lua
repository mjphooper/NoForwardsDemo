local SpecialMove = Class("SpecialMove")

function SpecialMove:initialize(bird)
    self.bird = bird
    self.controller = self.bird.special
    self.level = self.bird.level
    self.finished = false
end

function SpecialMove:finish()
    self.controller:reset()
    self.level.functions:resetTime()
end

function SpecialMove:onStart()
end

function SpecialMove:update()
end

function SpecialMove:draw()
end

return SpecialMove
