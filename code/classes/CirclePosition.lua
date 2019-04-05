CirclePosition = Class("CirclePosition")

function CirclePosition:initialize(itemNumber,r,center)
    self.itemNumber = itemNumber
    self.radius = r
end

 --UPDATE FUNCTIONS-------------------------------------------------------------
 -------------------------------------------------------------------------------

function CirclePosition:generatePosition(i,center)
    local center = center or {x=0,y=0}
    local angle = (math.pi*2) / self.itemNumber
    local x = center.x + (self.radius * math.cos(i*angle))
    local y = center.y + (self.radius * math.sin(i*angle))
    return x,y
end


function CirclePosition:draw(center)
    setColor(0,0,0)
    love.graphics.circle("line",center.x,center.y,self.radius)
    setColor(255,0,0)
    for i =1,self.itemNumber,1 do
        local x,y=self.generatePosition(self,i,center)
        love.graphics.circle("fill",x,y,10)
    end
    flushColor()
end





--[[
     function ItemWheel:populateItemTables()
         local a = (math.pi*2)/self.itemNumber
         local reconstructed = {}
         for i = 1,self.itemNumber,1 do
             local item = self.items[i]
             --Set the width and height
             local w,h = self.items[i].sprite:getDimensions()
             --Set the draw location
             local x = (self.r * math.cos(i*a)) - (w*self.items[i].scale.x / 2)
             local y = (self.r * math.sin(i*a)) - (h*self.items[i].scale.y / 2)
             --Reconstruct temp
             table.insert(reconstructed,{x=x,y=y,w=w,h=h,scale=self.items[i].scale,clicked=self.items[i].clicked,sprite=self.items[i].sprite})
         end
         self.items = reconstructed
     end--]]
