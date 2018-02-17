Player = GameObject:extend()

function Player:new(area, x, y, opts)
    Player.super:new(area, x, y, opts)
    self.r = 25
    self.collider = self.area.world:newCircleCollider(self.x, self.y, self.r)
    self.collider:setObject(self)

    self.angle = -math.pi/2
    self.angleVelocity = 1.66 * math.pi
    self.velocity = 0
    self.maxVelocity = 100
    self.acceleration = 100
end

function Player:update(dt)
    Player.super.update(self, dt)

    if input:down('left') then self.angle = self.angle - self.angleVelocity * dt end
    if input:down('right') then self.angle = self.angle + self.angleVelocity * dt end

    if input:down('up') then self.velocity = math.min(self.velocity + self.acceleration * dt, self.maxVelocity)
    else self.velocity = math.max(self.velocity - self.acceleration * dt, 0) end
    --self.velocity = math.min(self.velocity + self.acceleration * dt, self.maxVelocity)
    
    self.collider:setLinearVelocity(self.velocity * math.cos(self.angle), self.velocity * math.sin(self.angle))
end

function Player:draw()
    love.graphics.circle('line', self.x, self.y, self.r)
    love.graphics.line(self.x, self.y, self.x + 2 * self.r * math.cos(self.angle), self.y + 2 * self.r * math.sin(self.angle))
end