Object = require "lukeclassic"
require "tools"

Enemy = Object:extend()


function Enemy:new(x, y, target_x, target_y, velocity, vision)
    self.vision = vision or 300
    self.radius = radius or 10
    self.velocity = velocity or 10
    self.x = x or 0
    self.y = y or 0
    self.target_x = target_x or 0
    self.target_y = target_y or 0
    self.direction_x = 0
    self.direction_y = 0
    self.is_ranger = false
    self.coefficient = 1
end

function Enemy:_direction(location_x, location_y)
    direction ={(location_x - self.x ) / norm(self.x - location_x, self.y - location_y), (location_y - self.y) / norm(self.x - location_x, self.y - location_y)}
    self.direction_x = direction[1]
    self.direction_y = direction[2]
end

function Enemy:_move_to(dt)
    self.x = self.x + self.direction_x*self.velocity* dt * self.coefficient
    self.y = self.y + self.direction_y*self.velocity* dt * self.coefficient
end

function Enemy:_shoot()
    d = ((self.target_x - self.x)^2 + (self.target_y - self.y)^2)^(0.5)
    x = (self.target_x - self.x) / d
    y = (self.target_y - self.y) / d
    bullet = Projectile(self.x, self.y, x, y, self.velocity_shoot,self.range)
    return bullet
end

function Enemy:draw()
    if self.is_ranger then
        love.graphics.polygon("line", self.x - 10, self.y + 10, self.x + 10, self.y + 10, self.x, self.y - 10)
    else
        square_draw("line", self.x, self.y, 20, 20)
    end
end

function Enemy:_new_ranger(x, y, target_x, target_y, velocity, vision, velocity_shoot, ratio, range)
    ranger = Enemy(x, y, target_x, target_y, velocity, vision)
    ranger.range = range or 10
    ranger.ratio = ratio or 0
    ranger.max_ratio= ranger.ratio
    ranger.velocity_shoot = velocity_shoot or 5
    ranger.is_ranger = true
    return ranger
end
