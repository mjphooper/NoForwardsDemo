local BirdObject = Class("BirdObject",SimpleGravityObject)

function BirdObject:initialize(animation,config,level,playerScale)
    SimpleGravityObject.initialize(self,config.mass,config.x,config.y)

    --Initialize the reference variables
    self.level = level

    --Initialize the health and power variables
    self.maxHealth = 10
    self.health = self.maxHealth
    self.maxPower = 100
    self.power = self.maxPower

    self.dead = false
    self.trash = false

    --Initialize the animation variables
    self.animation = animation

    --The targeting variables
    self.targetedBy = 0
    self.targets = {}
    self.opponents = {}

    --Initialize the scaling variables
    self.lvlScale = self.level.scale
    self.playerScale = playerScale

    --Get the dimensions of the bird
    self.getDimensions(self,self.playerScale)

    --Initialize the attacking variables.
    self.shootCooldown = 0.2 --in seconds
    self.cooldownTimer = self.shootCooldown

    --Initialize the weapon class
    local initialAmmo = 50000
end

--WIDTH AND HEIGHT FUNCTIONS
function BirdObject:getDimensions(scale)
    self.w,self.h = self.animation:getDimensions()
    self.w = (self.w * scale.x)
    self.h = (self.h * scale.y)
end


--CONTROL FUNCTIONS-------------------------------------------------------------
--------------------------------------------------------------------------------

function BirdObject:resetMovementStamina()
    self.movementStamina = 1000000
    return self.movementStamina
end

--defauly of 3
function BirdObject:flapForce(power)
    if self.speed > 1 then --Cooldown to prevent the bird from just floating upwards.
        self.speed = power
        self.resetMovementStamina(self)
    end
end

--default of 0.5
function BirdObject:moveLeft(amount)
    if self.movementStamina > 0 then
        self.applyLeftForce(self,amount)
        self.movementStamina = self.movementStamina - amount
    end
end

--default of 0.5
function BirdObject:moveRight(amount)
    if self.movementStamina > 0 then
        self.applyRightForce(self,amount)
        self.movementStamina = self.movementStamina - amount
    end
end

function BirdObject:moveDown(amount)
    self.applyDownwardForce(self,amount)
end

function BirdObject:getBoundaryCollision()
    local collisions = {}
    --X axis collisions
    local w = self.getScaledWidth(self)
    if self.x + self.w > w then
        table.insert(collisions,"right")
    elseif self.x < 0 then
        table.insert(collisions,"left")
    end
    --Y axis collisions
    if self.y + self.h > self.level.mapDetails.floorLevel then
        table.insert(collisions,"bottom")
    elseif self.y < 0 then
        table.insert(collisions,"top")
    end
    return collisions
end

--PROJECTILE FUNCTIONS----------------------------------------------------------
--------------------------------------------------------------------------------

function BirdObject:fireWeapon(destination,tblInsert)
    return self.weapon:shoot(self,destination,tblInsert)
end

function BirdObject:checkForHit(projectileList)
    for i = 1,#projectileList,1 do
        local p = projectileList[i]
        if squareCollision(self.x,self.y,self.w,self.h,p.x,p.y,p.w*p.scale.x,p.h*p.scale.y) and p.putInBin == false then
            self.gotHit(self,p)
        end
    end
end

function BirdObject:gotHit(projectile)
    self.health = math.limitBetween(0,self.health - projectile.damage,self.maxHealth)
    --self.animation:pushAction("hit",true)
    --Destroy the projectile which hit the player.
    projectile.putInBin = true
end

function BirdObject:incrementCooldownTimer()
    self.cooldownTimer = time:deltaInc(self.cooldownTimer,1)
end

--HEALTH AND POWER FUNCTIONS--------------------------------------------------------------
--------------------------------------------------------------------------------
function BirdObject:resetHealth()
    self.health = self.maxHealth
end

function BirdObject:changeHealth(amount)
    self.health = math.limitBetween(0,self.health + amount,self.maxHealth)
end

function BirdObject:changePower(amount)
    self.power = math.limitBetween(0,self.power + amount,self.maxPower)
end

--DEATH FUNCTIONS---------------------------------------------------------------
--------------------------------------------------------------------------------
function BirdObject:isDead()
    if self.health <= 0 then
        return true
    end
    return false
end

function BirdObject:discard()
    self.trash = true
end


--SCALING FUNCTIONS-------------------------------------------------------------
--------------------------------------------------------------------------------

function BirdObject:getScaledWidth()
    return love.graphics.getWidth() / self.level.scale.x
end

function BirdObject:getScaledHeight()
    return love.graphics.getHeight() / self.level.scale.y
end

function BirdObject:getMidX()
    return self.x + self.w/2
end

function BirdObject:getMidY()
    return self.y + self.h/2
end

function BirdObject:getMid()
    return self.getMidX(self),self.getMidY(self)
end

--UPDATE FUNCTIONS--------------------------------------------------------------
--------------------------------------------------------------------------------
function BirdObject:updateAnimation()
    return self.animation:update()
end

function BirdObject:birdObject_update()
    self.applyForces(self)
    self.weapon:update()
end

--DRAW FUNCTIONS----------------------------------------------------------------
--------------------------------------------------------------------------------
function BirdObject:drawHealth()
    love.graphics.printcustom("HEALTH:"..self.health,self.x,self.y+self.h+20,{0,0,0},{font=fonts.large})
end

function BirdObject:birdObject_draw()
    self.animation:draw(self.x,self.y)

    --debugging collision square
    if love.keyboard.isDown("`") then
        setColor(255,0,0)
        love.graphics.rectangle("line",self.x,self.y,self.w,self.h)
        flushColor()
    end
end


--@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
--STATIC FUNCTIONS@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
--@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

function BirdObject:collectTrash(tbl)
    for i = #tbl,1,-1 do
        if tbl[i].trash then
            table.remove(tbl,i)
        end
    end
end

function BirdObject:load_resources()
    self.assets = require "code.classes.Level.Birds.resources_LoadBirds"
end BirdObject:load_resources()


return BirdObject
