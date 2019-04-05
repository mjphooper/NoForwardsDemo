--INHERITANCE REQUIREMENTS------------------------------------------------------.i
local BirdObject = require "code.classes.Level.Birds.BirdObject"
--------------------------------------------------------------------------------

local Player = Class("Player",BirdObject)

function Player:initialize(config,level,playerScale) --playerScale defaults to 0.6,0.6
    BirdObject.initialize(self,Animator:new(self.assets.redDragon.idle,4,{paused=false,loop=true,quadImage=self.assets.redDragon.image}),config,level,playerScale or {x=1,y=1})

    --Configure the custom animation
    self.configureAnimation(self,self.playerScale)
    --Status
    self.currentAction = "default"
    --Initialize the movement variables
    self.movementSpeed = 25
    self.flapSpeed = 7
    self.movementStamina = self.resetMovementStamina(self)

    --Give a weapon!
    self.weapon = self.classes.NaturalFlameShooter:new(self,999999)


    --Pickups
    self.coinsCollected = 0

    --Initialize the death controller
    self.deathAction = self.classes.death.Rise:new(self)

    --Ammo display
    self.weaponAmmoSprite = self.getWeaponProjectileSprite(self) --Must be called when weapon is changed!

    --Initialize the SpecialMove class
    self.special = self.classes.SpecialMoveController:new(self)

    --Time varialbes
    self.timeSlow = false
    self.playerProjectiles = {}

    --Assign power
    self.maxPower = 100
    self.power = 100

    self.maxHealth = 100
    self.health = 100

    --Cheats
    self.invinsibility = true
end

--INITIALIZATION FUNCTIONS------------------------------------------------------
--------------------------------------------------------------------------------

function Player:configureAnimation(playerScale)
    --self.animation:supplyAction(BirdObject.assets.redDragon.attack,3)
    --self.animation:supplyAction(BirdObject.assets.redDragon.dead,8)
    --self.animation:supplyAction(BirdObject.assets.redDragon.hit,10)
    self.animation:setDrawScale(playerScale)
end

function Player:findTargets() end --Not the best practice- but leave this here.
--Used in the targeting system.Player is in friendly birds, and all friendlybirds have findTargets(),
--so player requires it too.

function Player:configureWeaponWheel()
end

--MOVEMENT FUNCTIONS------------------------------------------------------------
--------------------------------------------------------------------------------
function Player:checkBoundaryCollision()
    local collisions = self.getBoundaryCollision(self)
    if #collisions > 0 then
        local w = self.getScaledWidth(self)
        if linearSearch(collisions,"right") then self.x = w - self.w
        elseif linearSearch(collisions,"left") then self.x = 0 end
        if linearSearch(collisions,"bottom") then self.flap(self,true)
        elseif linearSearch(collisions,"top") then self.y = 0 end
    end
end

function Player:checkForMovement()
    if love.keyboard.isDown("a") then
        self.moveLeft(self,self.movementSpeed)
    elseif love.keyboard.isDown("d") then
        self.moveRight(self,self.movementSpeed)
    end

    if love.keyboard.isDown("s") then
        self.animation:pause()
        self.moveDown(self,self.movementSpeed/2)
    else self.animation:resume() end
end

function Player:flap(force)
    if love.keyboard.isDown("space") or force then
        self.flapForce(self,-self.flapSpeed)
    end
end

function Player:attack()
    if love.mouse.isDown("1") and self.level.active then --Conditions for fire to occur!
        if self.fireWeapon(self,{x=mouse.x,y=mouse.y},self.playerProjectiles) then
            self.animation:pushAction("attack",true)
        end
    end
end

--ATTACK FUNCTIONS--------------------------------------------------------------
--------------------------------------------------------------------------------


--INVENTORY FUNCTIONS-----------------------------------------------------------
--------------------------------------------------------------------------------
function Player:toggleWeaponWheel()
    self.weaponWheelVisible = false
    if love.keyboard.isDown("t") then
        self.weaponWheelVisible = true
        return true
    end
    return false
end

function Player:drawWeaponWheel()
    if self.weaponWheelVisible then
        self.weaponWheel:draw()
    end
end

function Player:resupply()
    if keyboard.keyDown == "r" then
        self.weapon:resupply(10)
    end
end

function Player:getWeaponProjectileSprite()
    local spr = self.weapon:getProjectileSprite()
    local w,h = spr:getDimensions()
    local scale = (self.w/4)/w
    return {
        img=spr,w=w,h=h,scale ={x=scale,y=scale}
    }
end

