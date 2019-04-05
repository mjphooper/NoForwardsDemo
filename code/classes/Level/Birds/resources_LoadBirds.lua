local loadedBirds = {}

--SHOULD ONLY BE 1 RESOURCE LOADER PER FOLDER.

local function load_birds()
    local lgn = love.graphics.appropriateImage

--THE PLAYER DRAGON-------------------------------------------------------------
--------------------------------------------------------------------------------
    f = "Birds/FriendlyPlayers/Red Dragon/"
    local image = lgn(f.."RedDragon.png")
    currentSheetSize.x, currentSheetSize.y = image:getDimensions()
    loadedBirds.redDragon = { image = image,
        idle = {name="default",spriteTable={lgq(24,1,347,348),lgq(424,-34,347,348),lgq(825,-34,347,348),lgq(1225,-44,347,348),
                              lgq(1626,-62,347,348),lgq(2026,-47,347,348),lgq(2427,-34,347,348),lgq(2827,-34,347,348)}}
    }

--THE FRIENDLY BIRDS------------------------------------------------------------
--------------------------------------------------------------------------------
    loadedBirds.friendlyPlayers = {}

    f = "Birds/FriendlyPlayers/Player 1/Default/"
    loadedBirds.friendlyPlayers.player1 = {
        idle = {name="default",spriteTable={lgn(f.."a1.png"),lgn(f.."a2.png"),lgn(f.."a3.png"),lgn(f.."a4.png"),
                                               lgn(f.."a5.png"),lgn(f.."a6.png"),lgn(f.."a7.png"),lgn(f.."a8.png")}},
        mini = lgn("Birds/FriendlyPlayers/Player 1/Mini/mini.png"),

    }

    f = "Birds/FriendlyPlayers/Player 2/Default/"
    loadedBirds.friendlyPlayers.player2 = {
        idle = {name="default",spriteTable={lgn(f.."a1.png"),lgn(f.."a2.png"),lgn(f.."a3.png"),lgn(f.."a4.png"),
                                               lgn(f.."a5.png"),lgn(f.."a6.png"),lgn(f.."a7.png"),lgn(f.."a8.png")}},
        mini = lgn("Birds/FriendlyPlayers/Player 2/Mini/mini.png"),

    }

    f = "Birds/FriendlyPlayers/Player 3/Default/"
    loadedBirds.friendlyPlayers.player3 = {
        idle = {name="default",spriteTable={lgn(f.."a1.png"),lgn(f.."a2.png"),lgn(f.."a3.png"),lgn(f.."a4.png"),
                                               lgn(f.."a5.png"),lgn(f.."a6.png"),lgn(f.."a7.png"),lgn(f.."a8.png")}},
        mini = lgn("Birds/FriendlyPlayers/Player 3/Mini/mini.png"),

    }

    f = "Birds/FriendlyPlayers/Player 4/Default/"
    loadedBirds.friendlyPlayers.player4 = {
        idle = {name="default",spriteTable={lgn(f.."a1.png"),lgn(f.."a2.png"),lgn(f.."a3.png"),lgn(f.."a4.png"),
                                               lgn(f.."a5.png"),lgn(f.."a6.png"),lgn(f.."a7.png"),lgn(f.."a8.png")}}
    }

    f = "Birds/FriendlyPlayers/Player 5/Default/"
    loadedBirds.friendlyPlayers.player5 = {
        idle = {name="default",spriteTable={lgn(f.."a1.png"),lgn(f.."a2.png"),lgn(f.."a3.png"),lgn(f.."a4.png"),
                                               lgn(f.."a5.png"),lgn(f.."a6.png"),lgn(f.."a7.png"),lgn(f.."a8.png")}}
    }

--THE ENEMY BIRDS---------------------------------------------------------------
--------------------------------------------------------------------------------
    loadedBirds.enemyPlayers = {}

    f = "Birds/EnemyPlayers/GreenEnemy/Default/"
    loadedBirds.enemyPlayers.greenEnemy = {
        idle = {name="default",spriteTable={lgn(f.."a1.png"),lgn(f.."a2.png"),lgn(f.."a3.png"),lgn(f.."a4.png"),
                                               lgn(f.."a5.png"),lgn(f.."a6.png"),lgn(f.."a7.png"),lgn(f.."a8.png")}}
    }

--RETURN------------------------------------------------------------------------
--------------------------------------------------------------------------------
    return loadedBirds
end
return load_birds()
