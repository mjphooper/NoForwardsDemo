local function load()
    local path = "Backgrounds/Background1/"
    return {
        layer1 = love.graphics.appropriateImage(path.."layer-1.png"),
        layer2 = love.graphics.appropriateImage(path.."layer-2.png"),
        layer3 = love.graphics.appropriateImage(path.."layer-3.png"),
        layer4 = love.graphics.appropriateImage(path.."layer-4.png"),
        layer5 = love.graphics.appropriateImage(path.."layer-5.png"),
        layer6 = love.graphics.appropriateImage(path.."layer-6.png")
    }
end return load()
