local function load()
    local sheet_image = love.graphics.appropriateImage("Birds/FriendlyPlayers/Red Dragon/RedDragon.png")

    currentSheetSize = {x=sheet_image:getWidth(),y=sheet_image:getHeight()}


    return { image = love.graphics.appropriateImage("Birds/FriendlyPlayers/Red Dragon/RedDragon.png"),
        idle = {name="default",spriteTable={lgq(24,1,347,348),lgq(424,-34,347,348),lgq(825,-34,347,348),lgq(1225,-44,347,348),
                                          lgq(1626,-62,347,348),lgq(2026,-47,347,348),lgq(2427,-34,347,348),lgq(2827,-34,347,348)}}
    }
end return load()
