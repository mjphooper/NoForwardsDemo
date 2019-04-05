local EnemyStream = Class("EnemyStream")

function EnemyStream:initialize(level)
    self.level = level
    self.map = self.level.map

    self.generationRate = 4 --seconds per bird generation
    self.current_maxOnscreen = 0
    self.limit_maxOnScreen = 7
    self.timer = 100

    self.bossGenerated = 0

    self.mapProgress = 0
end

--GENERATION FUNCTIONS----------------------------------------------------------
--------------------------------------------------------------------------------

function EnemyStream:getMapProgress()
    self.mapProgress =  self.map:calculateProgress()
end

function EnemyStream:calculateGenerationRate()
    local r = self.mapProgress
    --Used to slow down the rate at which generation increases. Gets waaaay too fast at the end otherwise.
    local padding = 0.5
    --0 and 1 checks
    if r == 0 or r == 1 then r = 0.01 end
    return r * padding
end

function EnemyStream:calculateScreenMax()
    local r = self.mapProgress
    local padding = 0.7
    --make the % a number between 1-10, and pad that
    r = math.floor((r * 10) * padding)
    --and limit to between
    self.current_maxOnscreen = math.limitBetween(1,r,self.limit_maxOnScreen)
end

function EnemyStream:generateEnemy()

    if #self.level.enemyBirds + 1 <= self.current_maxOnscreen then
        self.classes.EnemyBird:generateNew(self.level)
        self.timer = 0
    end
end

function EnemyStream:generateBoss()
    if self.map:getProgress() > 0 and self.bossGenerated < 1 then
        local boss = self.classes.Boss:new({mass=250,x=love.math.random(love.graphics.getWidth(),2*love.graphics.getWidth()),y=100},self.level)
        table.insert(self.level.enemyBirds,#self.level.enemyBirds,boss)
        self.bossGenerated = self.bossGenerated + 1
    end
end
--UPDATE FUNCTIONS--------------------------------------------------------------
--------------------------------------------------------------------------------
function EnemyStream:update()
    self.getMapProgress(self)
    self.timer = time:deltaInc(self.timer,1)
    self.calculateScreenMax(self)
    --self.generateBoss(self)
    if self.timer > self.generationRate * (1-self.calculateGenerationRate(self)) then
        self.generateEnemy(self)
    end
end


--@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
--STATIC FUNCTIONS@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
--@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

function EnemyStream:requirement_loader()
    self.classes = {
        EnemyBird = require "code.classes.Level.Birds.EnemyBird",
        Boss = require "code.classes.Level.Birds.Boss"
    }
end EnemyStream:requirement_loader()


return EnemyStream