function Player:drawAmmoNumber()
    local x,y = self.x + self.w/2, self.y+self.h+20
    local sprite = self.weaponAmmoSprite
    love.graphics.draw(sprite.img,x,y,0,sprite.scale.x,sprite.scale.y)
    love.graphics.printcustom("x"..self.weapon:getAmmo(),x+sprite.w*sprite.scale.x+10,y,{75,75,75},{font=fonts.small})
end


--SLOW TIME ABILITY-------------------------------------------------------------
--------------------------------------------------------------------------------

function Player:toggleTimeSlow()
    if keyboard.keyDown == "lshift" then
        if not self.timeSlow and self.power >= 10 then
            self.timeSlow = true
            self.level.functions:setTime(0.1)
        elseif self.timeSlow then
            self.timeSlow = false
            self.level.functions:resetTime()
        end
    end
end

function Player:pollTimeSlow()
    if self.timeSlow and not self.special:isActive() then
        self.power = math.limitBetween(0,time:deltaDec(self.power,25),self.maxPower)
        if self.power <= 0 then
            self.timeSlow = false
            self.level.functions:resetTime()
        end
    end

end

function Player:timeSlowUpdate()
    if self.invinsibility then self.health = 100 end
    self.toggleTimeSlow(self)
    time:forcePush(1)
    self.pollTimeSlow(self)
    time:pop()
end

--TIME CONTROLLING--------------------------------------------------------------
--------------------------------------------------------------------------------
function Player:checkForAllyBox()
    if self.level.gui.allyBox.visible then
        return self.level.gui.allyBox.slowTime
    end
    return false
end

function Player:checkForPause()
    if self.level.paused then
        return 0
    end
end

function Player:checkForSpecial()
    if self.special:isActive() and not self.special.runningMove then
        return self.special.slowSpeed
    end
end


function Player:controlPlayerTime()
    local workingTime = false
    --Handle the other stuff
    self.timeSlowUpdate(self) --Self the level speed if time is slowed down.
    --Setting the player time. The lower down, the higher priority!
    workingTime = workingTime or self.checkForAllyBox(self)
    workingTime = workingTime or self.checkForPause(self)
    workingTime = workingTime or self.checkForSpecial(self)

    time:forcePush(workingTime or 1)
end

--UPDATE FUNCTIONS--------------------------------------------------------------
--------------------------------------------------------------------------------

function Player:update()
    --Control the time
    self.controlPlayerTime(self)
    --Updates for alive *and dead.
    self.updateAnimation(self)
    --Check to update the death
    if self.deathAction:branch("update") then return end

    --Inherited updates
    self.birdObject_update(self)
    --Self updates
    self.checkForMovement(self)
    self.checkForHit(self,self.level.enemyProjectiles)
    self.flap(self)
    self.checkBoundaryCollision(self)
    self.resupply(self)
    self.attack(self)
    self.special:update()

    --Update the player projectiles
    fold(self.playerProjectiles,function(projectile) projectile:update() end)
    self.classes.Projectile:collectTrash(self.playerProjectiles)
    --[[
    --Exclusive update checks
    if not self.toggleWeaponWheel(self) then
        self.special:update()
    end --If weapon wheel not active, then we can start a special
    --]]
    runIndependently({{function() self.toggleWeaponWheel(self) end,running = love.keyboard.isDown("t")}})

    --Trash collection
    BirdObject:collectTrash({self.level.player})

    time:pop()
end

--DRAW FUNCTIONS---------------------------------------------------------------
--------------------------------------------------------------------------------

function Player:draw()
    self.birdObject_draw(self)
    --Check to branch from death
    if self.deathAction:branch("draw") then return end
    --Draw the player projectiles
    fold(self.playerProjectiles,function(projectile) projectile:draw() end)


    self.drawAmmoNumber(self)
    self.special:draw()
end

--PLAYER CONFIGS----------------------------------------------------------------
--------------------------------------------------------------------------------
PLAYER_GRAVITY_CONFIG = {mass=100,x=700,y=20}

--@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
--STATIC FUNCTIONS@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
--@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

function Player:requirement_loader()
    self.classes = {
        SpecialMoveController = require "code.classes.Level.Birds.Specials.SpecialMoveController",
        NaturalFlameShooter = require "code.classes.Level.Birds.Weapons and Projectiles.Weapons.NaturalFlameShooter",
        Projectile = require "code.classes.Level.Birds.Weapons and Projectiles.Projectile",
        death = {
            Rise = require "code.classes.Level.Birds.Die.Rise"
        }
    }
end Player:requirement_loader()



function Player:resource_loader()

end



return Player
