SpawnPhantom = Class("SpawnPhantom")

function SpawnPhantom:initialize(id,x,y,container,level) --as str
    self.sprite = self.assets.birds[id]
    self.id = id
    self.level = level
    self.container = container
    self.x, self.y = x,y
    self.phantomScale = {x=0.4, y=0.4}
    self.w, self.h = self.sprite:getWidth() * self.phantomScale.x , self.sprite:getHeight() * self.phantomScale.y

    --Set the close button
    self.closeOffset = {x=-30,y=-30}
    self.closeScale = {x=0.3, y=0.3}
    self.trash = false

    --Set the drag object
    self.drag = Draggable:new(self.x,self.y,self.w,self.h)
    self.drag:setInvalidRegions({
        {x=love.graphics.getWidth()/2 /self.level.scale.x,y=0,w=love.graphics.getWidth()/2 /self.level.scale.x,h=love.graphics.getHeight()/self.level.scale.y},
        {x=self.container:getX(),y=self.container:getY(),w=self.container:getWidth(),h=self.container:getHeight()}
    })
end

 --UPDATE FUNCTIONS-------------------------------------------------------------
 -------------------------------------------------------------------------------

function SpawnPhantom:checkForRemoveClick()
    if mouse.click and self.drag:isReleased() and self.drag.moved then
        if pointCollision(mouse.clickx,mouse.clicky,self.x-self.closeOffset.x,self.y-self.closeOffset.y,self.assets.close:getWidth()*self.closeScale.x,self.assets.close:getHeight()*self.closeScale.y) then
            self.trash = true
        end
    end
end

function SpawnPhantom:update()
    self.checkForRemoveClick(self)
    self.x, self.y = self.drag:update()

end

 --DRAW FUNCTIONS---------------------------------------------------------------
 -------------------------------------------------------------------------------
function SpawnPhantom:drawMoving(x,y)
    if self.drag:isInvalid() then setColor(255,0,0,100) else setColor(255,255,255,100) end
    love.graphics.draw(self.sprite,x,y,0,self.phantomScale.x,self.phantomScale.y)
    flushColor()
end


function SpawnPhantom:drawStationary(x,y)
    love.graphics.draw(self.sprite,x,y,0,self.phantomScale.x,self.phantomScale.y)
    love.graphics.draw(self.assets.close,x-self.closeOffset.x,y-self.closeOffset.y,0,self.closeScale.x,self.closeScale.y)
end

function SpawnPhantom:draw()
    local x,y = self.x - self.container:getX(), self.y - self.container:getY()
    if self.drag:isReleased() then
        self.drawStationary(self,x,y)
    else
        self.drawMoving(self,x,y)
    end
end

--@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
--STATIC FUNCTIONS@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
--@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

function SpawnPhantom:resource_loader()
    self.assets = {
        close = love.graphics.appropriateImage("Level/UI/close.png"),
        birds = {
            player1 = love.graphics.appropriateImage("Birds/FriendlyPlayers/Player 1/Default/a1.png"),
            player2 = love.graphics.appropriateImage("Birds/FriendlyPlayers/Player 2/Default/a1.png"),
            player3 = love.graphics.appropriateImage("Birds/FriendlyPlayers/Player 3/Default/a1.png"),
            player4 = love.graphics.appropriateImage("Birds/FriendlyPlayers/Player 4/Default/a1.png"),
            player5 = love.graphics.appropriateImage("Birds/FriendlyPlayers/Player 5/Default/a1.png")
        }
    }
end SpawnPhantom:resource_loader()
