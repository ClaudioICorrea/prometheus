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
    d = ((x1 - x2)^2 + (y1 - y2)^2)^(0.5)
    return d
end

function projet_in_wall(object,wall)
    C=doti(object.x-wall.x_0,object.y-wall.y_0,wall.x_f -wall.x_0,wall.y_f-wall.y_0)/(norm(wall.x_f-wall.x_0,wall.y_f-wall.y_0)^2)
    --C = doti(object.x-wall.x_0,object.y-wall.y_0,wall.x_f -wall.x_0,wall.y_f-wall.y_0)/norm(wall.x_f-wall.x_0,wall.y_f-wall.y_0)
    xx = C*(wall.x_f-wall.x_0) + wall.x_0
    yy = C*(wall.y_f-wall.y_0) + wall.y_0
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

