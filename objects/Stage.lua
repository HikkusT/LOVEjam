Stage = Object:extend()

function Stage:new()
    self.area = Area(self)
    self.area:AddPhysicsWorld()
    self.mainCanvas = love.graphics.newCanvas(gw, gh)

    self.hourglass = self.area:AddGameObject('Hourglass', gw/2, gh/2)
    self.player = self.area:AddGameObject('Player', gw/2, gh/2)
    self.score = 0
    self.font = font
    input:bind('f3', function() self.player:die() end)
end

function Stage:update(dt)
    camera.smoother = camera.smooth.damped(5)
    camera:lockPosition(dt, gw/2, gh/2)

    self.area:update(dt)
end

function Stage:draw()
    love.graphics.setCanvas(self.mainCanvas)
    love.graphics.clear()
        camera:attach(0, 0, gw, gh)
        self.area:draw()
        --HP
        local hp, maxHP, ghostFast, ghostSlow = self.player.hp, self.player.maxHP, self.player.ghostHPfast, self.player.ghostHPslow
        love.graphics.setColor(dark_gray)
        love.graphics.rectangle('line', gw/2 - 80, 30, 160, 30)
        love.graphics.rectangle('fill', gw/2 - 80, 30, 160 * ghostSlow/maxHP, 30)
        love.graphics.setColor(light_gray)
        love.graphics.rectangle('fill', gw/2 - 80, 30, 160 * ghostFast/maxHP, 30)

        love.graphics.setColor(default_color)
        love.graphics.print(self.score, gw - 20, 10, 0, 1, 1,
    	math.floor(self.font:getWidth(self.score)/2), self.font:getHeight(self.score)/2)
        love.graphics.setColor(255, 255, 255)
        camera:detach()
    love.graphics.setCanvas()

    love.graphics.setColor(255, 255, 255, 255)
    love.graphics.setBlendMode('alpha', 'premultiplied')
    love.graphics.draw(self.mainCanvas, 0, 0, 0, sx, sy)
    love.graphics.setBlendMode('alpha')
end