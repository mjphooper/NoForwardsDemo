--INHERITANCE REQUIREMENTS------------------------------------------------------
local Decoration = require "code.classes.Level.Decoration.Decoration"
--------------------------------------------------------------------------------

local XPGain = Class("XPGain",Decoration)

function XPGain:initialize(level,x,y,xpAmount)
    Decoration.initialize(self,level,x,y)

    --XP stuff
    self.speed = 500
    self.xpAmount = xpAmount
    self.fadeTime =  1 --seconds
end

 --UPDATE FUNCTIONS-------------------------------------------------------------
 -------------------------------------------------------------------------------

function XPGain:move()
    self.y = time:deltaDec(self.y,self.speed)
end

function XPGain:trash()
    if timer > 0.5 then
        self.trash = true
    end
end

function XPGain:update()
    time:forcePush(1)
        self.decoration_update(self)
        self.move(self)
    time:pop()
end

 --DRAW FUNCTIONS---------------------------------------------------------------
 -------------------------------------------------------------------------------

function XPGain:draw()
    local alpha = (1-self.timer/self.fadeTime)*255
    love.graphics.printcustom("+"..self.xpAmount,self.x,self.y,{186,85,211,alpha},{font=fonts.large})
end

return XPGain
