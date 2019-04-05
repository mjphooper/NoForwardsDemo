PlayerData = Class("PlayerData")

--[[
    This class basically exsits to hold all data about the player and their progression throughout the game.
    It communicates between the hub and the level.
    Should be no functional methods, other than data formatting.
]]

function PlayerData:initialize()
    --Initialize variables.
    self.vars_experience(self)
    self.vars_party(self)


end

--DATA EXTRACT METHODS----------------------------------------------------------
--Just to tidy things up really.
--------------------------------------------------------------------------------

function PlayerData:vars_experience()
    self.xp  = 0
    self.level = 1
    self.nextLevelXP = self.xp + 1
end

function PlayerData:vars_party()
    --[[
        self.allyData = {
        {id="player1", count=3},
        {id="player2", count=8},
        {id="player3", count=4}
    }
    --]]
    self.party = {} --Of the form above.
    self.unhatchedParty = {} --of form above- using classes maybe.
end






--@STATIC BOI
function PlayerData:init()
    self.test = "lels"
end
