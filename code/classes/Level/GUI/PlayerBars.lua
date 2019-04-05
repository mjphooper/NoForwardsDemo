local PlayerBars = Class("PlayerBars") --THIS MAY NOT SCALE PROPERLY IF THE GAME'S RES IS CHANGED INGAME. THIS IS BECAUSE IT TAKES THE SCALE REF ONLY ONCE, AND NOT EVERY FRAME. MAYBE RECALL GUI:INIT TO FIX?

function PlayerBars:initialize(gui,level)
    --Refernece
    self.gui = gui
    self.level = level
    self.lvlScale = self.level.scale
    self.player = self.level.player

    --Create the container
    self.container = Container:new(0,0,self.assets.board)
    self.drawFunction = self.stage(self)

    --Variables used for simplifying the calculations on the GUI bars.
    self.levelProgression = {
        h = self.assets.levelProgression:getHeight(),
        w = self.assets.levelProgression:getWidth()
    }
    local healthOffset = 67/526
    self.health = { --START_OFFSET = 0.1593406593, INVERSE_OFFSET = (1-0.1593406593)
        start = healthOffset * (self.assets.healthBar:getWidth()*self.lvlScale.x),
        activeWidth = (1-healthOffset) * (self.assets.healthBar:getWidth()*self.lvlScale.x),
        h = self.assets.healthBar:getHeight()
    }
    self.power = { --START OFFSET = 0.5443583118, INVERSE_OFFSET = (1-0.5443583118)
        start = 0.5861136158 * (self.assets.powerBar:getWidth()*self.lvlScale.x),
        activeWidth = (1-0.5861136158) * (self.assets.powerBar:getWidth()*self.lvlScale.x),
        h = self.assets.powerBar:getHeight()
    }

end

--UPDATE FUNCTIONS--------------------------------------------------------------
--------------------------------------------------------------------------------

function PlayerBars:getHealthPc()
    self.health.pc = self.player.health / self.player.maxHealth
end

function PlayerBars:getPowerPc()
    self.power.pc = self.player.power / self.player.maxPower
end

function PlayerBars:update()
    self.getHealthPc(self)
    self.getPowerPc(self)
end



--DRAW FUNCTIONS----------------------------------------------------------------
--------------------------------------------------------------------------------

function PlayerBars:drawHealth(x,y,w,h)
    --Draw the health bar
    love.graphics.setScissor(x*self.level.scale.x,y*self.level.scale.y,self.assets.healthBar:getWidth()*self.level.scale.x*self.health.pc,self.health.h)
    love.graphics.draw(self.assets.healthBar,x,y)
    love.graphics.printcustom(math.floor(self.player.health).."/"..self.player.maxHealth,x+40,y-1,{255,255,255},{font=fonts.small})
end

function PlayerBars:drawPower(x,y,w,h)
    --Draw the health bar,
    love.graphics.setScissor(x*self.level.scale.x,y*self.level.scale.y,self.assets.powerBar:getWidth()*self.level.scale.x*self.power.pc,self.power.h)
    love.graphics.draw(self.assets.powerBar,x,y)
    love.graphics.printcustom(math.floor(self.player.power).."/"..self.player.maxPower,x+40,y-1,{255,255,255},{font=fonts.small})
end


function PlayerBars:stage()
    return function(x,y,w,h)
        --Draw the base and level progression
        love.graphics.draw(self.assets.backingBars,x,y)
        love.graphics.setScissor(x,y,(self.levelProgression.w*self.level.map:calculateProgress())*self.level.scale.x,self.levelProgression.h)
        love.graphics.draw(self.assets.levelProgression,x,y)
        --Draw the health and power bars
        local barY = y + (love.graphics.getHeight() * 0.026)
        self.drawHealth(self,x+(love.graphics.getWidth()*0.032),barY,w,h)
        self.drawPower(self,x+(love.graphics.getWidth()*0.244),barY,w,h)
        --Reset scissoring
        love.graphics.setScissor()
        --Draw the bar outlines
        love.graphics.draw(self.assets.barOutlines,x,y)
    end
end

function PlayerBars:draw()
    self.container:draw(self.drawFunction)
end

--@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
--STATIC FUNCTIONS@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
--@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

function PlayerBars:resource_loader()
    local lgn = function(name) return love.graphics.appropriateImage("Level/UI/Presets/topLeft/"..name..".png") end
    self.assets = {
        board = lgn("backboard"),
        healthBar = lgn("health_bar_slim"),
        powerBar = lgn("power_bar_slim"),
        barOutlines = lgn("bar_outlines"),
        backingBars = lgn("backing_bars"),
        levelProgression = lgn("level_progression")
    }
end PlayerBars:resource_loader()


return PlayerBars
