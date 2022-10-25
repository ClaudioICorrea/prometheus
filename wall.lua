require "tools"
Object = require "lukeclassic"
Wall = Object:extend()

function Wall:new(x_0, y_0, x_f, y_f, typ)
    self.x_0 = x_0 or 0
    self.y_0 = y_0 or 0
    self.x_f = x_f or 1
    self.y_f = y_f or 1
    self.normal ={y_f - y_0, x_0 - x_f}
    n = norm(self.normal[1], self.normal[2])
    self.normal[1] = self.normal[1] / n
    self.normal[2] = self.normal[2] / n
    self.plane_constant = self.normal[1] * x_0 + self.normal[2] * y_0
    self.typ = typ or 1
end

function Wall:draw()
    love.graphics.line(self.x_0,self.y_0,self.x_f,self.y_f)
end

function Wall:_wall_collider(walker, dt)
    dist_to_wall = dist(walker.x,walker.y,self:on_wall(walker)[1],self:on_wall(walker)[2])
    if not (dist_to_wall == 10) then
        if (self:on_wall(walker)[3]) then
            signed_distance = self.normal[1] * walker.x + self.normal[2] * walker.y - self.plane_constant
            sign = _sign(signed_distance)
            signed_distance = signed_distance - sign * walker.radius
            next_distance = signed_distance +  (self.normal[1] * walker.direction_x + self.normal[2] * walker.direction_y ) *dt *walker.velocity * walker.coefficient
            if (_sign(next_distance) ~= sign and (norm(walker.direction_x,walker.direction_y)>0)) then
                coefficient = - signed_distance / ((self.normal[1] * walker.direction_x + self.normal[2] * walker.direction_y ) * walker.velocity * dt)
            
            else
                coefficient = walker.coefficient
            end
        
        else
            coefficient = walker.coefficient
        end
        walker.coefficient = coefficient
    elseif (dist_to_wall == 10) then
        walker.x = 500
        walker.y = 500
    end
end



function Wall:on_wall(object)
    x1 = object.x - self.x_0
    y1 = object.y - self.y_0
    x2 = self.x_f - self.x_0
    y2 = self.y_f - self.y_0
    proj = ortho_project(x1,y1,x2,y2)
    xx = proj[1] + self.x_0
    yy = proj[2] + self.y_0
    return {xx,yy,(xx <= math.max(self.x_0,self.x_f) and xx >= math.min(self.x_0,self.x_f)) and (yy <= math.max(self.y_0,self.y_f) and yy >= math.min(self.y_0,self.y_f))}
end