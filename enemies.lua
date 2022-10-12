Object = require "lukeclassic"
require "tools"

enemy = Object:extend()


function enemy:new(x, y, target_x, target_y, velocity, vision)
    self.vision = vision or 300
    self.velocity = velocity or 2
    self.x = x or 0
    self.y = y or 0
    self.target_x = target_x or 0
    self.target_y = target_y or 0
    self.is_ranger = false
end

function enemy:move_to(location_x, location_y)
    direction ={(location_x - self.x ) / norm(self.x - location_x, self.y - location_y), (location_y - self.y) / norm(self.x - location_x, self.y - location_y)}
    self.x = self.x + direction[1]*self.velocity
    self.y = self.y + direction[2]*self.velocity
end

function enemy:shoot()
    d = ((self.target_x - self.x)^2 + (self.target_y - self.y)^2)^(0.5)
    x = (self.target_x - self.x) / d
    y = (self.target_y - self.y) / d
    bullet = Projectile(self.x, self.y, x, y, self.velocity_shoot,self.range)
    return bullet
end

function enemy:draw()
    if self.is_ranger then
        love.graphics.polygon("line", self.x - 10, self.y + 10, self.x + 10, self.y + 10, self.x, self.y - 10)
    else
        square_draw("line", self.x, self.y, 20, 20)
    end
end

function enemy:newRanger(x, y, target_x, target_y, velocity, vision, velocity_shoot, ratio, range)
    ranger = enemy(x, y, target_x, target_y, velocity, vision)
    ranger.range = range or 10
    ranger.ratio = 0
    ranger.max_ratio= ratio or 12
    ranger.velocity_shoot = velocity_shoot or 5
    ranger.is_ranger = true
    return ranger
end
