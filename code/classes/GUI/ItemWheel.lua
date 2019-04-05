--ITEM WHEEL--------------------------------------------------------------------
--------------------------------------------------------------------------------
ItemWheel = Class("ItemWheel")
--item sprites = {{spr},{spr},{spr},{spr}}
function ItemWheel:initialize(player,r,config)
    self.player = player
    self.r = r
    self.items = {}
    self.itemNumber = 0
    self.selected = 0

    --Parse the config
    local config = config or {}
    self.decals = config.decals or true
end

function ItemWheel:getCentreX()
    return self.player.x+(self.player.w/2)
end

function ItemWheel:getCentreY()
    return self.player.y+(self.player.h/2)
end

-- items = {sprite,scale,clicked = function()}
function ItemWheel:setItems(items)
    self.items = items
    self.itemNumber = #items
    self.populateItemTables(self)
end

function ItemWheel:addItem(item)
    table.insert(self.items,item)
    self.itemNumber = self.itemNumber + 1
    self.populateItemTables(self)
end

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
end

function ItemWheel:getClickCollison(item)
    if mouse.click then
        if pointCollision(mouse.clickx,mouse.clicky,item.x,item.y,item.w,item.h) then
            item.clicked()
        end
    end
end

function ItemWheel:update()
    for i = 1,self.itemNumber,1 do
        local item = self.items[i]
        self.getClickCollison(item)
    end
end

function ItemWheel:drawItems()
    for i =1,#self.items,1 do
        local item = self.items[i]
        local itemX, itemY = self.getCentreX(self)+item.x,self.getCentreY(self)+item.y
        --Draw the background circle
        local backingCentreX, backingCentreY = itemX+((item.w*item.scale.x)/2),itemY+((item.h*item.scale.y)/2)
        local backingRadius = (item.w*item.scale.x)*0.75
        local scale = self.player.level.scale

        if math.lineSegmentIntersectsCircle(backingCentreX,backingCentreY,backingRadius,self.getCentreX(self),self.getCentreY(self),mouse.x/scale.x,mouse.y/scale.y)
           then
            setColor(255,255,255) else setColor(215,215,215,150)
            self.selected = i
        end

        setColor(0,255,0)
        love.graphics.circle("fill",backingCentreX,backingCentreY,backingRadius)

        --line segment
        setColor(255,0,0)
        lg.line(self.getCentreX(self),self.getCentreY(self),mouse.x/scale.x,mouse.y/scale.y)
        flushColor()

        --Draw the item


        love.graphics.draw(item.sprite,itemX,itemY,0,item.scale.x,item.scale.y)
    end

end

function ItemWheel:draw()
    --Draw the circle outline
    setColor(255,255,255,100)
    love.graphics.circle("line",self.getCentreX(self),self.getCentreY(self),self.r)
    flushColor()
    self.drawItems(self)
end
