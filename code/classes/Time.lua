Time = Class("Time")

function Time:initialize()
    self.stack = Stack:new()
    self.pause = false
end

--GENERAL TIME SETTING AND GETTING FUNCTIONS------------------------------------
--------------------------------------------------------------------------------
function Time:getDelta()
    return love.timer.getDelta()
end

function Time:getScaledDelta()
    return self.getDelta(self) * (self.stack:peek() or 1) --If the stack is empty, peek will return false so scale by 1.
end

--DELTA INCREMENTING FUNCTIONS--------------------------------------------------
--------------------------------------------------------------------------------
function Time:deltaInc(var,amount)
    return (var) + self.getScaledDelta(self) * amount
end
function Time:deltaDec(var,amount)
    return (var) - self.getScaledDelta(self) * amount
end

function Time:countDown(var)
    return var - love.timer.getDelta()
end

--Push and pop time scales to the stack [works like lg.push(),lg.pop()]---------
--------------------------------------------------------------------------------
function Time:push(scale)
    self.stack:push(math.min(self.stack:peek() or 1,scale)) --If something else is making the screen slower, don't make it faster. [Such as pause.]
end

function Time:forcePush(scale)
    self.stack:push(scale)
end

function Time:pop()
    return self.stack:pop() or "failed- more pushes than pops?"
end
