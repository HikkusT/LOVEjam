Stage = Object:extend()

function Stage:new()
    self.area = Area(self)
    self.area:AddPhysicsWorld()
    self.mainCanvas = love.graphics.newCanvas(gw, gh)

    self.player = self.area:AddGameObject('Player', gw/2, gh/2)
    self.hourglass = self.area:AddGameObject('Hourglass', gw/2, gh/2)
    self.score = 0
    self.font = font
    input:bind('f3', function() self.player:die() end)
end

function Stage:update(dt)
    self.area:update(dt)
end

function Stage:draw()
    love.graphics.setCanvas(self.mainCanvas)
    love.graphics.clear()
        camera:attach(0, 0, gw, gh)
        self.area:draw()
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