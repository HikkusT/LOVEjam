Projectile = GameObject:extend()

function Projectile:new(area, x, y, opts)
    Projectile.super.new(self, area, x, y, opts)

    self.size = opts.size or 2.5
    self.width = opts.size or 6
    self.length = opts.length or 45
    self.velocity = opts.vel or 1300
    self.color = {222, 222, 222}

    self.collider = self.area.world:newCircleCollider(self.x, self.y, self.size)
    self.collider:setObject(self)
    self.collider:setLinearVelocity(self.velocity * math.cos(self.r), self.velocity * math.sin(self.r))

    self.timer:tween(0.3, self, {velocity = self.velocity * 2, width = self.width/1.5, length = self.length * 1.5, color = {254, 73, 170}}, 'in-quad', function() self.dead = true end)
end

function Projectile:update(dt)
    Projectile.super.update(self, dt)

    self.collider:setLinearVelocity(self.velocity * math.cos(self.r), self.velocity * math.sin(self.r))
end

function Projectile:draw()
    love.graphics.setColor(self.color)
    pushRotate(self.x, self.y, self.r)
    love.graphics.setLineWidth(self.width)
    love.graphics.line(self.x - self.length/2, self.y, self.x + self.length/2, self.y)
    love.graphics.pop()
end

function Projectile:destroy()
    Projectile.super.destroy(self)
end