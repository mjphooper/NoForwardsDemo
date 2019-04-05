local Collectable = Class("Collectable")

function Collectable:initialize(map,player,x,y,w,h)
    self.x = x
    self.y = y
    self.w = w or 0
    self.h = h or 0

    self.scale = {x=1,y=1}
    self.map = map
    self.player = player
    self.distTravelled = self.map.distanceTravelled_pixels
    self.trash = false
end

function Collectable:collision()
    setColor(255,0,0)
    love.graphics.rectangle("fill",self.x-self.map.distanceTravelled_pixels,self.y,self.w,self.h)
    setColor(0,255,0)
    love.graphics.rectangle("fill",self.player.x,self.player.y,self.player.w,self.player.h)
    flushColor()

    if squareCollision(self.x-self.map.distanceTravelled_pixels,self.y,self.w,self.h,self.player.x,self.player.y,self.player.w,self.player.h) then
        self.pickUp(self)
        self.trash = true
        return
    end
    return false
end

function Collectable:collectable_update()
    self.collision(self)
end

function Collectable:collectable_draw()
end

--@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
--STATIC FUNCTIONS@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
--@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

function Collectable:collectTrash(tbl)
    for i = #tbl,1,-1 do
        if tbl[i].trash then
            table.remove(tbl,i)
        end
    end
end

return Collectable
