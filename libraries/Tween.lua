Tweener = Class("Tweener")

function Tweener:initialize(speed,a,b)
    self.speed = speed or 1
    --Behind the scene stuff
    self.active = false
    --Should we start now?
    self.start = a or 0
    self.finish = b or 0
end

function Tweener:startTween(a,b,speed)
    self.speed = speed or self.speed
    self.start = a
    self.start = b
end

function Tweener:update()
    if self.active then
        sef.start = deltaInc(self.start,speed)
        if self.start > self.finish then
            self.start = self.finish
        end
        return math.floor(self.start)
    end
    return self.finish
end
