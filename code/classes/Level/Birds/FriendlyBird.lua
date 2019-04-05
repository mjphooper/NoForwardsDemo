--INHERITANCE REQUIREMENTS------------------------------------------------------
local IndependentBird = require "code.classes.Level.Birds.IndependentBird"
local BirdObject = require "code.classes.Level.Birds.BirdObject"
--------------------------------------------------------------------------------

local FriendlyBird = Class("FriendlyBird",IndependentBird)

function FriendlyBird:initialize(identity,config,level)
    IndependentBird.initialize(self,Animator:new(BirdObject.assets.friendlyPlayers[identity].idle,2,{paused=false,loop=true}),config,level,{x=0.4,y=0.4})
    --Override inherited data members
    self.identity = identity
    self.opponents = {birds = self.level.enemyBirds,
                      projectiles = self.level.enemyProjectiles
                     }

    self.projectileTable = self.level.friendlyProjectiles
    self.ventureRange.min = 0
    self.ventureRange.max = (lg.getWidth()/self.level.scale.x)*(1-self.ventureDistance)
    self.movementPoint = self.generatePoint(self)

    --Give a weapon
    self.weapon = self.classes.BulletShooter:new(self,9000)

    --Death action
    local deaths = {"Fall","Explode","Rise"}
    self.deathAction = self.classes.deaths[deaths[love.math.random(1,#deaths)]]:new(self)
end

--GENERATION FUNCTION-----------------------------------------------------------
--------------------------------------------------------------------------------
function FriendlyBird:generateNew(identity,level,x,y) --@STATIC

    local lims = {xmin=50,xmax=300,ymin=50,ymax=50}
    --Create the object
    local rx,ry = love.math.random(lims.xmin,lims.xmax), love.math.random(lims.ymin,lims.ymax)
    local birdToAdd = FriendlyBird:new(identity,{mass=250,x=x or rx,y=y or ry},level)
    table.insert(level.friendlyBirds,birdToAdd)
    --Assign targeting to the object
    birdToAdd:findTargets(birdToAdd.intelligence)
    birdToAdd:notifyOpponents()
    --Open communications for created
    return birdToAdd
end

--DEATH FUNCTIONS---------------------------------------------------------------
--------------------------------------------------------------------------------
function FriendlyBird:pollDeath()
    if self.isDying() then

    end
end

--UPDATE FUNCTION---------------------------------------------------------------
--------------------------------------------------------------------------------
function FriendlyBird:update()

    --Unwavering statics
    BirdObject:collectTrash(self.level.friendlyBirds)
    self.updateAnimation(self)
    --Check to update the death
    if self.deathAction:branch("update") then return end
    --Inherited updates
    self.independentBird_update(self)
end


--DRAW FUNCTION---------------------------------------------------------------
--------------------------------------------------------------------------------

function FriendlyBird:draw()
    self.independentBird_draw(self)
end

--@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
--STATIC FUNCTIONS@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
--@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

function FriendlyBird:requirement_loader()
    self.classes = {
        BirdDeath = require "code.classes.Level.Birds.Die.BirdDeath",
        BulletShooter = require "code.classes.Level.Birds.Weapons and Projectiles.Weapons.BulletShooter",
        deaths = {
            Rise = require "code.classes.Level.Birds.Die.Rise",
            Explode = require "code.classes.Level.Birds.Die.Explode",
            Fall = require "code.classes.Level.Birds.Die.Fall",
            Crash = require "code.classes.Level.Birds.Die.Crash"
        }
    }
end FriendlyBird:requirement_loader()



return FriendlyBird
