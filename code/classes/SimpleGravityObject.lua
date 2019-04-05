SimpleGravityObject = Class("SimpleGravityObject")

    function SimpleGravityObject:initialize(mass,x,y)
        self.mass = mass
        self.x = x
        self.y = y
        self.resets = {mass=mass,x=x,y=y}

        self.pull = (self.mass * gravity) / 125
        self.airResistanceFactor = 0.95

        self.speed = 0;
        self.horizontalSpeed = 0

        self.normalSpeed = false
    end

    function SimpleGravityObject:reset()
        self.speed = 0
        self.horizontalSpeed = 0
        self.x,self.y = self.resets.x,self.resets.y
    end

    function SimpleGravityObject:applyForces()
        --Gravity
        self.speed = time:deltaInc(self.speed,self.pull)
        self.y = time:deltaInc(self.y,self.speed*100)
        --Sideways
        if self.horizontalSpeed ~= 0 then
            self.x = time:deltaInc(self.x,self.horizontalSpeed*100)
            self.horizontalSpeed = self.horizontalSpeed * self.airResistanceFactor
        end
    end

    function SimpleGravityObject:applyLeftForce(forceAmount)
        self.horizontalSpeed = time:deltaInc(self.horizontalSpeed,-forceAmount,self.normalSpeed)
    end

    function SimpleGravityObject:applyRightForce(forceAmount)
        self.horizontalSpeed = time:deltaInc(self.horizontalSpeed,forceAmount,self.normalSpeed)
    end

    function SimpleGravityObject:applyDownwardForce(forceAmount)
        self.speed = time:deltaInc(self.speed,forceAmount,self.normalSpeed)
    end
