Player = GameObject:extend()

function Player:new(area, x, y, opts)
    Player.super.new(self, area, x, y, opts)
    self.r = 25
    self.collider = self.area.world:newCircleCollider(self.x, self.y, self.r)
    self.collider:setObject(self)
    self.collider:setCollisionClass('Player')

    self.angle = -math.pi/2
    self.angleVelocity = 1.66 * math.pi
    self.frontVelocity = 0
    self.sideVelocity = 0
    self.maxVelocity = 200
    self.acceleration = 300

    self.timer:every(0.25, function() local ang = random(self.angle + 5*math.pi/6, self.angle + 7*math.pi/6) 
        self.area:AddGameObject('PlayerParticle', self.x + 1.5 * self.r * math.cos(ang), self.y + 1.5 * self.r * math.sin(ang), {r = ang}) 
    end)
end

function Player:update(dt)
    Player.super.update(self, dt)

    --Handling Input
    self.angle = math.atan2(select(2, love.mouse.getPosition( )) - self.y, select(1, love.mouse.getPosition( )) - self.x)
    --if input:down('left') then self.angle = self.angle - self.angleVelocity * dt end
    --if input:down('right') then self.angle = self.angle + self.angleVelocity * dt end
    if input:down('up') then self.frontVelocity = math.min(self.frontVelocity + self.acceleration * dt, self.maxVelocity)
    elseif input:down('down') then self.frontVelocity = math.max(self.frontVelocity - self.acceleration * dt, -self.maxVelocity)
    else self.frontVelocity = math.sign(self.frontVelocity) * math.max(math.abs(self.frontVelocity) - self.acceleration * dt, 0) end

    if input:down('right') then self.sideVelocity = math.min(self.sideVelocity + self.acceleration * dt, self.maxVelocity)
    elseif input:down('left') then self.sideVelocity = math.max(self.sideVelocity - self.acceleration * dt, -self.maxVelocity)
    else self.sideVelocity = math.sign(self.sideVelocity) * math.max(math.abs(self.sideVelocity) - self.acceleration * dt, 0) end

    if input:down('lclick') then self:shoot() end
    
    self.collider:setLinearVelocity(self.sideVelocity, -self.frontVelocity)
end

function Player:draw()
    love.graphics.circle('line', self.x, self.y, self.r)

    --Debug
    --love.graphics.line(self.x, self.y, self.x + 2 * self.r * math.cos(self.angle), self.y + 2 * self.r * math.sin(self.angle))
    --love.graphics.line(self.x, self.y, self.x + 2 * self.r * math.cos((self.angle + 5*math.pi/6)), self.y + 2 * self.r * math.sin((self.angle + 5 *math.pi/6)))
    --love.graphics.line(self.x, self.y, self.x + 2 * self.r * math.cos((self.angle + 7*math.pi/6)), self.y + 2 * self.r * math.sin((self.angle + 7* math.pi/6)))
end

function Player:shoot()
    effectPos = function(obj)
        return obj.x + 1.1 * obj.r * math.cos(obj.angle), obj.y + 1.1 * obj.r * math.sin(obj.angle)
    end

    self.area:AddGameObject('ShootEffect', select(1, effectPos(self)), select(2, effectPos(self)), {parent = self, getPos = effectPos})

    self.area:AddGameObject('Projectile', self.x + 1.5 * self.r * math.cos(self.angle), self.y + 1.5 * self.r * math.sin(self.angle), {r = self.angle})
end