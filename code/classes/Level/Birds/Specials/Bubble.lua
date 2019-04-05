local Bubble = Class("Bubble",SimpleGravityObject)

function Bubble:initialize(x,y,color,key)
    SimpleGravityObject.initialize(self,love.math.random(200,275),x,y)
    --Core things
    self.x,self.y = x,y
    self.sprite = self.assets[color]
     self.scale = {x=0.6,y=0.6}
    self.w,self.h = self.sprite:getWidth() *  self.scale.x, self.sprite:getHeight() * self.scale.y
    self.key = key

    self.status = "pending"

    --Shake!
    self.shake = Shake:new({growth=5,amplitude=love.math.random(20,40),frequency=50})
    self.shake:setAmount(1)

    --Timer
    self.time = 1.8 --seconds
    self.count = self.time

    --Drawing vars
    self.opacity = 255
    self.textOffset = {x=0.3*self.scale.x,y=20*self.scale.y}


end

 --UPDATE FUNCTIONS-------------------------------------------------------------
 -------------------------------------------------------------------------------
function Bubble:updateTimer()
    self.count = time:countDown(self.count)
    self.checkFailure(self)
end

function Bubble:updateShake()
    local shakeAmount = (self.count / self.time)
    if shakeAmount < 0.5 and shakeAmount > 0 then
        time:forcePush(1)
        self.shake:update()
        time:pop()
    end

end

function Bubble:checkForKeyPress()
    if keyboard.keyDown == self.key then --The correct key has been pressed!
        self.status = "completed"
    end
end

function Bubble:checkFailure()
    if self.count < 0 then
        self.status = "failed"
    end
end

function Bubble:trashUpdate()
    self.shake:update()
    self.applyForces(self)
    self.opacity = time:deltaDec(self.opacity,500)
end

function Bubble:update()
    self.updateShake(self)
    self.updateTimer(self)
    self.checkForKeyPress(self)
end

 --DRAW FUNCTIONS---------------------------------------------------------------
 -------------------------------------------------------------------------------

function Bubble:setPosition(x,y)
    self.x,self.y = x,y
end

function Bubble:draw()
    self.shake:preDraw()
    setColor(255,255,255,self.opacity)
    local x,y = self.x-self.w/2,self.y-self.h/2
    love.graphics.draw(self.sprite,x,y,0,self.scale.x,self.scale.y)
    love.graphics.push()
    love.graphics.scale(self.scale.x,self.scale.y)
    love.graphics.printcustom(self.key,(x+self.textOffset.x)/self.scale.x,(y+self.textOffset.y)/self.scale.y,{0,0,0,self.opacity},{font=fonts.xlarge})
    love.graphics.pop()
    flushColor()
    self.shake:postDraw()

end


--@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
--STATIC FUNCTIONS@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
--@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
--This is where the initial layout of the bubbles is defined.
function Bubble:generateNew(stream,key)
    local x,y = stream.number * 350 , 200
    return Bubble:new(x,y,stream.color,key)
end

function Bubble:resource_loader()
    local f = "Level/Special Moves/bubble_"
    self.assets = {
        red = love.graphics.appropriateImage(f.."red.png"),
        lime = love.graphics.appropriateImage(f.."lime.png"),
        orange = love.graphics.appropriateImage(f.."orange.png"),
        mint = love.graphics.appropriateImage(f.."mint.png"),
        blue = love.graphics.appropriateImage(f.."blue.png")
    }
end Bubble:resource_loader()

return Bubble
