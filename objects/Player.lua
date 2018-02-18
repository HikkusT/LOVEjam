Player = GameObject:extend()

function Player:new(area, x, y, opts)
    Player.super.new(self, area, x, y, opts)
    self.r = 25
    self.collider = self.area.world:newCircleCollider(self.x, self.y, self.r)
    self.collider:setObject(self)
    self.collider:setCollisionClass('Player')

    self.angle = -math.pi/2
    self.angleVelocity = 1.66 * math.pi
    self.velocity = 0
    self.maxVelocity = 100
    self.acceleration = 100

    self.timer:every(0.25, function() local ang = random(self.angle + 5*math.pi/6, self.angle + 7*math.pi/6) 
        self.area:AddGameObject('PlayerParticle', self.x + 1.5 * self.r * math.cos(ang), self.y + 1.5 * self.r * math.sin(ang), {r = ang}) 
    end)
end

function Player:update(dt)
    Player.super.update(self, dt)

    if input:down('left') then self.angle = self.angle - self.angleVelocity * dt end
    if input:down('right') then self.angle = self.angle + self.angleVelocity * dt end

    if input:down('up') then self.velocity = math.min(self.velocity + self.acceleration * dt, self.maxVelocity)
    else self.velocity = math.max(self.velocity - self.acceleration * dt, 0) end
    
    self.collider:setLinearVelocity(self.velocity * math.cos(self.angle), self.velocity * math.sin(self.angle))
end

function Player:draw()
    love.graphics.circle('line', self.x, self.y, self.r)

    --Debug
    --love.graphics.line(self.x, self.y, self.x + 2 * self.r * math.cos(self.angle), self.y + 2 * self.r * math.sin(self.angle))
    --love.graphics.line(self.x, self.y, self.x + 2 * self.r * math.cos((self.angle + 5*math.pi/6)), self.y + 2 * self.r * math.sin((self.angle + 5 *math.pi/6)))
    --love.graphics.line(self.x, self.y, self.x + 2 * self.r * math.cos((self.angle + 7*math.pi/6)), self.y + 2 * self.r * math.sin((self.angle + 7* math.pi/6)))
end