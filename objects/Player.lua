Player = GameObject:extend()

function Player:new(area, x, y, opts)
    Player.super.new(self, area, x, y, opts)
    self.r = 25
    self.width, self.height = 70, 60
    self.collider = self.area.world:newCircleCollider(self.x, self.y, self.r)
    self.collider:setObject(self)
    self.collider:setCollisionClass('Player')
    self.depth = 500

    self.canShoot = true
    self.shootTimer = 0
    self.shootCooldown = 1

    self.angle = -math.pi/2
    self.angleVelocity = 1.66 * math.pi
    self.frontVelocity = 0
    self.sideVelocity = 0
    self.maxVelocity = 200
    self.acceleration = 300

    self.maxStamina = 100
    self.stamina = self.maxStamina
    self.staminaDecrase = 10
    self.maxHP = 30
    self.hp = self.maxHP
    self.hpDecrase = 1
    self.minPower = 10
    self.maxPower = 20
    self.power = self.minPower

    self:setAttack('Neutral')

    --self.timer:every(0.25, function() local ang = random(self.angle + 5*math.pi/6, self.angle + 7*math.pi/6) 
    --   self.area:AddGameObject('PlayerParticle', self.x + 1.5 * self.r * math.cos(ang), self.y + 1.5 * self.r * math.sin(ang), {r = ang}) 
    --end)

    --self.timer:every(0.01, function()
        --self.area:AddGameObject('TrailParticle', self.x - self.width/2 * math.cos(self.angle), self.y - self.width/2 * math.sin(self.angle), {parent = self, r = random(6, 8), d = random(0.15, 0.25)})
    --end)

    self.polygons = {}

    self.polygons[1] = {
        self.width/2, 0,
        -self.width/7, self.height/2,
        -self.width/2, self.height/4,
        -7*self.width/20, 0,
        -self.width/2, -self.height/4,
        -self.width/7, -self.height/2,
    }

    self.polygons[2] = {
        self.width/70, self.height/4,
        -3*self.width/10, self.height/4,
        -self.width/6, 0,
        -3*self.width/10, -self.height/4,
         self.width/70, -self.height/4,
        -5*self.width/42, 0,
    }

    self.polygonColors = {{255, 255, 255, 255}, {255, 255, 255, 255}}
end

function Player:update(dt)
    Player.super.update(self, dt)

    --Handling Input
    self.angle = math.atan2(select(2, love.mouse.getPosition( )) - self.y, select(1, love.mouse.getPosition( )) - self.x)

    if input:down('up') then self.frontVelocity = math.min(self.frontVelocity + self.acceleration * dt, self.maxVelocity)
    elseif input:down('down') then self.frontVelocity = math.max(self.frontVelocity - self.acceleration * dt, -self.maxVelocity)
    else self.frontVelocity = math.sign(self.frontVelocity) * math.max(math.abs(self.frontVelocity) - self.acceleration * dt, 0) end

    if input:down('right') then self.sideVelocity = math.min(self.sideVelocity + self.acceleration * dt, self.maxVelocity)
    elseif input:down('left') then self.sideVelocity = math.max(self.sideVelocity - self.acceleration * dt, -self.maxVelocity)
    else self.sideVelocity = math.sign(self.sideVelocity) * math.max(math.abs(self.sideVelocity) - self.acceleration * dt, 0) end

    if input:down('lclick') and self.canShoot then 
        self:shoot()
        self.canShoot = false
        self.shootTimer = 0
    end

    --Checks
    self.shootTimer = self.shootTimer + dt
    if self.shootTimer > self.shootCooldown then self.canShoot = true end
    if math.abs(self.frontVelocity) > 0.01 or math.abs(self.sideVelocity) > 0.01 then 
        self.area:AddGameObject('TrailParticle', self.x - self.width/2 * math.cos(self.angle + math.pi/36) + random(0, 2), self.y - self.width/2 * math.sin(self.angle + math.pi/36) + random(0, 2), {parent = self, r = random(10, 15), d = random(0.15, 0.25), initialColor = highlight_color, finalColor = pink_color})
        self.area:AddGameObject('TrailParticle', self.x - self.width/2 * math.cos(self.angle - math.pi/36) + random(0, 2), self.y - self.width/2 * math.sin(self.angle - math.pi/36) + random(0, 2), {parent = self, r = random(10, 15), d = random(0.15, 0.25), initialColor = highlight_color, finalColor = pink_color})
    end

    --Stats
    self.stamina = math.min(self.stamina + self.staminaDecrase * dt, self.maxStamina)
    self.hp = math.min(self.hp + self.hpDecrase * dt, self.maxHP)
    self.power = self.minPower + (self.maxPower - self.minPower) * self.hp/self.maxHP
    
    self.collider:setLinearVelocity(self.frontVelocity * math.cos(self.angle) - self.sideVelocity * math.sin(self.angle), self.frontVelocity * math.sin(self.angle) + self.sideVelocity * math.cos(self.angle))
end

function Player:draw()
    love.graphics.setLineWidth(default_lineWidth)
    pushRotate(self.x, self.y, self.angle)
    for i, polygon in ipairs(self.polygons) do
        local points = fn.map(polygon, function(k, v) 
        	if k % 2 == 1 then 
          		return self.x + v + random(-0.7, 0.7) 
        	else 
          		return self.y + v + random(-0.7, 0.7) 
        	end 
        end)
        love.graphics.setColor(default_color)
        love.graphics.polygon('line', points)
    end
    love.graphics.pop()

    --Debug
    --love.graphics.line(self.x, self.y, self.x + 2 * self.r * math.cos(self.angle), self.y + 2 * self.r * math.sin(self.angle))
    --love.graphics.line(self.x, self.y, self.x + 2 * self.r * math.cos((self.angle + 5*math.pi/6)), self.y + 2 * self.r * math.sin((self.angle + 5 *math.pi/6)))
    --love.graphics.line(self.x, self.y, self.x + 2 * self.r * math.cos((self.angle + 7*math.pi/6)), self.y + 2 * self.r * math.sin((self.angle + 7* math.pi/6)))
end

function Player:die()
    self.dead = true
    for i = 1, love.math.random(5, 8) do
        self.area:AddGameObject('DeathParticle', self.x, self.y, {initialColor = default_color, finalColor = pink_color, s = random(10, 15), d = random(0.5, 0.7)})
    end
end

function Player:destroy()
    Player.super.destroy(self)
end

function Player:shoot()
    effectPos = function(obj)
        return obj.x + 1.1 * obj.width/2 * math.cos(obj.angle), obj.y + 1.1 * obj.width/2 * math.sin(obj.angle)
    end

    self.area:AddGameObject('ShootEffect', select(1, effectPos(self)), select(2, effectPos(self)), {parent = self, getPos = effectPos})

    self.area:AddGameObject('Projectile', self.x + 1.5 * self.width/2 * math.cos(self.angle), self.y + 1.5 * self.width/2* math.sin(self.angle), {r = self.angle})
end

function Player:setAttack(attack)
    self.attack = attack
    self.shootCooldown = attacks[attack].cooldown
end