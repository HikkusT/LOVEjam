Template = GameObject:extend()

function Template:new(area, x, y, opts)
    Template.super.new(self, area, x, y, opts)
end

function Template:update(dt)
    Template.super.update(self, dt)
end

function Template:draw()

end

function Template:destroy()
    Template.super.destroy(self)
end