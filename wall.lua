require "tools"
Object = require "lukeclassic"
Wall = Object:extend()

function Wall:new(x_0, y_0, x_f, y_f, typ)
    self.x_0 = x_0 or 0
    self.y_0 = y_0 or 0
    self.x_f = x_f or 1
    self.y_f = y_f or 1
    self.typ= typ or 1
end

function Wall:draw()
    love.graphics.line(self.x_0,self.y_0,self.x_f,self.y_f)
end