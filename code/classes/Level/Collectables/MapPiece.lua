--INHERITANCE REQUIREMENTS------------------------------------------------------
local Collectable = require "code.classes.Level.Collectables.Collectable"
--------------------------------------------------------------------------------

local MapPiece = Class("MapPiece",Collectable)
function MapPiece:initialize(map,player,x,y)
    Collectable.initialize(self,map,player,x,y,w,h)
end

function MapPiece:pickUp()
    self.player.level.mapsCollected = self.player.level.mapsCollected + 1
end

function MapPiece:update()
    self.collectable_update(self)

end

function MapPiece:draw(xOffset)
    love.graphics.draw(self.assets.mapPiece,self.x-xOffset,self.y)
    self.collectable_draw(self)
end



--@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
--STATIC FUNCTIONS@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
--@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

function MapPiece:populateMap(map)
    local piecesNumber = love.math.random(1,2)
    for i = 1,piecesNumber,1 do --for every segment
        local x = love.math.random(map.mapSize_pixels/10,map.mapSize_pixels-(map.mapSize_pixels/10))
        local y = love.math.random(150,map.floorLevel-300)
        local pieceAdd = MapPiece:new(map,map.level.player,x,y)
        table.insert(map.objects,pieceAdd)
    end
end

function MapPiece:load_resources()
    self.assets = {
        mapPiece = love.graphics.appropriateImage("Level/Map/Collectables/map-piece.png")
    }
end MapPiece:load_resources()

return MapPiece
