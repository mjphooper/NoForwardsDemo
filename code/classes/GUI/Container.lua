--CONTAINER---------------------------------------------------------------------
--------------------------------------------------------------------------------
Container = Class("Container")

function Container:initialize(x,y,backing) --blah:new(w,x,y,z...):draw()
    self.contents = {}
    self.x, self.y = x , y
    self.w, self.h=  0
    self.background = nil
    if type(backing) ~= "table" then
        self.background = backing
        self.w, self.h = self.background:getDimensions()
    else
        self.w, self.h = backing.w, backing.h
    end
end

function Container:setBackground(img)
    self.background = img
    self.w,self.h = self.background:getDimensions()
end

function Container:getPosition()
    return self.x,self.y
end
function Container:getDimensions()
    return self.w,self.h
end
function Container:getX()
    return self.x
end
function Container:getY()
    return self.y
end
function Container:getWidth()
    return self.w
end
function Container:getHeight()
    return self.h
end

function Container:draw(drawFunc)
    love.graphics.push()
    love.graphics.translate(self.x,self.y)
    if notnil(self.background) then love.graphics.draw(self.background,0,0) end
    drawFunc(self.x,self.y,self.w,self.h)
    love.graphics.pop()
end
