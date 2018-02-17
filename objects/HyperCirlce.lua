HyperCircle = Circle:extend()

function HyperCircle:new(xPos, yPos, Radius, outerRadius, lineWidth)
    self.super:new(xPos, yPos, Radius)
    self.outerRadius = outerRadius
    self.lineWidth = lineWidth
end

function HyperCircle:update(dt)

end

function HyperCircle:draw()
    self.super:draw()
    love.graphics.setLineWidth(self.lineWidth)
    love.graphics.circle("line", self.x, self.y, self.outerRadius)
end