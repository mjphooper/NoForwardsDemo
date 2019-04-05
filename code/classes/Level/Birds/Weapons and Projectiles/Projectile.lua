local Projectile = Class("Projectile",SimpleGravityObject)

function Projectile:initialize(lvlScale,config) --Config requires: mass,x,y,sprite,scale,speed,endX,endY
    SimpleGravityObject.initialize(self,config.mass,config.x,config.y) --mass,x,y
    --Configuration variables
    self.sprite = config.sprite
    self.x,self.y = config.x,config.y
    self.w = config.sprite:getWidth() * lvlScale.x
    self.h = config.sprite:getHeight() * lvlScale.y
    self.scale = config.scale
    self.lvlScale = lvlScale
    self.drawAngle = 0

    self.movementSpeed = config.speed * 100
    self.dx, self.dy = self.calculateSlopeConstant(self,self.x,self.y,config.endX,config.endY,self.movementSpeed)
    self.putInBin = false

    --Gameplay variables
    self.type = "notype"
    self.damage = config.damage
end

function Projectile:calculateSlopeConstant(sx,sy,ex,ey,speed)
    local angle = math.atan2((ey- sy),(ex-sx))
    self.drawAngle = angle
    local dx = speed * math.cos(angle)
    local dy = speed * math.sin(angle)
    return dx,dy
end

function Projectile:escape()
    if self.x > love.graphics.getWidth() / self.lvlScale.x or self.x + (self.w*self.scale.x)< 0 or self.y+(self.h*self.scale.y) < 0 then
        self.putInBin = true
    end
end

--UPDATE FUNCTIONS--------------------------------------------------------------
--------------------------------------------------------------------------------

function Projectile:update()
    self.x = time:deltaInc(self.x,self.dx)
    self.y = time:deltaInc(self.y,self.dy)
    --self.applyForces(self)
    self.escape(self)

end

--DRAW FUNCTIONS----------------------------------------------------------------
--------------------------------------------------------------------------------

function Projectile:draw()
    love.graphics.draw(self.sprite,self.x,self.y,self.drawAngle,self.scale.x,self.scale.y)
end

--@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
--STATIC FUNCTIONS@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
--@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

function Projectile:collectTrash(tbl) --@STATIC
    for i=#tbl,1,-1 do
        if tbl[i].putInBin then
            table.remove(tbl,i)
        end
    end
end

return Projectile
