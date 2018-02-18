HourglassParticle = GameObject:extend()

function HourglassParticle:new(area, x, y, opts)
    HourglassParticle.super.new(self, area, x, y, opts)

    self.r = opts.r or 0
    self.length = opts.length or 50
    self.duration = 0.1

    self.timer:tween(self.duration, self, {length = 0}, 'out-cubic', function() self.dead = true end)
end

function HourglassParticle:update(dt)
    HourglassParticle.super.update(self, dt)
end

function HourglassParticle:draw()
    pushRotate(self.x, self.y, self.r)
    love.graphics.setLineWidth(2)
    love.graphics.line(self.x - self.length/2, self.y, self.x + self.length/2, self.y)
    love.graphics.pop()
end