local Action = Class("Action")

function Action:initialize(actionEvent)
    self.name = actionEvent.name
    self.spriteTable = actionEvent.spriteTable

    self.frameLength = actionEvent.frameLength / 100
    self.frameLengthCounter = 0

    self.counter = 1

    self.tableSize = #self.spriteTable
end


function Action:update()
    if self.frameLengthCounter < self.frameLength then
        self.frameLengthCounter = time:deltaInc(self.frameLengthCounter,1)
    else
        self.counter = self.counter + 1
        self.frameLengthCounter = 0
        if self.counter > self.tableSize then
            return true
        end
    end
    return false
end

function Action:draw(x,y,scale,rotation,rotationPoint)
    local spr = self.spriteTable[self.counter]
    if rotationPoint == "middle" then
        love.graphics.draw(spr,x,y,rotation,scale.x,scale.y,spr:getWidth()/2,spr:getHeight()/2)
    elseif rotationPoint == "corner" then
        love.graphics.draw(spr,x,y,rotation,scale.x,scale.y)
    end
end

function Action:draw_quad(img,x,y,scale,rotation,rotationPoint)
    local quad = self.spriteTable[self.counter]
    if rotationPoint == "middle" then
        love.graphics.draw(img,quad,x,y,rotation,scale.x,scale.y,quad:getWidth()/2,quad:getHeight()/2)
    elseif rotationPoint == "corner" then
        love.graphics.draw(img,quad,x,y,rotation,scale.x,scale.y)
    end
end

-----------------------------------------------------------------------------------------------------
------------------------ANIMATOR---------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------


Animator = Class("Animator")

--function Animator:initialize(defaultAction,frameLength,config)
function Animator:initialize(defaultAction,frameLength,config)
    self.actionQueue = Queue:new()
    self.allActions = {}
    self.defaultAction = defaultAction

    --Parse the config parameter
    local config = config or {}
    self.quad = false
    if notnil(config.quadImage) then self.quad = true; self.quad_image = config.quadImage end
    self.loop = true
    if notnil(config.loop) then self.loop = config.loop end
    self.paused = false
    if notnil(config.paused) then self.paused = config.paused end
    self.hibernate = false
    if notnil(config.hibernate) then self.hibernate = config.hibernate end
    self.rotationPoint = "corner"
    if notnil(config.rotation) then self.rotationPoint = config.rotation end


    self.drawScale = {x=1,y=1}
    self.drawColor = {r=255,g=255,b=255,a=255}
    self.rotation = 0
    self.start(self,frameLength)
    self.finished = false
end

function Animator:scrambleFrames() --So the animations don't look syced on screen! Use once.
    local action = self.actionQueue:peek()
    action.counter = love.math.random(1,action.tableSize)
end

--Boring setters and getters
function Animator:start(frameLength)
    self.supplyAction(self,self.defaultAction,frameLength)
    self.pushAction(self,self.defaultAction.name)
end

function Animator:pause()
    self.paused = true
end

function Animator:resume()
    self.paused = false
end

function Animator:awake()
    self.hibernate = false
end

function Animator:sleep()
    self.hibernate = true
end

function Animator:isPaused()
    return self.paused
end

function Animator:isAwake()
    return self.hibernate
end

function Animator:supplyAction(actionTable,frameLength)
    actionTable['frameLength'] = frameLength
    self.allActions[actionTable.name] = actionTable
end

function Animator:getDefault()
    return self.defaultAction.name
end

function Animator:getCurrent()
    return self.actionQueue:peek().name
end

function Animator:getDimensions()
    local imageDimensions = function()
        return self.defaultAction.spriteTable[1]:getWidth()*self.drawScale.x,
               self.defaultAction.spriteTable[1]:getHeight()*self.drawScale.y
    end

    if pcall(imageDimensions) then
        return imageDimensions()
    else
        print(tostring(self.defaultAction.spriteTable[1]))
        local x,y,w,h = self.defaultAction.spriteTable[1]:getViewport()
        return w,h
    end
