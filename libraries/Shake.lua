Shake = Class("Shake")

function Shake:initialize(config) --defaults to name,5,3,100
    self.growth = config.growth
    self.amplitude = config.amplitude
    self.frequency = config.frequency

    self.amount = 10
    self.time = 0
end

function Shake:setAmplitude(amount)
    if amount >= 0 then
        self.amplitude = amount
    end
end



function Shake:reset()
    self.amount = 1
    self.time = 0
end

function Shake:update()
    self.amount = math.max(1, self.amount)
    self.time = time:deltaInc(self.time,1)
end

function Shake:more()
    self.amount = self.amount + self.growth
end

function Shake:setAmount(amount)
    if amount < 0 then amount = 0 end
    self.amount = amount
end

function Shake:stop()
    self.amount = 0
end

function Shake:preDraw()
    local shakeFactor = self.amplitude * math.max(0.1,math.log(self.amount))
    local waveX = math.sin(self.time * self.frequency)
    local waveY = math.cos(self.time * self.frequency)
    love.graphics.push()
    love.graphics.translate(shakeFactor * waveX, shakeFactor * waveY)
end

function Shake:postDraw()
    love.graphics.pop()
end

return Shake
