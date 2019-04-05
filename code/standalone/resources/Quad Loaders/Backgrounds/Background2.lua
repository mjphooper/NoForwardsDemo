local function load()
    local path = "Backgrounds/Background2/"
    return {
        layer1 = love.graphics.appropriateImage(path.."layer-1.png"),
        layer2 = love.graphics.appropriateImage(path.."layer-2.png"),
        layer3 = love.graphics.appropriateImage(path.."layer-3.png"),
    }
end return load()
