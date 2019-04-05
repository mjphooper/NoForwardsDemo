require "code.classes.Level.GUI.AllyBox.SpawnPhantom"
require "code.classes.Level.GUI.AllyBox.AvailableAlly"


local AllyBox = Class("AllyBox") --THIS MAY NOT SCALE PROPERLY IF THE GAME'S RES IS CHANGED INGAME. THIS IS BECAUSE IT TAKES THE SCALE REF ONLY ONCE, AND NOT EVERY FRAME. MAYBE RECALL GUI:INIT TO FIX?

function AllyBox:initialize(gui,level,allyData)
    self.gui = gui
    self.level = level
    self.player = self.level.player

    --Important vars
    self.visible = false
    self.showKey = "f"
    self.slowTime = 0.01


    --The allyData[TEMPORARY]
    self.allyData = {
        {id="player1", count=3},
        {id="player2", count=8},
        {id="player3", count=4}
    }
    self.birdNumber = #self.allyData

    --Page information
    self.page = 1
    self.perPage = 4
    self.pageNumber = math.ceil(self.birdNumber/self.perPage)
    local pixelSize = love.graphics.getWidth()*love.graphics.getHeight()
    self.pageFont = love.graphics.newFont("assets/Fonts/BaksoSapi.otf",pixelSize * 0.00005)

    --Create the container
    local w = self.assets.middle:getWidth()
    local h = self.assets.top:getHeight() + self.assets.middle:getHeight()*self.birdNumber + self.assets.bottom:getHeight()
    self.container = Container:new(0,love.graphics.getHeight()*0.15,{w=w,h=h})
    self.drawFunction = self.stage(self)

    --Helpful vars
    self.middle = {
        height = self.assets.middle:getHeight(),
    }

    --Vars about which allies are present
    self.alliesAvailable = {}
    self.calculateBirdPositions(self)


end


--Calculate spawn bird positions.
function AllyBox:calculateBirdPositions()
    for i = 1,self.birdNumber,1 do
        local id,count = self.allyData[i].id, self.allyData[i].count
        local x,y = self.container:getPosition()
        x,y=0,0
        local start = y+self.assets.top:getHeight()
        local y = start + ((i-1) * self.middle.height)

        table.insert(self.alliesAvailable,AvailableAlly:new(self,id,count,x+10,y+10,self.level))
    end
end

--Spawn the placed birds.
function AllyBox:spawnBirds()
    local birdsToSpawn = {}
    for i = 1,#self.alliesAvailable,1 do
        for j = 1 ,#self.alliesAvailable[i].phantoms, 1 do
            local phantom = self.alliesAvailable[i].phantoms[j]
            self.classes.FriendlyBird:generateNew(phantom.id,self.level,phantom.x,phantom.y)
        end
    end
    self.alliesAvailable = {}
    self.calculateBirdPositions(self)
end



--UPDATE FUNCTIONS--------------------------------------------------------------
--------------------------------------------------------------------------------
function AllyBox:appear()
    if keyboard.keyDown == self.showKey then
        self.visible = true
        self.level.active = false
        self.level.player.timeSlow = false
    end
end

function AllyBox:finishFunction()
    self.visible = false
    self.level.active = true
    self.level.functions:resetTime()
    return true
end

function AllyBox:finish()
    if keyboard.keyDown == "return" then
        self.spawnBirds(self)
        return self.finishFunction(self)
    elseif (keyboard.keyDown == self.showKey and self.visible) then
        return self.finishFunction(self)
    end
    return false
end

function AllyBox:update()
    --Do the state checks!
    if self.finish(self) then return end
    self.appear(self)

    if self.visible then
        --Set the speed
        self.level.functions:setTime(self.slowTime)
        --Update the screen phantoms
        fold(self.alliesAvailable,function(ally) ally:update() end)
    end

end

function AllyBox:checkBirdClick(x,y)

end


--DRAW FUNCTIONS----------------------------------------------------------------
--------------------------------------------------------------------------------

function AllyBox:drawBirds(x,y,i)
    local refTable = self.alliesAvailable[i]
    love.graphics.draw(refTable.sprite,x+10,y+10)
    love.graphics.printcustom(refTable.number,x+250,y+40,{75,75,75},{font=fonts.medium})
end


function AllyBox:stage()
    return function(w,h)
        --Draw the top
        love.graphics.draw(self.assets.top,0,0)

        --Draw the middle sections
        local start = self.assets.top:getHeight()
        for i = 0,self.birdNumber-1,1 do
            local x,y = 0,start+(i*self.middle.height)
            love.graphics.draw(self.assets.middle,x,y)
        end

        --Draw the bottom
        love.graphics.draw(self.assets.bottom,0,start+(self.birdNumber*self.middle.height))
        love.graphics.printcustom(self.page,(love.graphics.getWidth()*0.08),start+(self.birdNumber*self.middle.height)-love.graphics.getHeight()*0.014,{75,75,75},{font=self.pageFont})

        --Draw the bird selectors
        fold(self.alliesAvailable,function(ally) ally:draw() end)

    end
end

function AllyBox:draw()
    --Draw the actual UI box
    self.container:draw(self.drawFunction)
end

--@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
--STATIC FUNCTIONS@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
--@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

function AllyBox:requirement_loader()
    self.classes = {
        FriendlyBird = require "code.classes.Level.Birds.FriendlyBird"
    }
end AllyBox:requirement_loader()

function AllyBox:resource_loader()
    --Load the assets required
    local lgn = function(name) return love.graphics.appropriateImage("Level/UI/Presets/allyBox/"..name..".png") end
    self.assets = {
        top = lgn("top"),
        bottom = lgn("bottom"),
        middle = lgn("middle")
    }
end AllyBox:resource_loader()



return AllyBox
