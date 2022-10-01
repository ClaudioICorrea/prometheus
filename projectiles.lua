Object = require "lukeclassic"

Projectile = Object:extend()

function Projectile:new(x,y,dir_x,dir_y)
    self.x = x or 0
    self.y = y or 0
    self.direction_x = dir_x or 1
    self.direction_y = dir_y or 1
end

function Projectile:move()
    self.x = self.x + self.direction_x
    self.y = self.y + self.direction_y

end

function Projectile:draw()
    love.graphics.circle("line",self.x, self.y, 10)
end