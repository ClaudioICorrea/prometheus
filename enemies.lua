Object = require "lukeclassic"
require "Utilities"

enemy = Object:extend()


function enemy:new(x,y,target_x,target_y,velocity,vision)
    self.vision = vision or 300
    self.velocity = velocity or 2
    self.x = x or 0
    self.y = y or 0
    self.target_x = target_x or 0
    self.target_y = target_y or 0
    self.isRanger = false
end

function enemy:move_to(location_x,location_y)
    direction ={(location_x-self.x )/norm(self.x-location_x,self.y-location_y),(location_y-self.y)/norm(self.x-location_x,self.y-location_y)}
    self.x = self.x + direction[1]*self.velocity
    self.y = self.y + direction[2]*self.velocity
end

function enemy:shoot()
    d = ((self.target_x-self.x)^2 + (self.target_y-self.y)^2)^(0.5)
    x=(self.target_x-self.x)/d
    y=(self.target_y-self.y)/d
    bullet = Projectile(self.x,self.y,x,y)
    return bullet
end

function enemy:draw()
    if self.isRanger then
        love.graphics.polygon("line", self.x-10 , self.y+10 ,self.x +10, self.y + 10 ,self.x, self.y - 10)
    else
        square_draw("line", self.x , self.y ,20,20)
    end
end

function enemy:newRanger(x,y,target_x,target_y,velocity,vision)
    ranger = enemy(x,y,target_x,target_y,velocity,vision)
    ranger.isRanger = true
    return ranger
end