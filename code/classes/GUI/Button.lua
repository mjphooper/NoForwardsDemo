--BUTTON------------------------------------------------------------------------
--------------------------------------------------------------------------------
Button = Class("Button",Clickable)

function Button:initialize(x,y,textConfig,imgConfig)
    Clickable.initialize(self,container.x+x,container.y+y,imgConfig.img:getWidth()*imgConfig.scalex,imgConfig.img:getHeight()*imgConfig.scaley)

    self.textConfig = textConfig
    self.imgConfig = imgConfig
    self.func = function() print("This button has no defined function.") end
    --Positional difference okay at this point.
end

function Button:setFunction(f)
    self.func = f
end

function Button:update()
    if self.pressed(self) then
        return self.func()
    end
end

function Button:draw()
    love.graphics.draw(self.imgConfig.img,self.x+self.container.x,self.y+self.container.y,0,self.imgConfig.scalex or 1,self.imgConfig.scaley or 1)
    love.graphics.printcustom(self.textConfig.text,self.x+self.textConfig.x,self.y+self.textConfig.y,{0,0,0})
end
