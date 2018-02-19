Projectile = GameObject:extend()

function Projectile:new(area, x, y, opts)
    Projectile.super.new(self, area, x, y, opts)

    self.size = opts.size or 2.5
    self.width = opts.size or 6
    self.length = opts.length or 45
    self.velocity = opts.vel or 1300
    self.color = highlight_color
    self.color = clone(self.color)

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
    for i = 1, love.math.random(5, 8) do
        self.area:AddGameObject('DeathParticle', self.x, self.y, {initialColor = pink_color, finalColor = default_color, s = random(10, 15), d = random(0.5, 0.7)})
    end
    Projectile.super.destroy(self)
end