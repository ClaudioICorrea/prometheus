Object = require "lukeclassic"

Projectile = Object:extend()

function Projectile:new(x,y,dir_x,dir_y,velocity)
    self.x = x or 0
    self.y = y or 0
    self.direction_x = dir_x or 1
    self.direction_y = dir_y or 1
    self.velocity = velocity or 10
end

function Projectile:move()
    self.x = self.x + self.direction_x*self.velocity
    self.y = self.y + self.direction_y*self.velocity
end

function Projectile:insert_projetile(ratio,enemy_range,bullets)
    if ratio <= 5 then
        ratio = ratio -1
            if ratio == 0 then
                table.insert(bullets,enemy_range)
                ratio = 5
            end
        end

end

function Projectile:draw()
    love.graphics.circle("line",self.x, self.y, 10)
end

