Object = require "lukeclassic"
require "tools"

Projectile = Object:extend()

function Projectile:new(x, y, dir_x, dir_y, velocity, range)
    self.range = range or 10
    self.x = x or 0
    self.y = y or 0
    self.origin_x = x or 0
    self.origin_y = y or 0
    self.direction_x = dir_x or 1
    self.direction_y = dir_y or 1
    self.velocity = velocity or 10
    self.life = 100
end

function Projectile:move()
    self.x = self.x + self.direction_x*self.velocity
    self.y = self.y + self.direction_y*self.velocity
    self.life = self.life - 1
end

function Projectile.insert_projectile(enemy, bullets)
    ratio = enemy.ratio
    ratio_max = enemy.max_ratio
    if ratio == ratio_max then
        enemy.ratio = 0
        table.insert(bullets, enemy:shoot())
    end
end

function Projectile:kill_projectile(bullets, i)
    d = dist(self.origin_x,self.origin_y,self.x,self.y)
    if (self.life == 0) or (d > self.range) then
        table.remove(bullets, i)
    end
end


function Projectile:draw()
    love.graphics.circle("line", self.x, self.y, 10)
end
