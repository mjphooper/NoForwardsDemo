--INHERITANCE REQUIREMENTS------------------------------------------------------
local SpecialMove = require "code.classes.Level.Birds.Specials.Moves.SpecialMove"
--------------------------------------------------------------------------------

local Laser = Class("Laser",SpecialMove)

function Laser:initialize(bird)
    --Inheritence
    SpecialMove.initialize(self,bird)

    --Other variables
    self.destY = 0
    self.timer = 3 --seconds
    self.damageVal = 25--damge for 1 second of contact.
end

--GENERATION FUNCTIONS----------------------------------------------------------
--------------------------------------------------------------------------------

function Laser:onStart() --Should be run once at the end of init, to do things that occur once.
end

 --UPDATE FUNCTIONS-------------------------------------------------------------
 -------------------------------------------------------------------------------

function Laser:updateTimer()
    self.timer = time:countDown(self.timer)
    if self.timer < 0 then
        self.finish(self)
    end
end


function Laser:damage()
    local level = self.bird.level
    for i = 1,#level.enemyBirds,1 do
        local enemyBird = level.enemyBirds[i]
        if squareCollision(enemyBird.x,enemyBird.y,enemyBird.w,enemyBird.h,self.bird.x,self.bird.y,(love.graphics.getWidth()-self.bird.x)*2,20) then
            enemyBird:changeHealth(time:getDelta()*-self.damageVal)
        end
    end
end

function Laser:update()
    self.destY = self.bird.y
    self.updateTimer(self)
    self.damage(self)
end



--DRAW FUNCTIONS-------------------------------------------------------------
-------------------------------------------------------------------------------
function Laser:draw()
    setColor(255,0,0)
    local x,y = self.bird.x + self.bird.w - (self.bird.w/10), self.bird.y + self.bird.h / 2
    love.graphics.rectangle("fill",x,y,(love.graphics.getWidth()/self.bird.level.scale.x-self.bird.x)*2,20)
    flushColor()
end

--@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
--STATIC FUNCTIONS@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
--@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

function Laser:getStreams()
    return {
        {{key="y",dependency="none"}},
        {{key="g",dependency={stream=3,item=2}}},
        {{key="p",dependency="none"},{key="z",dependency={stream=1,item=1}}}
    }
end

function Laser:getKeyStart()
    return "2"
end

function Laser:requirement_loader()
    self.classes = {
    }
end Laser:requirement_loader()

return Laser
