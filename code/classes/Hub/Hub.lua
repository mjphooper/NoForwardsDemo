local Hub = Class("Hub")

function Hub:initialize()

    --Load the assets
    local c1 = love.graphics.appropriateImage("Hub/cloud-1.png")
    local c2 = love.graphics.appropriateImage("Hub/cloud-2.png")
    self.cloudSprites = {c1,c2}

    --Scale
    self.scale = mapScale

    --Get the requires
    self.player = (require "code.classes.Hub.Player"):new(self)
    self.background = (require "Code.Classes.Hub.Background"):new()
    self.gui = (require "Code.Classes.Hub.GUI"):new(self)
    self.Cloud = require "Code.Classes.Hub.Cloud"
    self.clouds = {}

end

--GENERAL FUNCTIONS-------------------------------------------------------------
--------------------------------------------------------------------------------

function Hub:manageClouds()
    while #self.clouds < 7 do
        table.insert(self.clouds,self.Cloud:new(self))
    end
    fold(self.clouds,function(cloud) cloud:update() end)
end


 --UPDATE FUNCTIONS-------------------------------------------------------------
 -------------------------------------------------------------------------------

function Hub:update()
    self.manageClouds(self)
    self.player:update()
end

 --DRAW FUNCTIONS---------------------------------------------------------------
 -------------------------------------------------------------------------------

function Hub:draw()
    love.graphics.push()
    love.graphics.scale(self.scale.x,self.scale.y)
    --Draw the hub things
    self.background:draw()
    fold(self.clouds,function(cloud) cloud:draw() end)
    self.player:draw()
    love.graphics.pop()
end

return Hub
