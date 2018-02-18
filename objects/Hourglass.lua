Hourglass = GameObject:extend()

function Hourglass:new(area, x, y, opts)
    Hourglass.super.new(self, area, x, y, opts)

    self.offset = opts.offset or {30, 30}
    self.width = opts.width or 25
    self.height = opts.height or 30
    self.angle = -math.pi/2
    self.hourglassVelocity = opts.hourglassVelocity or 1
    self.hourglassFrequency = opts.hourglassFrequency or 3

    self.x = self.offset[1] + self.width/2
    self.y = self.offset[2] + self.height/2

    self.polygons = {
        self.height/2, self.width/2,
        self.height/4, self.width/2,
        0, 0,
        -self.height/4, self.width/2,
        -self.height/2, self.width/2,
        -self.height/2, -self.width/2,
        -self.height/4, -self.width/2,
        0, 0,
        self.height/4, -self.width/2,
        self.height/2, -self.width/2,
    }

    self.moving = false

    local angle = math.atan2(self.width/2, 3 * self.height/8) 
    local radius = math.sqrt(self.width/2 * self.width/2 + 3 * self.height/8 * 3 * self.height/8)

    CreateHourglassParticle = function()
        if self.moving then
        self.area:AddGameObject('HourglassParticle', self.x + radius * math.cos(self.angle - angle), self.y + radius * math.sin(self.angle - angle), {r = self.angle, length = self.height/4})
        self.area:AddGameObject('HourglassParticle', self.x - radius * math.cos(self.angle - angle), self.y - radius * math.sin(self.angle - angle), {r = self.angle, length = self.height/4})
        end
    end

    --self.timer:every(0.001, CreateHourglassParticle)

    self.timer:every(self.hourglassFrequency, function() self.moving = true self.timer:tween(self.hourglassVelocity, self, {angle = self.angle + math.pi}, 'in-out-back', function() self.moving = false end) end)
end

function Hourglass:update(dt)
    Hourglass.super.update(self, dt)
end

function Hourglass:draw()
    love.graphics.setColor(default_color)
    love.graphics.setLineWidth(3)
    pushRotate(self.x, self.y, self.angle)
    local points = fn.map(self.polygons, function(k, v)
            if k % 2 == 1 then
                return self.x + v
            else
                return self.y + v
            end
        end)
    love.graphics.polygon('line', points)
    love.graphics.pop()
end