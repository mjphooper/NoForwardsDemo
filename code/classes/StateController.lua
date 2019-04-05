StateController = Class("StateController")

function StateController:initialize(initialState)
    self.state = initialState
    self.stateobject = {}
    self.createInitialState(self)
end

function StateController:createInitialState()
    if self.state == "hub" then self.regenerateHub(self)
    else self.generateLevel(self)
    end
end

--GENERATION FUNCTIONS----------------------------------------------------------
 -------------------------------------------------------------------------------

function StateController:generateLevel()
    self.stateObject = self.classes.Level:new()
    self.state = "level"
end

function StateController:regenerateHub()
    self.stateObject = self.classes.Hub:new()
end

function StateController:poll()
    if keyboard.keyDown == "l" and self.state ~= "level" then
        self.generateLevel(self)
    end
end

 --UPDATE FUNCTIONS-------------------------------------------------------------
 -------------------------------------------------------------------------------

function StateController:update(dt)
    self.poll(self)
    self.stateObject:update(dt)
end

 --DRAW FUNCTIONS---------------------------------------------------------------
 -------------------------------------------------------------------------------

function StateController:draw()
    self.stateObject:draw()
end

--@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
--STATIC FUNCTIONS@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
--@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

function StateController:requirement_loader()
    self.classes = {
        Level = require "code.classes.Level.Level",
        Hub = require "code.classes.Hub.Hub"
    }
end StateController:requirement_loader()
