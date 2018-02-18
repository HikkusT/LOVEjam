Projectile = GameObject:extend()

function Projectile:new(area, x, y, opts)
    Projectile.super.new(self, area, x, y, opts)

    self.size = opts.size or 2.5
    self.velocity = opts.vel or 350

    self.collider = self.area.world:newCircleCollider(self.x, self.y, self.size)
    self.collider:setObject(self)
    self.collider:setLinearVelocity(self.velocity * math.cos(self.r), self.velocity * math.sin(self.r))
end

function Projectile:update(dt)
    Projectile.super.update(self, dt)

    self.collider:setLinearVelocity(self.velocity * math.cos(self.r), self.velocity * math.sin(self.r))
end

function Projectile:draw()
    love.graphics.setColor(self.defaultColor)
    love.graphics.circle('line', self.x, self.y, self.size)
end