function square_draw(mode, x, y, w, h)
    ww = w / 2
    hh = h / 2
    love.graphics.rectangle(mode, x - ww, y - hh, w, h)
end

function dist(x1, y1, x2, y2)
    d = ((x1 - x2)^2 + (y1 - y2)^2)^(0.5)
    return d
end

function norm(x,y)
    d = (x^2 + y^2)^(0.5)
    return d
end

function object_helper(object, property, value)

    for property_name,property_value in pairs(object) do
        if property_name == property then
            object[property_name] = value
        end
    end


end

