TrailParticle = GameObject:extend()

function TrailParticle:new(area, x, y, opts)
    TrailParticle.super.new(self, area, x, y, opts)
    self.depth = 100
    self.color = opts.initialColor or {255, 255, 255}
    self.color = clone(self.color)

    self.r = opts.r or random(10, 15)
    self.timer:tween(opts.d or random(0.3, 0.5), self, {r = 0, color = opts.finalColor}, 'linear', 
    function() self.dead = true end)
end

function TrailParticle:update(dt)
    TrailParticle.super.update(self, dt)
end

function TrailParticle:draw()
    love.graphics.setColor(self.color)
    love.graphics.rectangle('fill', self.x - self.r/2, self.y - self.r/2, self.r, self.r)
end

function TrailParticle:destroy()
    TrailParticle.super.destroy(self)
end