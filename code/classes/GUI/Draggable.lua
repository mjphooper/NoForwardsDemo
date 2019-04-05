Draggable = Class("Draggable",Clickable) --nothing should be drawn here! USed purely in memory. Create instance in other class.

dragActive = false
function Draggable:initialize(x,y,w,h) --The collision rectangle of the initial draggable.
    Clickable.initialize(self,x,y,w,h)

    self.startPos = {x=self.x,y=self.y}
    self.clickOffset = {x=0,y=0}

    self.moved = false
    self.inDrag = false

    self.invalidRegions = {}
    self.regionOutOfBounds = false

    self.trash = false

end

--GENERAL FUNCTIONS-------------------------------------------------------------
--------------------------------------------------------------------------------

function Draggable:calculateOffset()
    self.clickOffset.x = mouse.clickx - self.x
    self.clickOffset.y = mouse.clicky - self.y
end

function Draggable:setInvalidRegions(regions) --where reggions is {x,y,w,h},{x,y,w,h}...
    self.invalidRegions = regions
    self.checkInvalidStartLocation(self)
end

function Draggable:beenPressed()
    if self.inDrag == false and dragActive == false then
        self.inDrag = true
        dragActive = true
        self.calculateOffset(self)
    end
end

function Draggable:checkRelease()
    if love.mouse.isDown(1) == false then
        self.inDrag = false
        dragActive = false
        if self.regionOutOfBounds then
            self.x, self.y = self.startPos.x, self.startPos.y
        else
            self.startPos .x, self.startPos.y = self.x, self.y
        end
    end
end

function Draggable:isReleased()
    return not self.inDrag
end

function Draggable:isInvalid()
    return self.regionOutOfBounds
end

function Draggable:getX()
    return self.x
end
function Draggable:getY()
    return self.y
end
function Draggable:getPosition()
    return self.getX(self),self.getY(self)
end

 --UPDATE FUNCTIONS-------------------------------------------------------------
 -------------------------------------------------------------------------------

function Draggable:updatePosition()
    if self.inDrag then
        self.moved = true
        self.x = mouse.x - self.clickOffset.x
        self.y = mouse.y - self.clickOffset.y
    end
end

function Draggable:checkInvalidRegions() --True = valid, false = not valid
    for i = 1,#self.invalidRegions,1 do --WILL NEED SQUARE COLLISION!
        local region = self.invalidRegions[i]
        if squareCollision(self.x,self.y,self.w,self.h , region.x,region.y,region.w,region.h) then
            self.regionOutOfBounds = true
            return
        end
    end
    self.regionOutOfBounds = false
end

function Draggable:checkInvalidStartLocation()
    for i = 1,#self.invalidRegions,1 do
        local region = self.invalidRegions[i]
        if pointCollision(self.startPos.x,self.startPos.y, region.x,region.y,region.w,region.h) then
            self.startPos.x = self.startPos.x + 500
        end
    end
end

function Draggable:update()
    --Check for a press.
    if self.pressed(self) then
        self.beenPressed(self)
    end
    --Update everything else!
    self.updatePosition(self)
    self.checkInvalidRegions(self)
    --Check for release!
    self.checkRelease(self)

    return self.getPosition(self)
end

 --DRAW FUNCTIONS---------------------------------------------------------------
 -------------------------------------------------------------------------------

function Draggable:draw()
    setColor(0,255,0)
    love.graphics.rectangle("line",self.x,self.y,self.w,self.h)
    flushColor()
end
