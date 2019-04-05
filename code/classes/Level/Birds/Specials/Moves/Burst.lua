--INHERITANCE REQUIREMENTS------------------------------------------------------
local SpecialMove = require "code.classes.Level.Birds.Specials.Moves.SpecialMove"
--------------------------------------------------------------------------------

local Burst = Class("Burst",SpecialMove)

function Burst:initialize(bird)
    --Inheritence
    SpecialMove.initialize(self,bird)

    --Other variables
    self.projectileType = self.classes.Bullet
    self.angleSize = math.pi / 15
end

--GENERATION FUNCTIONS----------------------------------------------------------
--------------------------------------------------------------------------------

function Burst:generateProjectiles()
    local projectilesAdd = {}
    local x,y = self.bird.x,self.bird.y
    for i = -math.pi,math.pi,self.angleSize do
        local endX,endY = math.angleLinePoint(x,y,self.angleSize*i)
        local projectile = self.projectileType:new({x=x,y=y},{x=endX,y=endY},self.level.scale)
        table.insert(projectilesAdd,projectile)
    end
    referenceMerge(self.level.friendlyProjectiles,projectilesAdd)
    self.finish(self)
end


function Burst:onStart() --Should be run once at the end of init, to do things that occur once.
    self.generateProjectiles(self)
end

 --UPDATE FUNCTIONS-------------------------------------------------------------
 -------------------------------------------------------------------------------

function Burst:update()
end



--@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
--STATIC FUNCTIONS@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
--@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

function Burst:getStreams()
    return { --Tables for each of the streams. 5 max?. Use sample data here.
        {{key="a",dependency="none"},{key="i",dependency={stream=1,item=1}},{key="l",dependency={stream=2,item=1}}},
        {{key="b",dependency={stream=1,item=1}}},
        {{key="c",dependency="none"},{key="t",dependency={stream=2,item=1}}}
    }
end

function Burst:getKeyStart()
    return "1"
end

function Burst:requirement_loader()
    self.classes = {
        Bullet = require "code.classes.Level.Birds.Weapons and Projectiles.Projectiles.Bullet"
    }
end Burst:requirement_loader()

return Burst
