ShootEffect = GameObject:extend()

function ShootEffect:new(area, x, y, opts)
    ShootEffect.super.new(self, area, x, y, opts)
    self.depth = 75

    self.parent = opts.parent
    self.funcPos = opts.getPos

    self.w = opts.w or 13
    self.defaultColor = {255, 255, 255, 255}

    self.timer:tween(opts.duration or 0.1, self, {w = 0}, 'in-out-cubic', function() self.dead = true end)
end

function ShootEffect:update(dt)
    ShootEffect.super.update(self, dt)
    if self.parent then
        self.x, self.y = self.funcPos(self.parent)
    end
end

function ShootEffect:draw()
    pushRotate(self.x, self.y, self.parent.r + math.pi/4)
    love.graphics.setColor(self.defaultColor)
    love.graphics.rectangle('fill', self.x - self.w/2, self.y - self.w/2, self.w, self.w)
    love.graphics.pop()
end

function ShootEffect:destroy()
    ShootEffect.super.destroy(self)
end