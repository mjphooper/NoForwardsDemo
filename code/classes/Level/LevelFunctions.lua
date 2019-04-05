local LevelFunctions = Class("LevelFunctions")

function LevelFunctions:initialize(level)
    self.level = level
end

function LevelFunctions:setShakeObj(obj)
    self.level.shake = obj
end

function LevelFunctions:resetShakeObj()
    self.level.shake = self.level.defaultShake
end

function LevelFunctions:updateShake()
    local healthPc = self.level.player.health / self.level.player.maxHealth
    if healthPc < 0.2 then
        self.level.shake:update()
        self.level.shake:setAmount((1-self.level.player.health/self.level.player.maxHealth)*15)
        self.level.shake:setAmplitude(((self.level.player.maxHealth*0.1)-self.level.player.health)*0.5)
    end
end

--UPDATE THA MOUSE
function LevelFunctions:scaleMouse()
    mouse.x = mouse.x / self.level.scale.x
    mouse.y = mouse.y / self.level.scale.y
    mouse.clickx = mouse.clickx / self.level.scale.x
    mouse.clicky = mouse.clicky / self.level.scale.y
end

--TIME vars
function LevelFunctions:setTime(t)
    self.level.time = math.min(self.level.time,t)
end
function LevelFunctions:resetTime()
    self.level.time = 1
end

function LevelFunctions:preNatural()
    time:forcePush(1)
end
function LevelFunctions:postNatural()
    time:pop()
end

--block the pause?
function LevelFunctions:pauseBlock()
    if self.level.player.special:isActive() then
        return true
    end
    return false
end

function LevelFunctions:togglePause()
    if keyboard.keyDown == "p" and not self.pauseBlock(self) then
        if self.level.paused then
            self.level.paused = false
            self.level.time = 1
        else
            self.level.paused = true
            self.level.time = 0
        end
    end
end

--SHADER LEVEL
function LevelFunctions:calculateShaderLevel() --0 = normal, 1 = black and white
    local percentage = self.level.player.health / self.level.player.maxHealth
    if percentage > 0.25
        then return 0
    else
        local a =  1-(self.level.player.health/(self.level.player.maxHealth/5))
        if a > 1 then a = 1 end
        return a
    end
end

return LevelFunctions
