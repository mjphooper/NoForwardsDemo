--REQUIRE ALL THE NECESSARY EXTRA FILES-----------------------------------------
--------------------------------------------------------------------------------
local function req(path)
    return (require("code.standalone.resources.Quad Loaders."..path))
end

--LOAD THE RESOURCE STRUCTRUE FROM THE FILE.
local function resource_structure()
    resources = {
        Backgrounds = {
            Background1 = req("Backgrounds.Background1"),
            Background2 = req("Backgrounds.Background2")
        },
        Birds = {
            EnemyPlayers = {},
            FriendlyPlayers = {
                RedDragon = req("Birds.FriendlyPlayers.RedDragon")
            }
        }
    }



end




return resource_structure
