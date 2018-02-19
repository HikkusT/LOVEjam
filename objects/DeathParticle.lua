DeathParticle = GameObject:extend()

function DeathParticle:new(area, x, y, opts)
    DeathParticle.super.new(self, area, x, y, opts)

    self.color = opts.initialColor or default_color
    self.finalColor = opts.finalColor or pink_color
    self.color = clone(self.color)
    self.finalColor = clone(self.finalColor)
    self.r = random(0, 2*math.pi)
    self.s = opts.s or random(8, 12)
    self.v = opts.v or random(75, 150)
    self.timer:tween(opts.d or random(0.5, 0.7), self, {s = 0, v = 0, color = self.finalColor}, 
    'out-cubic', function() self.dead = true end)
end

function DeathParticle:update(dt)
    DeathParticle.super.update(self, dt)

    self.x = self.x + self.v * math.cos(self.r) * dt
    self.y = self.y + self.v * math.sin(self.r) * dt
end

function DeathParticle:draw()
    pushRotate(self.x, self.y, self.r)
    love.graphics.setColor(self.color)
    love.graphics.rectangle('fill', self.x - self.s/2, self.y - self.s/2, self.s, self.s)
    love.graphics.setColor(255, 255, 255)
    love.graphics.setLineWidth(1)
    love.graphics.pop()
end

function DeathParticle:destroy()
    DeathParticle.super.destroy(self)
end