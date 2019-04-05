local Background = Class("Background")

function Background:initialize()
    self.backing = self.assets.background1.background
    self.foreground = self.assets.background1.foreground

end


function Background:update()
end

function Background:draw()
    love.graphics.draw(self.backing)
    love.graphics.draw(self.foreground)
end

--@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
--STATIC FUNCTIONS@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
--@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

function Background:resource_loader()
    self.assets = {
        background1 = {foreground = resources.Backgrounds
        .Background1.layer4,
                       background = resources.Backgrounds.Background1.layer6}
    }
end Background:resource_loader()



return Background
