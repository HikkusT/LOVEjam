Circle = Object:extend()

function Circle:new(xPos, yPos, Radius)
    self.x = xPos
    self.y = yPos
    self.radius = Radius
    self.creation_time = love.timer.getTime()
end

function Circle:update(dt)

end

function Circle:draw()
    love.graphics.circle("fill", self.x, self.y, self.radius)
end