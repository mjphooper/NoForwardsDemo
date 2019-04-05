--INHERITANCE REQUIREMENTS------------------------------------------------------
local Weapon = require "code.classes.Level.Birds.Weapons and Projectiles.Weapon"
--------------------------------------------------------------------------------

local NaturalFlameShooter = Class("NaturalFlameShooter",Weapon)

function NaturalFlameShooter:initialize(bird,initialAmmo)
    local name = "NaturalFlameShooter"
    local projectileType = self.classes.Flame
    local coolDown = 1-- in seconds
    local scope = 3 --smaller = wider range
    Weapon.initialize(self,
        {name=name, bird=bird, projectileType=projectileType, coolDown=coolDown, scope=scope}, initialAmmo
    )
end


--@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
--STATIC FUNCTIONS@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
--@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

function NaturalFlameShooter:requirement_loader()
    self.classes = {
        Flame = require "code.classes.Level.Birds.Weapons and Projectiles.Projectiles.Flame"
    }
end NaturalFlameShooter:requirement_loader()

return NaturalFlameShooter