end

function Animator:replaceDefault(namedNewDefault)
    self.defaultAction = self.allActions[namedNewDefault]
    self.pushAction(self,namedNewDefault,true)
end

--Push the next action to be played.

function Animator:pushAction(name,force) --force = force the animation to play? or wait until end of current animation?
    local action = self.allActions[name]
    if action == nil then print("ERR:: NO ACTION OF THE NAME "..name.." FOUND.") return
    else
        if force then
            self.actionQueue:pop()
        end
        self.actionQueue:push(Action:new(action),self.drawScale)
    end
end



--UPDATE FUNCTIONS--------------------------------------------------------------
--------------------------------------------------------------------------------

function Animator:update()
    if not(self.paused or self.hibernate) then --only update the frames if the animator is not paused.
        local status = self.actionQueue:peek():update() --update the primary action
        if status == true then --the current animation has finished
            self.actionQueue:pop() --remove the current item from the queue
            if self.actionQueue:getSize() == 0 then
                self.pushAction(self,self.defaultAction.name) --if queue is empty, readd the default action
            end
            --If no loop, mark as finished pause!
            if not self.loop then
                self.finished = true
                 self.sleep(self)
            end
        end
        return self.actionQueue:peek().name
    end
end

--DRAW UNCTIONS-----------------------------------------------------------------
--------------------------------------------------------------------------------
function Animator:setDrawScale(s) --Where s = {x=scale,y=scale}
    self.drawScale = s
end

function Animator:setDrawColor(r,g,b,a)
    if not notnil(a) then a = 255 end
    self.drawColor = {r=r,g=g,b=b,a=a}
end

function Animator:setRotation(rads)
    self.rotation = rads
end

function Animator:addRotation(rads)
    self.rotation = self.rotation + rads
end

function Animator:flushColor()
    self.drawColor = {r=255,g=255,b=255}
end

function Animator:draw(x,y)
    if self.quad == false then --if not using quads
        love.graphics.setColor(self.drawColor.r/255,self.drawColor.g/255,self.drawColor.b/255,self.drawColor.a/255)
        if not self.hibernate then self.actionQueue:peek():draw(x,y,self.drawScale,self.rotation,self.rotationPoint) end
        love.graphics.setColor(255,255,255)
    elseif self.quad then
        love.graphics.setColor(self.drawColor.r/255,self.drawColor.g/255,self.drawColor.b/255,self.drawColor.a/255)
        if not self.hibernate then self.actionQueue:peek():draw_quad(self.quad_image,x,y,self.drawScale,self.rotation,self.rotationPoint) end
        love.graphics.setColor(255,255,255)
    end
end








----------------------------------------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------------------------------------
--DOUCUMENTATION------------------------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------------------------------------
--[[
    [CLASS: Action]
    Action(actionEvent)
        @param actionEvent = the details of the action to instantiated.

    update()
        @method = all the animation logic goes within this update function.
        @return = wether or not the current action has finished.

    draw()
        @method = delete the current sprite of the animation.

[CLASS: Animator]
Animator(defaultAction,frameLength)
    @param defaultAction = the action table that will be used as default
    @param frameLength = the length that each frame should be displayed for. IE the speed.

start(frameLength)
    @method = initiate the default animation from the class.

supplyAction(actionTable,frameLength)
    @method = provide an action for the animator. Such as 'attack', 'die' etc.
    @param actionTable = the table of sprites to be added.
    @param frameLength = the length of the frame duration.

pushAction(name,force)
    @method = add an action by name to the action queue.
    @param name = the name of the action to add to the action queue
    @param force = wether to force this action to interrupt the current and push into the front of the queue.

getDimensions()
    @return the w and h of the initial sprite in the default table.

update()
    @method = run the animaton by calling the action update() method. Handles an ending action etc.

setDrawScale(s)
    @method = set the draw scale for drawing the current sprite.
    @param s = the draw scale.

draw(x,y)
    @method = draw the sprite by calling the action draw().
    @param x,y = position to draw

--]]
