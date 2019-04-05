local Quicktimer = Class("Quicktimer")

function Quicktimer:initialize(bird,move)
    --Reference
    self.bird = bird
    self.level = self.bird.level
    self.controller = bird.special
    self.move = move

    --dependency.stream = the stream in which the dependency lies.
    --dependency.item = the key number in the stream that MUST BE COMPLETED for this to be run. ie 1, the first item of stream x has been pressed.
    self.streams = self.move:getStreams()
    self.streamNumber = #self.streams
    self.populateBubbles(self)

    --Bubble position
    self.positions = CirclePosition:new(self.streamNumber,100)

    self.completed = false

end

--INITILIZE THE BUBBLES---------------------------------------------------------
--------------------------------------------------------------------------------

function Quicktimer:assignBubblePosition(i)
    return  (i-1)*150,60
end

function Quicktimer:populateBubbles()
    local colors = {"lime","red","blue","orange","mint"}
    for i = 1,self.streamNumber,1 do
        local stream = self.streams[i]
        stream.bubble = {}
        stream.active = false
        stream.color = colors[i]
        stream.passed = 0
        stream.number = i
    end
end

--BUBBLE GENERATION-------------------------------------------------------------
--------------------------------------------------------------------------------

function Quicktimer:checkDependency(stream,pos) --True if dependency met.
    return self.streams[stream].passed >= pos --If the number of passed in stream >= required passes.
end

function Quicktimer:pollStreams()
    local count = self.streamNumber
    for i = 1,self.streamNumber,1 do
        --If stream isn't active and there is a waiting key, check to see if dependencies are met!
        if (not self.streams[i].active) and #self.streams[i] > 0 then
            self.newBubble(self,i)
        --Check to make sure all the streams haven't finished.
    elseif #self.streams[i] == 0 then --if the current stream is empty,
            count = count - 1
        end
    end

    if count == 0 then
        self.successfulFinish(self)
    end
end


function Quicktimer:newBubble(i)
    local stream = self.streams[i]
    local head = stream[1]
    local generate = function(stream)
        --Generate the bubble
        stream.bubble = self.classes.Bubble:new(x,y,stream.color,head.key,self.level.scale)

        --End generation
        stream.active = true
    end

    --If there is a dependency and the dependency is met,
    if (head.dependency ~= "none") and (self.checkDependency(self,head.dependency.stream,head.dependency.item))  then
        generate(stream)
    elseif (head.dependency == "none") then --There is no dependency, so go!
        generate(stream)
    end
end

--RESET THE BUBBLE WHEN NECESSARY-----------------------------------------------
--------------------------------------------------------------------------------

function Quicktimer:collectFailed()
    fold(self.streams,function(stream)
        if stream.active then
            table.insert(self.controller.trashTable,stream.bubble)
        end
    end)
end

function Quicktimer:cleanBubble(stream)
    if stream.bubble.status == "completed" then
        stream.bubble = {}
        stream.active = false
        stream.passed = stream.passed + 1
        table.remove(stream,1)
        self.pollStreams(self) --To immediately replace bubble if necessary! Prevents a flicker delay until the next frame.
    elseif stream.bubble.status == "failed" then
        self.collectFailed(self)
        --ON FAIL CODE GOES HERE.
        self.controller:reset()
        self.level.functions:resetTime()
    end
end

--SUCCESFUL QUICKTIME EVENT-----------------------------------------------------
--------------------------------------------------------------------------------
function Quicktimer:successfulFinish()
    self.completed = true
    self.move:onStart()
end

 --UPDATE FUNCTIONS-------------------------------------------------------------
 -------------------------------------------------------------------------------

function Quicktimer:update()
    self.pollStreams(self)

    --Update the bubbles and check for a trash or completion!
    foldCondition(self.streams,function(stream)
        stream.bubble:update()
        self.cleanBubble(self,stream)
    end,
    function(stream) return stream.active end)
end

 --DRAW FUNCTIONS---------------------------------------------------------------
 -------------------------------------------------------------------------------

function Quicktimer:draw()
    --Draw the bubles.
    for i = 1,self.streamNumber,1 do
        if self.streams[i].active then
            local stream = self.streams[i]
            stream.bubble:setPosition(self.positions:generatePosition(i,{x=self.bird.x+self.bird.w/2,y=self.bird.y+self.bird.h/2}))
            stream.bubble:draw()
        end
    end
end

--@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
--STATIC FUNCTIONS@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
--@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

function Quicktimer:requirement_loader()
    self.classes = {
        Bubble = require "code.classes.Level.Birds.Specials.Bubble"
    }
end Quicktimer:requirement_loader()


return Quicktimer
