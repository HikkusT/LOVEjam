Area = Object:extend()

function Area:new(room)
    self.room = room
    self.gameObjects = {}
end

function Area:update(dt)
    if self.world then self.world:update(dt) end

    for i = #self.gameObjects, 1, -1 do
        local gameObject = self.gameObjects[i]
        gameObject:update(dt)
        if gameObject.dead then table.remove(self.gameObjects, i) end
    end
end

function Area:draw()
    --if self.world then self.world:draw() end

    for _, gameObject in ipairs(self.gameObjects) do gameObject:draw() end
end

function Area:AddGameObject(gameObjectType, x, y, opts)
    local opts = opts or {}
    local gameObject = _G[gameObjectType](self, x or 0, y or 0, opts)
    table.insert(self.gameObjects, gameObject)
    return gameObject
end

function Area:AddPhysicsWorld()
    self.world = Physics.newWorld(0, 0, true)

    self.world:addCollisionClass('Player')
    self.world:addCollisionClass('Particle', {ignores = {'Player', 'Particle'}})
end