Clickable = Class("Clickable")

function Clickable:initialize(x,y,w,h,scale)
    self.x, self.y = x,y
    self.w, self.h = w,h
    self.scale = scale or {x=1,y=1}

end

function Clickable:pressed() --True if pressed, false if not.
    if mouse.click then
        if (mouse.clickx > self.x and mouse.clickx < self.x + self.w)
        and(mouse.clicky > self.y and mouse.clicky < self.y + self.h) then
            return true
        end
    end
    return false
end

function Clickable:clickable_draw()

    setColor(0,255,0)
    --love.graphics.rectangle("fill",self.x,self.y-100,self.w,self.h)
    setColor(0,0,0)
    --love.graphics.circle("fill",mouse.x/self.scale.x,mouse.y/self.scale.y,20)
    flushColor()

end
