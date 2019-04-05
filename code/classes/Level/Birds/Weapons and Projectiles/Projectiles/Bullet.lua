--INHERITANCE REQUIREMENTS------------------------------------------------------
local Projectile = require "code.classes.Level.Birds.Weapons and Projectiles.Projectile"
--------------------------------------------------------------------------------

local Bullet = Class("Bullet",Projectile)

function Bullet:initialize(start,dest,lvlScale)
    local mass = 0
    local speed = 25
    local sprite = self.getSprite(self)
    local damage = 5
    local scale = {x=0.25,y=0.25}
    Projectile.initialize(self, lvlScale,
        {mass=mass, x =start.x, y =start.y, sprite = sprite, damage = damage,
        scale = scale, speed = speed, endX = dest.x, endY = dest.y}
    )
end

--SET THE BULLET SPRITE HERE.
function Bullet:getSprite() --Works as a static function. So that the sprite can be accessed for this type, even when not instantiated.
    return self.assets.green
end

--@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
--STATIC FUNCTIONS@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
--@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
function Bullet:resource_loader()
    local f = "Level/Projectiles/Bullets/"
    self.assets = {
        black = love.graphics.appropriateImage(f.."Black.png"),
        green = love.graphics.appropriateImage(f.."Green.png"),
        largeGrey = love.graphics.appropriateImage(f.."Large_grey.png")
    }
end Bullet:resource_loader()




return Bullet
