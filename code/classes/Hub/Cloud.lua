local Cloud = Class("Cloud")

function Cloud:initialize(hub)
    --Reference var
    self.hub = hub
    --Pick the sprite
    self.sprite = self.hub.cloudSprites[love.math.random(1,#self.hub.cloudSprites)]

    --Get the position and szie
    self.w = self.sprite:getWidth() * self.hub.scale.x
    self.h = self.sprite:getHeight() * self.hub.scale.y
    self.x = love.math.random(-lg.getWidth()/self.hub.scale.x,-self.w)
    self.y = love.math.random(0,lg.getHeight()/self.hub.scale.y-self.h)

    --Set the speed and stuff
    self.speed = love.math.random(100,250)
    self.floatedAway = false



end

 --UPDATE FUNCTIONS-------------------------------------------------------------
 -------------------------------------------------------------------------------

function Cloud:move()
    self.x = time:deltaInc(self.x,self.speed)
    if self.x > lg.getWidth() / self.hub.scale.x then
        self.floatedAway = true
    end
end

function Cloud:update()
    self.move(self)
    Cloud:collectFluff(self.hub.clouds)
end

 --DRAW FUNCTIONS---------------------------------------------------------------
 -------------------------------------------------------------------------------

function Cloud:draw()
    love.graphics.draw(self.sprite,self.x,self.y)
end


--@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
--STATIC FUNCTIONS@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
--@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

function Cloud:collectFluff(tbl)
    for i = #tbl,1,-1 do
        if tbl[i].floatedAway then
            table.remove(tbl,i)
        end
    end
end

return Cloud
