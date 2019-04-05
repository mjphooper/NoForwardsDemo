--INHERITANCE REQUIREMENTS------------------------------------------------------
local Projectile = require "code.classes.Level.Birds.Weapons and Projectiles.Projectile"
--------------------------------------------------------------------------------

local Flame = Class("Flame",Projectile)
function Flame:initialize(start,dest,lvlScale)
    local mass = 50
    local speed = 15
    local sprite = self.getSprite(self)
    local damage = 10
    local scaleConstant = (love.math.random(25,75))/100
    local scale = {x=scaleConstant,y=scaleConstant}
    Projectile.initialize(self, lvlScale,
        {mass=mass, x =start.x, y =start.y, sprite = sprite, damage = damage,
        scale = scale, speed = speed, endX = dest.x, endY = dest.y}
    )
end

function Flame:getSprite()
    return randomKeyedValue(self.assets.set1)
end

--@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
--STATIC FUNCTIONS@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
--@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

function Flame:resource_loader()
    local f = "Level/Projectiles/Fireshot/"
    local lgn = love.graphics.appropriateImage
    self.assets = {
        set1 = {normal=lgn(f.."1/normal.png"),dark_red=lgn(f.."1/dark_red.png"),hot_red=lgn(f.."1/hot_red.png")},
        set2 = {normal=lgn(f.."2/normal.png")},
        set3 = {normal=lgn(f.."3/normal.png")}
    }
end Flame:resource_loader()

return Flame
