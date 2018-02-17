Area = Object:extend()

function Area:new(room)
    self.room = room
    self.gameObjects = {}
end

function Area:update(dt)
    for i = #self.gameObjects, 1, -1 do
        local gameObject = self.gameObjects[i]
        gameObject:update(dt)
        if gameObject.dead then table.remove(self.gameObjects, i)  print('oi') end
    end
end

function Area:draw()
    for _, gameObject in ipairs(self.gameObjects) do gameObject:draw() end
end

function Area:AddGameObject(gameObjectType, x, y, opts)
    local opts = opts or {}
    local gameObject = _G[gameObjectType](self, x or 0, y or 0, opts)
    table.insert(self.gameObjects, gameObject)
    return gameObject
end