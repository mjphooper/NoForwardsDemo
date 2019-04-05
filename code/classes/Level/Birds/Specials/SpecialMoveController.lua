local SpecialMoveController = Class("SpecialMoveController")

function SpecialMoveController:initialize(bird)
    --References
    self.bird = bird

    --List of the actual special moves.
    self.moves = {
        self.classes.moves.Burst,
        self.classes.moves.Laser
    }

    --Varaibles related to speicalmove management
    self.reset(self)
    self.slowSpeed = 0.05

    --Trash table. Table of trashed bubble objects. Used to animate the bubbles, even when the speical move has totally ended.
    self.trashTable = {}

end

function SpecialMoveController:reset()
    self.polling = true --searching for a special move event?
    self.specialMove = false
    self.quickTimeEvent = false
    self.runningMove = false
end

function SpecialMoveController:isActive()
    return not self.polling
end
--PICK WHAT STAGE THE SPECIAL IS IN---------------------------------------------
--------------------------------------------------------------------------------

function SpecialMoveController:pickStage() --Will either return quicktimer for updating, or the actual move for updating.
    if not self.polling then
        self.bird.level.functions:setTime(self.slowSpeed)
        if self.quickTimeEvent.completed then
            self.runningMove = true
            self.bird.level.functions:resetTime()
            return self.specialMove
        else
            return self.quickTimeEvent
        end
    end
end

--UPDATE FUNCTIONS-------------------------------------------------------------
-------------------------------------------------------------------------------

--Iterate through the list of moves, and check if key event is pressed for each.
function SpecialMoveController:pollForEvent()
    if self.polling then
        fold(self.moves,function(move)
            if keyboard.keyDown == move:getKeyStart() then
                self.polling = false
                self.specialMove = move:new(self.bird)
                self.quickTimeEvent = self.classes.Quicktimer:new(self.bird,self.specialMove)
            end
        end)
    end
end


function SpecialMoveController:update()
    --Poll for the special events.
    self.pollForEvent(self)

    --Update the main event, if polling is not taking place.
    if not self.polling then
        self.pickStage(self):update()
    end

    --Update the trash table
    fold(self.trashTable,function(bubble) bubble:trashUpdate() end)

end

 --DRAW FUNCTIONS---------------------------------------------------------------
 -------------------------------------------------------------------------------


function SpecialMoveController:draw()
    --Draw the main event, if polling is not taking place.
    if not self.polling then
        self.pickStage(self):draw()
    end

    --Draw the trash table
    fold(self.trashTable,function(bubble) bubble:draw() end)
end

--@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
--STATIC FUNCTIONS@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
--@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

function SpecialMoveController:requirement_loader()
    self.classes = {
        Quicktimer = require "code.classes.Level.Birds.Specials.Quicktimer",
        moves = {
            Burst = require "code.classes.Level.Birds.Specials.Moves.Burst",
            Laser = require "code.classes.Level.Birds.Specials.Moves.Laser"
        }
    }
end SpecialMoveController:requirement_loader()

return SpecialMoveController
