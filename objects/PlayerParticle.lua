PlayerParticle = GameObject:extend()

function PlayerParticle:new(area, x, y, opts)
    PlayerParticle.super.new(self, area, x, y, opts)

    self.radius = opts.radius or random(5,10)
    self.v = opts.v or random(20, 40)
    self.r = opts.r
    self.lineColor = {255, 0, 0, 255}
    
    self.collider = self.area.world:newCircleCollider(self.x, self.y, self.radius)
    self.collider:setObject(self)
    self.collider:setCollisionClass('Particle')

    self.timer:tween(opts.d or random(1, 1.4), self, {radius = 0, v = 0, lineColor = {255, 0, 0, 0}}, 'in-cubic', function() self.dead = true end)
end

function PlayerParticle:update(dt)
    PlayerParticle.super.update(self, dt)

    self.collider:setLinearVelocity(self.v*math.cos(self.r), self.v*math.sin(self.r))
    --self.x = self.x + self.v * math.cos(self.r) * dt
    --self.y = self.y + self.v * math.sin(self.r) * dt
end

function PlayerParticle:draw()
    love.graphics.setLineWidth(default_lineWidth)
    love.graphics.setColor(self.lineColor)
    love.graphics.circle('line', self.x, self.y, self.radius)
end

function PlayerParticle:destroy()
    PlayerParticle.super.destroy(self)
end