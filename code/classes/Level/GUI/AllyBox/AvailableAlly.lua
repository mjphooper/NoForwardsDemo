AvailableAlly = Class("AvailableAlly",Clickable)  --IF THE CONTAINER POSITION IS CHANGED AFTER THIS HAS BEEN CREATED, THE POSITION OF THE BIRDS WON'T CHANGE.

function AvailableAlly:initialize(allyBox,id,count,x,y,level)
    --Inherit from clickable
    self.sprite = self.assets.miniBirds[id]

    --Refenrece
    self.allyBox = allyBox
    self.level = level
    self.container = self.allyBox.container

    --Rest
    self.id = id
    self.count = count
    self.w, self.h = self.sprite:getDimensions()
    self.phantoms = {}

    --Clickable inherit
    Clickable.initialize(self,x+self.container:getX(),y+self.container:getY(),self.sprite:getWidth(),self.sprite:getHeight(),level.scale)


end

 --UPDATE FUNCTIONS-------------------------------------------------------------
 -------------------------------------------------------------------------------

function AvailableAlly:update()
    --Reset phantom if clicked.
    if self.pressed(self) then
        if self.count > 0 then
            table.insert(self.phantoms,SpawnPhantom:new(self.id,self.x,self.y,self.container,self.level))
            self.count = self.count - 1
        end
    end

    --Update the phantoms, whilst checking for any trashes. Can't use fold!
    fold(self.phantoms, function(phantom,i) phantom:update() ; if phantom.trash then table.remove(self.phantoms,i) ; self.count = self.count + 1 end end)


end

 --DRAW FUNCTIONS---------------------------------------------------------------
 -------------------------------------------------------------------------------

function AvailableAlly:draw()
    local x,y = self.x - self.container:getX(), self.y - self.container:getY()
    --Draw the bird
    love.graphics.draw(self.sprite,x,y)

    --Draw the text
    love.graphics.printcustom(self.count,x+(love.graphics.getWidth()*0.085),y+(love.graphics.getHeight()*0.026),{75,75,75},{font=fonts.medium})

    --Draw clickable for debug
    self.clickable_draw(self)


    --Draw the phantom
    fold(self.phantoms,function(phantom) phantom:draw() end)
end

--@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
--STATIC FUNCTIONS@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
--@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

function AvailableAlly:resource_loader()
    self.assets = {
        miniBirds ={
            player1 = love.graphics.appropriateImage("Birds/FriendlyPlayers/Player 1/Mini/mini.png"),
            player2 = love.graphics.appropriateImage("Birds/FriendlyPlayers/Player 2/Mini/mini.png"),
            player3 = love.graphics.appropriateImage("Birds/FriendlyPlayers/Player 3/Mini/mini.png")
        }
    }
end AvailableAlly:resource_loader()
