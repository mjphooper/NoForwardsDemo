--INHERITANCE REQUIREMENTS------------------------------------------------------
local EnemyBird = require "code.classes.Level.Birds.EnemyBird"
local BirdObject = require "code.classes.Level.Birds.BirdObject"
--------------------------------------------------------------------------------

local Boss = Class("Boss",EnemyBird)

function Boss:initialize(config,level)
    EnemyBird.initialize(self,config,level,{x=1.5,y=1.5})

    --Make the boss smater!
    self.intelligence = 3
    --And stroger!
    self.maxHealth = 1000
    self.health = 1000

    --The tables to store the collision explosions
    self.hitExplosions = {} --These will be animations!

end

--GENERATION FUNCTION-----------------------------------------------------------
--------------------------------------------------------------------------------
function Boss:generateNew(level) --@STATIC
    local w = lg.getWidth() / level.scale.x
    local lims = {xmin=w-600,xmax=w-250,ymin=50,ymax=50}

    --Create the object
    local rx,ry = love.math.random(lims.xmin,lims.xmax), love.math.random(lims.ymin,lims.ymax)
    local boss = Boss:new({mass=250,x=rx,y=ry},level)
    table.insert(level.enemyBirds,boss)
    --Assign targeting to the object
    boss:findTargets(boss.intelligence)
    boss:notifyOpponents()

    --Open communications for created
    --return boss
end

function Boss:generateHitExplosion(projectile)
    local animation = Animator:new(self.assets.yellowExplosion.default,4,{paused=false,loop=false,rotationPoint="middle"})
    --configure the animation
    local scale = love.math.random(0.7,1.2)
    animation:setDrawScale({x=scale,y=scale})
    --animation:setRotation(love.math.random(0,2*math.pi))

    local explosionTable = {
        x = projectile.x - projectile.w/2,
        y = projectile.y - projectile.h/2 ,
        animation = animation
    }

    table.insert(self.hitExplosions,explosionTable)
end

function Boss:cleanOldExplosions()
    fold(self.hitExplosions,function(explosion,i) if explosion.animation.finished then table.remove(self.hitExplosions,i) end end)
end

--OVERRIDED FUNCTIONS-----------------------------------------------------------
--------------------------------------------------------------------------------

function Boss:gotHit(projectile) --Oringally from BirdObject.
    --Add an explosion to the hit list
    self.generateHitExplosion(self,projectile)

    self.health = self.health - projectile.damage
    --self.animation:pushAction("hit",true)
    --Destroy the projectile which hit the player.
    projectile.putInBin = true

end


 --UPDATE FUNCTIONS-------------------------------------------------------------
 -------------------------------------------------------------------------------

function Boss:update()
    --INHERITED UPDATE
        --Unwavering statics
        BirdObject:collectTrash(self.level.enemyBirds)
        self.updateAnimation(self)
        --Check to update the death
        if self.deathAction:branch("update") then return end
        --Inherited updates
        self.independentBird_update(self)
        --self.dropCollectables(self)
        fold(self.hitExplosions,function(explosion) explosion.animation:update() end)
    --END INHERTIED

    self.opponents.projectiles = merge(self.level.friendlyProjectiles,self.level.player.playerProjectiles)
    self.cleanOldExplosions(self)

end

 --DRAW FUNCTIONS---------------------------------------------------------------
 -------------------------------------------------------------------------------

function Boss:draw()
    --INHERITED UPDATE
        self.independentBird_draw(self)
    --END INHERITED
    fold(self.hitExplosions,function(explosion) explosion.animation:draw(explosion.x,explosion.y) end)
end

--@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
--STATIC FUNCTIONS@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
--@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

function Boss:resource_loader()
    local f = "Level/Special Effects/Explosion Yellow/a"
    local lgn = love.graphics.appropriateImage
    self.assets = {
        yellowExplosion = {
            default = {name="default",spriteTable={lgn(f.."1.png"),lgn(f.."2.png"),lgn(f.."3.png"),lgn(f.."4.png")}}
        }
    }
end Boss:resource_loader()

return Boss
