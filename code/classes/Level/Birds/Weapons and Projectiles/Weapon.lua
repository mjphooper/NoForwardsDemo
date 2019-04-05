local Weapon = Class("Weapon")

function Weapon:initialize(config,ammunition) --Config requires: name,bird,projectileType,coolDown,scope
    self.name = config.name
    self.bird = config.bird
    self.w, self.h = self.bird.w, self.bird.h

    self.lvlScale = self.bird.lvlScale

    self.projectileType = config.projectileType

    self.attackScope = 3 --Smaller = wider range.

    self.coolDown = config.coolDown
    self.coolDownTimer = self.coolDown
    self.scope = config.scope

    self.ammunition = ammunition
end

--GETTERS AND SETTERS-------------------------------------------------------

function Weapon:getAmmo()
    return self.ammunition
end

function Weapon:isEmpty()
    if self.ammunition == 0 then return true end
    return false
end

function Weapon:getProjectileSprite()
    return self.projectileType:getSprite()
end

function Weapon:resupply(amount)
    self.ammunition = self.ammunition + amount
end


--WEAPON(Y) FUNCTIONS-----------------------------------------------------------
--------------------------------------------------------------------------------
function Weapon:allowShoot(bird,destination)
    if not self.checkAmmunition(self) then return false end
    if not self.coolDownCheck(self) then return false end
    --Check the range
    --[[if not(destination.x > bird.x + bird.w * self.attackScope) then
        return false
    end-]]
    return true
end

function Weapon:shoot(bird,destination,tblInsert)
    --Do tha checks.
    if not self.allowShoot(self,bird,destination) then return false end

    local projectile = self.projectileType:new({x=self.calculateX(self),y=self.calcualateY(self)},{x=destination.x,y=destination.y},self.lvlScale)
    if notnil(tblInsert) then
         table.insert(tblInsert,projectile)
    else
        return projectile
    end
    return true
end

function Weapon:checkAmmunition()
    if self.ammunition >= 1 then
        self.ammunition = self.ammunition - 1
        return true
    end
    return false
end

function Weapon:coolDownCheck()
    if self.coolDownTimer <= 0 then
        self.coolDownTimer = self.coolDown
        return true
    else
        return false
    end
end

--OTHER FUNCTIONS---------------------------------------------------------------
--------------------------------------------------------------------------------
function Weapon:calculateX()
    return self.bird.x + self.w
end
function Weapon:calcualateY()
    return self.bird.y + (self.h/2)
end

function Weapon:updateCoolDown()
    self.coolDownTimer = time:deltaDec(self.coolDownTimer,1)
end

--UPDATE FUNCTIONS--------------------------------------------------------------
--------------------------------------------------------------------------------
function Weapon:update()
    self.updateCoolDown(self)
end

return Weapon
