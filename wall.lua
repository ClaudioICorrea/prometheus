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
    if self.typ == 1 then
        love.graphics.setColor(0, 0, 1) -- pared
    elseif self.typ == 2  then
        love.graphics.setColor(0, 1, 0)
    elseif self.typ == 3  then
        love.graphics.setColor(1, 0, 0)
    end
    love.graphics.line(self.x_0,self.y_0,self.x_f,self.y_f)
    love.graphics.setColor(360, 360, 360)
end

function Wall:_wall_collider(walker, dt)
    if (self:on_wall(walker)) then
        signed_distance = self.normal[1] * walker.x + self.normal[2] * walker.y - self.plane_constant
        sign = _sign(signed_distance)
        signed_distance = signed_distance - sign * walker.radius
        next_distance = signed_distance +  (self.normal[1] * walker.direction_x + self.normal[2] * walker.direction_y ) *dt *walker.velocity
        if (_sign(next_distance) ~= sign and (norm(walker.direction_x,walker.direction_y)>0)) then
            walker.direction_x = walker.direction_x - next_distance * self.normal[1] / (walker.velocity *dt)
            walker.direction_y = walker.direction_y - next_distance * self.normal[2] / (walker.velocity *dt)
        end

    else

        corner_collider(self.x_0, self.y_0, walker, dt)
        corner_collider(self.x_f, self.y_f, walker, dt)
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
    return (xx <= math.max(self.x_0,self.x_f) and xx >= math.min(self.x_0,self.x_f)) and (yy <= math.max(self.y_0,self.y_f) and yy >= math.min(self.y_0,self.y_f))
end

