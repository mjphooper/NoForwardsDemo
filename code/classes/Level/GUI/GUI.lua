local GUI = Class("GUI") --@@static
--For the level.

function GUI:initialize(level)
    self.level = level
    --Create the classes.
    self.playerBars = self.classes.PlayerBars:new(self,level)
    self.allyBox = self.classes.AllyBox:new(self,level)
    self.weaponBox = self.classes.WeaponBox:new(self,level)

end

--UPDATE FUNCTIONS--------------------------------------------------------------
--------------------------------------------------------------------------------
function GUI:update()
    --Reset the time scale of the level
    self.playerBars:update()


    runIndependently({
        {function() self.allyBox:update() end,running=not self.weaponBox.visible},
        {function() self.weaponBox:update() end,running=not self.allyBox.visible}
    })


end


--DRAW FUNCTIONS----------------------------------------------------------------
--------------------------------------------------------------------------------

function GUI:draw()
    self.playerBars:draw()

    runIndependently({
        {function() self.allyBox:draw() end,running=self.allyBox.visible},
        {function() self.weaponBox:draw() end,running=self.weaponBox.visible}
    })

end

--@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
--STATIC FUNCTIONS@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
--@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

function GUI:requirement_loader()
    self.classes = {
        WeaponBox = require "code.classes.Level.GUI.WeaponBox",
        AllyBox = require "code.classes.Level.GUI.AllyBox.AllyBox",
        PlayerBars = require "code.classes.Level.GUI.PlayerBars"
    }
end GUI:requirement_loader()


return GUI
