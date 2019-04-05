--INHERITANCE REQUIREMENTS------------------------------------------------------
local levelPlayer = require "code.classes.Level.Birds.Player"
--------------------------------------------------------------------------------

local Player = Class("HubPlayer",levelPlayer)

function Player:initialize(hub)
    self.hub = hub

    --Fake level
    local fakeLevel = {
        scale = self.hub.scale,
        mapDetails = {floorLevel = love.graphics.getHeight()/self.hub.scale.y}
    }
    --Inherit from the gravity object
    levelPlayer.initialize(self,{mass=250,x=100,y=50},fakeLevel,{x=1,y=1})
    self.movementSpeed = 10
    self.flapSpeed = 10
end

 --UPDATE FUNCTIONS-------------------------------------------------------------
 -------------------------------------------------------------------------------

function Player:update()
    self.updateAnimation(self)
    self.applyForces(self)
    self.checkForMovement(self)
    self.flap(self)
    self.checkBoundaryCollision(self)
end

 --DRAW FUNCTIONS---------------------------------------------------------------
 -------------------------------------------------------------------------------

function Player:draw()
    self.birdObject_draw(self)
end

return Player
