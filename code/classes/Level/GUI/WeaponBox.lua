local WeaponBox = Class("WeaponBox") --THIS MAY NOT SCALE PROPERLY IF THE GAME'S RES IS CHANGED INGAME. THIS IS BECAUSE IT TAKES THE SCALE REF ONLY ONCE, AND NOT EVERY FRAME. MAYBE RECALL GUI:INIT TO FIX?

function WeaponBox:initialize(level)
    self.level = level
    self.player = self.level.player

    --IMportant vars
    self.visible = false
    self.showKey = "g"

    --Helpful vars
    self.middle = {
        number = 3,
        height = self.assets.middle:getHeight(),
    }

    --Create the container
    local w = self.assets.middle:getWidth()
    local h = self.assets.top:getHeight() + self.assets.middle:getHeight()*self.middle.number + self.assets.bottom:getHeight()
    self.container = Container:new(0,love.graphics.getHeight()*0.15,{w=w,h=h})
    self.drawFunction = self.stage(self)



end


--UPDATE FUNCTIONS--------------------------------------------------------------
--------------------------------------------------------------------------------
function WeaponBox:appear()
    if keyboard.keyDown == self.showKey then
        self.visible = true
        self.level.active = false
    end
end

function WeaponBox:finish()
    if keyboard.keyDown == "return" or (keyboard.keyDown == self.showKey and self.visible) then
        self.visible = false
        self.level.active = true
        return true
    end
    return false
end


function WeaponBox:update()
    if self.finish(self) then return end
    self.appear(self)
end


--DRAW FUNCTIONS----------------------------------------------------------------
--------------------------------------------------------------------------------

function WeaponBox:stage()
    return function(x,y,w,h)
        --Draw the top
        love.graphics.draw(self.assets.top,x,y)
        love.graphics.printcustom("Flame",x+10,y+10,{75,75,75},{font=fonts.medium})

        --Draw the middle sections
        local start = y+self.assets.top:getHeight()
        for i = 0,self.middle.number-1,1 do
            love.graphics.draw(self.assets.middle,x,start+(i*self.middle.height))
        end

        --Draw the bottom
        love.graphics.draw(self.assets.bottom,x,start+(self.middle.number*self.middle.height))
    end
end

function WeaponBox:draw()
    self.container:draw(self.drawFunction)
end

--@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
--STATIC FUNCTIONS@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
--@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

function WeaponBox:resource_loader()
    local lgn = function(name) return love.graphics.appropriateImage("Level/UI/Presets/weaponBox/"..name..".png") end
    self.assets = {
        top = lgn("top"),
        bottom = lgn("bottom"),
        middle = lgn("middle")
    }
end WeaponBox:resource_loader()



return WeaponBox
