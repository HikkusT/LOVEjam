Player = GameObject:extend()

function Player:new(area, x, y, opts)
    Player.super:new(area, x, y, opts)

    self.angle = -math.pi/2
    self.angleVelocity = 1.66 * math.pi
    self.velocity = 0
    self.maxVelocity = 100
    self.acceleration = 100
end

function Player:update(dt)
    Player.super:update(dt)

    if input:down('left') then self.angle = self.angle - self.angleVelocity * dt end
    if input:down('right') then self.angle = self.angle + self.angleVelocity * dt end

    if input:down('up') then self.velocity = math.min(self.velocity + self.acceleration * dt, self.maxVelocity)
    else self.velocity = math.max(self.velocity - self.acceleration * dt, 0) end
end

function Player:draw()
    love.graphics.circle('line', self.x, self.y, 40)
end