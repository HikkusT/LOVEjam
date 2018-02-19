Object = require 'libraries/classic/classic'
Input = require 'libraries/boipushy/Input'
Timer = require 'libraries/EnhancedTimer/EnhancedTimer'
Camera = require 'libraries/hump/camera'
Physics = require 'libraries/windfield/windfield'
fn = require 'libraries/Moses/moses'
require 'globals'
font = love.graphics.newFont('resources/fonts/m5x7.ttf', 32)

function love.load()
    --Lib Setup
    input = Input()
    timer = Timer()
    camera = Camera()
    --input:bind('f3', function() camera:shake(4, 60, 1) end)

    --Inputs
    input:bind('left', 'left')
    input:bind('a', 'left')
    input:bind('right', 'right')
    input:bind('d', 'right')
    input:bind('up', 'up')
    input:bind('w', 'up')
    input:bind('down', 'down')
    input:bind('s', 'down')
    input:bind('mouse1', 'lclick')

    --OOP Setup
    local object_files = {}
    RecursiveEnumerate('objects', object_files)
    RequireFiles(object_files)

    --Room Setup
    rooms = {}
    currentRoom = Stage()

    --Canvas Setup
    love.graphics.setDefaultFilter('nearest')
    love.graphics.setLineStyle('rough')
    love.graphics.setLineWidth(1)
    --resize(2)
end

function resize(s)
    love.window.setMode(s*gw, s*gh) 
    sx, sy = s, s
end

function RecursiveEnumerate(folder, file_list)
    local items = love.filesystem.getDirectoryItems(folder)
    for _, item in ipairs(items) do
        local file = folder .. '/' .. item
        if love.filesystem.isFile(file) then
            table.insert(file_list, file)
        elseif love.filesystem.isDirectory(file) then
            RecursiveEnumerate(file, file_list)
        end
    end
end

function RequireFiles(file_list)
    for _, file in ipairs(file_list) do
        local file = file:sub(1, -5)
        require(file)
    end
end

function love.update(dt)
    timer:update(dt)
    camera:update(dt)

    if currentRoom then currentRoom:update(dt) end
end

function love.draw()
    if currentRoom then currentRoom:draw() end
end

function AddRoom(roomType, roomName)
    local room = _G[roomType](roomName)
    rooms[roomName] = room
    return room
end

function GoToRoom(roomType, roomName)
    if currentRoom and rooms[roomName] then
        if currentRoom.deactivate then currentRoom:deactivate() end
        currentRoom = rooms[roomName]
        if currentRoom.activate then currentRoom:activate() end
    else currentRoom = AddRoom(roomType, roomName) end
end
