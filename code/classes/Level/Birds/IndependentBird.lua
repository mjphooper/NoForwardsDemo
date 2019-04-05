--INHERITANCE REQUIREMENTS------------------------------------------------------
local BirdObject = require "code.classes.Level.Birds.BirdObject"
--------------------------------------------------------------------------------

local IndependentBird = Class("IndependentBird",BirdObject)

function IndependentBird:initialize(animation,config,level,playerScale) --{x=0.4,y=0.4}
    BirdObject.initialize(self,animation,config,level,playerScale)
    self.animation:setDrawScale(self.playerScale)

    --References
    self.level = level
    self.mapDetails = level.mapDetails

    --Intelligence [number of enemies can focus on]
    self.intelligence = 1

    --Stamina details
    self.movementStamina = 10000000000
    self.movementSpeed = 15
    self.flapSpeed = 7

    --Point to move to
    self.ventureDistance = 0.4 --Larger = less adventuring
    self.ventureRange = {min=0,max=0}


end

--AI FUNCTIONS------------------------------------------------------------------
--------------------------------------------------------------------------------
function IndependentBird:idle()
    self.moveToPoint(self)

end

function IndependentBird:generatePoint()

    return {x=love.math.random(self.ventureRange.min,self.ventureRange.max),
            y=love.math.random(20,self.level.mapDetails.floorLevel)}
end

function IndependentBird:reachedPoint()
    --Create a large rectangle around the point as the collision rectangle
    if squareCollision(self.x,self.y,self.w,self.h,self.movementPoint.x-(self.w/2),self.movementPoint.y-(self.h/2),self.w,self.h) then
        --Reached the point! Generate new.
        self.movementPoint = self.generatePoint(self)
    end
end


function IndependentBird:moveToPoint()
    if math.floor(self.y) > self.movementPoint.y then
        self.triggerFlap(self)
    end
    --X axis
    if math.floor(self.x) < self.movementPoint.x then
        self.moveRight(self,self.movementSpeed)
    elseif math.floor(self.x) > self.movementPoint.x then
        self.moveLeft(self,self.movementSpeed)
    end

    self.reachedPoint(self)
end


--MOVEMENT FUNCTIONS------------------------------------------------------------
--------------------------------------------------------------------------------
function IndependentBird:triggerFlap()
    if self.speed > 1 then
        self.flapForce(self,-self.flapSpeed)
    end
end

function IndependentBird:checkBoundaryCollision()
    local collisions = self.getBoundaryCollision(self)
    if #collisions > 0 then
        local w = self.getScaledWidth(self)
        if linearSearch(collisions,"right") then self.x = w - self.w
        elseif linearSearch(collisions,"left") then self.x = 0 end
        if linearSearch(collisions,"bottom") then self.speed = -10
        elseif linearSearch(collisions,"top") then self.y = 0 end
    end
end

--TARGETING FUNCTIONS-----------------------------------------------------------
--------------------------------------------------------------------------------
--[[Explanation of the current targeting system for a new bird:
    (1) Targeting outwards
        Find the opponent bird that is being targeted by the least amount of birds from your team
        Add that bird to your target list, so you are now targeting that bird

    (2) Targeting inwards
        Iterate the whole opposite team, and find the opposite bird that is targeting the least number of your teams birds
        Add yourself to the oppoents target list, so you are now being targeted by that bird

    Using 'min' allows for the targeting to be distributed evenly as possible.
--]]

--[[ Varaibles to help:
    self.opponents.birds = table of bird objects whom are the fighting opponents
    bird.targets = table of bird objects that are targeted by 'bird'
    bird.targetedBy = number of birds that are targeting self
]]

function IndependentBird:findTargets(max)
    local current = #self.targets
    local toFind = max - current

    for i = 1,math.min(#self.opponents.birds,toFind),1 do

        --Sort the table accoridng to targeted by.
        table.sort(self.opponents.birds,
                          function(a,b) return (a.targetedBy > b.targetedBy) end)

        for i = 1,#self.opponents.birds,1 do
            if self.opponents.birds[i]:isDead() == false then
                local newTarget = self.opponents.birds[i]
                newTarget.targetedBy = newTarget.targetedBy + 1 --Tell the target it's been targeted
                table.insert(self.targets,newTarget) --Add new target to the target table.
            end
        end
    end
end

function IndependentBird:pollTargetDeath()
    for i = #self.targets,1,-1 do
        if self.targets[i]:isDead() then
            table.remove(self.targets,i)
            self.findTargets(self,1) --Try to make up for the lost enemy if possible!
        end
    end
end

--Need a way of notifying enemy birds to target just created bird.
function IndependentBird:notifyOpponents()
    --fold(self.opponents.birds,function(opponent) opponent:findTargets(1) end)
    for i = 1,#self.opponents.birds,1 do
        local opponent = self.opponents.birds[i]
        opponent:findTargets(opponent.intelligence)
    end
end






--ATTACKING FUNCTIONS-----------------------------------------------------------
--------------------------------------------------------------------------------

function IndependentBird:attack(destination,tblInsert)
    if not isEmpty(self.targets) then
            local target = self.targets[1]
            self.fireWeapon(self,{x=target.x+target.w/2,y=target.y+target.h/2},self.projectileTable)
        end

end

--UPDATE FUNCTIONS--------------------------------------------------------------
--------------------------------------------------------------------------------


function IndependentBird:independentBird_update()
    self.birdObject_update(self)
    self.checkBoundaryCollision(self)
    self.pollTargetDeath(self)
    self.checkForHit(self,self.opponents.projectiles)
    self.attack(self)
    self.idle(self)

end

--DRAW FUNCTIONS----------------------------------------------------------------
--------------------------------------------------------------------------------

function IndependentBird:independentBird_draw()
    self.birdObject_draw(self)
end


return IndependentBird
