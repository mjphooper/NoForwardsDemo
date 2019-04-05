--INHERITANCE REQUIREMENTS------------------------------------------------------
local IndependentBird = require "code.classes.Level.Birds.IndependentBird"
local BirdObject = require "code.classes.Level.Birds.BirdObject"
--------------------------------------------------------------------------------

local EnemyBird = Class("EnemyBird",IndependentBird)

function EnemyBird:initialize(config,level,playerScale)
    IndependentBird.initialize(self,Animator:new(BirdObject.assets.enemyPlayers.greenEnemy.idle,2,{paused=false,loop=true}),config,level,playerScale)
    --Override inherited data members
    self.opponents = {birds = self.level.friendlyBirds,
                      projectiles = {},
                      targetedPlayer = false
                  }
    --Add the player in from the start
    self.opponents.birds = merge(self.level.friendlyBirds,{self.level.player})

    self.projectileTable = self.level.enemyProjectiles
    self.ventureRange.min = (lg.getWidth()/self.level.scale.x)*(self.ventureDistance)
    self.ventureRange.max = (lg.getWidth()/self.level.scale.x)
    self.movementPoint = self.generatePoint(self)

    --Drop
    self.dropLikelyhood = 0.1

    --Give a weapon
    self.weapon = self.classes.BulletShooter:new(self,9000)

    --Death action
    local deaths = {"Fall","Explode","Rise","Crash"}
    self.deathAction = self.classes.deaths[deaths[love.math.random(1,#deaths)]]:new(self)

    --Health ovveride.
    self.health = 1

end

--GENERATION FUNCTION-----------------------------------------------------------
--------------------------------------------------------------------------------
function EnemyBird:generateNew(level) --@STATIC
    local w = lg.getWidth() / level.scale.x
    local lims = {xmin=w-600,xmax=w-250,ymin=50,ymax=50}

    --Create the object
    local rx,ry = love.math.random(lims.xmin,lims.xmax), love.math.random(lims.ymin,lims.ymax)
    local birdToAdd = EnemyBird:new({mass=250,x=rx,y=ry},level,{x=0.4,y=0.4})
    table.insert(level.enemyBirds,birdToAdd)
    --Assign targeting to the object
    birdToAdd:findTargets(birdToAdd.intelligence)
    birdToAdd:notifyOpponents()

    --Open communications for created
    return birdToAdd
end

function EnemyBird:targetPlayer()
    if not self.opponents.targetedPlayer then
        if #self.targets > 0 then
            if self.level.player.targetedBy <= self.targets[1].targetedBy-1 then
                self.targets[1].targetedBy = self.targets[1].targetedBy - 1
                self.targets[1] = self.level.player
                self.level.player.targetedBy = self.level.player.targetedBy + 1
            end
        elseif #self.targets == 0 then
            table.insert(self.targets,self.level.player)
            self.level.player.targetedBy = self.level.player.targetedBy + 1
        end
    end
end

function EnemyBird:onDeath()
    if self.isDead(self) and not self.dropped then
        self.dropCollectables(self)
        self.dropXP(self)
    end
end


function EnemyBird:dropCollectables() --Heavy ties into the map object
    if love.math.random() < self.dropLikelyhood then
        local map = self.level.map
        table.insert(map.objects,self.classes.Health:new(map,self.level.player,self.getMid(self)))
    end
    if love.math.random() < self.dropLikelyhood then
        local map = self.level.map
        table.insert(map.objects,self.classes.Power:new(map,self.level.player,self.getMid(self)))
    end
    self.dropped = true
end

function EnemyBird:dropXP()
    local xp = love.math.random(1,25)
    local decoration = self.classes.XPGain:new(self.level,self.x,self.y,xp)
    table.insert(self.level.decorations,decoration)
end


--UPDATE FUNCTION---------------------------------------------------------------
--------------------------------------------------------------------------------

function EnemyBird:update()
    self.opponents.projectiles = merge(self.level.friendlyProjectiles,self.level.player.playerProjectiles)
    self.opponents.birds = merge(self.level.friendlyBirds,{self.level.player})
    --Unwavering statics
    BirdObject:collectTrash(self.level.enemyBirds)
    self.updateAnimation(self)
    --Check to update the death
    if self.deathAction:branch("update") then return end
    --Inherited updates
    self.independentBird_update(self)
    self.onDeath(self)

end

--DRAW FUNCTION---------------------------------------------------------------
--------------------------------------------------------------------------------

function EnemyBird:draw()
    self.independentBird_draw(self)
end

--@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
--STATIC FUNCTIONS@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
--@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

function EnemyBird:requirement_loader()
    self.classes = {
        Health = require "code.classes.Level.Collectables.Health",
        Power = require "code.classes.Level.Collectables.Power",
        BirdDeath = require "code.classes.Level.Birds.Die.BirdDeath",
        XPGain = require "code.classes.Level.Decoration.XPGain",
        BulletShooter = require "code.classes.Level.Birds.Weapons and Projectiles.Weapons.BulletShooter",
        deaths = {
            Rise = require "code.classes.Level.Birds.Die.Rise",
            Explode = require "code.classes.Level.Birds.Die.Explode",
            Fall = require "code.classes.Level.Birds.Die.Fall",
            Crash = require "code.classes.Level.Birds.Die.Crash"
        }
    }
end EnemyBird:requirement_loader()


return EnemyBird
