Object = require("lukeclassic")

function square_draw(mode, x, y, w, h)
    ww = w / 2
    hh = h / 2
    love.graphics.rectangle(mode, x - ww, y - hh, w, h)
end

function doti(x1,y1,x2,y2) --producto interno en R2
    d = x1*x2+y1*y2 
    return d
end
function norm(x,y) --norma inducoda por doti 
    d = doti(x,y,x,y)^(0.5)
    return d
end

function dist(x1, y1, x2, y2) -- distancia entre 2 elementos 
    d = norm(x1 - x2,y1 - y2)
    return d
end

function trunc(num, digits)
    local mult = 10^(digits)
    return math.modf(num*mult)/mult
end

function ortho_project(x1,y2,x2,y2)
    C = doti(x1,y1,x2,y2)/(norm(x2,y2)^2)
    x = C*x2
    y = C*y2
    return{x,y}
end 

function project_in_wall(object,wall)
    x1 = object.x - wall.x_0
    y1 = object.y - wall.y_0
    x2 = wall.x_f - wall.x_0
    y2 = wall.y_f - wall.y_0
    proj = ortho_project(x1,y1,x2,y2)
    xx = proj[1] + wall.x_0
    yy = proj[2] + wall.y_0
    return {xx,yy}
end 


function _helper(object, values_table)
    for index=1,#values_table,2  do
        property = values_table[index]
        value = values_table[index + 1]
        for property_name,property_value in pairs(object) do
            if property_name == property then
                object[property_name] = value
            end
        end
    end
    return object
end

