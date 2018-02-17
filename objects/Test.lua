Test = Object:extend()

function Test:new()
    rect_1 = {x = gw/2, y = gh/2, w = 50, h = 200}
    rect_2 = {x = gw/2, y = gh/2, w = 200, h = 50}
    timer:tween(1, rect_1, { w = 0}, 'out-quad')
    timer:after(0.5, function() timer:tween(.5, rect_1, { h = 550}, 'in-cubic') end)
    timer:after(0, function() timer:tween(1, rect_2, { h = 0}, 'out-quad') 
        timer:after(0.5, function() timer:tween(.5, rect_2, { w = 550}, 'in-cubic') end)
    end)
end

function Test:update(dt)

end

function Test:draw()
    love.graphics.rectangle('fill', rect_1.x - rect_1.w/2, rect_1.y - rect_1.h/2, rect_1.w, rect_1.h)
    love.graphics.rectangle('fill', rect_2.x - rect_2.w/2, rect_2.y - rect_2.h/2, rect_2.w, rect_2.h)
end