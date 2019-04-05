--INHERITANCE REQUIREMENTS------------------------------------------------------
local Weapon = require "code.classes.Level.Birds.Weapons and Projectiles.Weapon"
--------------------------------------------------------------------------------

local BulletShooter = Class("BulletShooter",Weapon)

function BulletShooter:initialize(bird,initialAmmo)
    local name = "BulletShooter"
    local projectileType = self.classes.Bullet
    local coolDown = 0.5 -- in seconds
    local scope = 3 --smaller = wider range
    Weapon.initialize(self,
        {name=name, bird=bird, projectileType=projectileType, coolDown=coolDown, scope=scope}, initialAmmo
    )
end


--@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
--STATIC FUNCTIONS@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
--@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

function BulletShooter:requirement_loader()
    self.classes = {
        Bullet = require "code.classes.Level.Birds.Weapons and Projectiles.Projectiles.Bullet"
    }
end BulletShooter:requirement_loader()

return BulletShooter
