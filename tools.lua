Object = require("lukeclassic")
-- MATHS
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

function _sign(x)
    return x>=0 and 1 or x<0 and -1
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

function dist_to_wall(object,wall)
    dist_wall= project_in_wall(object,wall)
    d= dist(object.x,object.y,dist_wall[1],dist_wall[2])
    return d
end 
function ball_collider(x_0, y_0, ball_radius, walker, dt)
    next_pos_x = walker.x + dt * walker.velocity * walker.direction_x
    next_pos_y = walker.y + dt * walker.velocity * walker.direction_y
    next_distance = dist(x_0,y_0, next_pos_x ,next_pos_y )
    if(next_distance < walker.radius + ball_radius) then
        amount = walker.radius + ball_radius - next_distance
        normal_x =  next_pos_x - x_0
        normal_y = next_pos_y - y_0
        n = norm(normal_x,normal_y)
        normal_x = normal_x / n
        normal_y = normal_y / n
        walker.direction_x = walker.direction_x + amount * normal_x / (walker.velocity *dt)
        walker.direction_y = walker.direction_y + amount * normal_y / (walker.velocity *dt)
    end
end

function corner_collider(x_0,y_0,walker,dt)
    next_pos_x = walker.x + dt * walker.velocity * walker.direction_x
    next_pos_y = walker.y + dt * walker.velocity * walker.direction_y
    next_distance = dist(x_0,y_0, next_pos_x ,next_pos_y )
    if(next_distance < walker.radius) then
        amount = walker.radius - next_distance
        normal_x =  next_pos_x - x_0
        normal_y = next_pos_y - y_0
        n = norm(normal_x,normal_y)
        normal_x = normal_x / n
        normal_y = normal_y / n
        walker.direction_x = walker.direction_x + amount * normal_x / (walker.velocity *dt)
        walker.direction_y = walker.direction_y + amount * normal_y / (walker.velocity *dt)
    end
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


--OTHER--

function split (inputstr, sep)
    if sep == nil then
            sep = "%s"
    end
    local t={}
    for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
            table.insert(t, str)
    end
    return t
end

function read_luke(path)
    firts_line =true
    
    file = io.input(path,'r')
    tabla = {}
    for line in file:lines() do
        str ={}
        r = {}
        if not firts_line then
                str = split (line, " ")
                for i,num in pairs(str) do
                    table.insert(r,tonumber(num))
                end     
            table.insert(tabla,r)
        end
        firts_line =false
    end
        io.close()
    return tabla
end

function show_tabla(tabla)
    for i,line in pairs(tabla) do
        str = ""
        for j,elent in  pairs(line) do 
            str = str .." ".. tostring(line[j])
        end
        print(str)
    end
end

function keypressed(key,prop)

    if love.keyboard.isDown(key) then
        KeyChecks[key] = true
    end
    if not love.keyboard.isDown(key) and KeyChecks[key] then
        prop =not prop
        KeyChecks[key]=false
    end
    return prop
end

function mousepressed(key,prop)

    if love.mouse.isDown(key) then
        KeyChecks[key] = true
    end
    if not love.mouse.isDown(key) and KeyChecks[key] then
        prop =not prop
        KeyChecks[key]=false
    end
    return prop
end

function select(key,x,y,element_select,element_all)
    luke =false
    if not love.mouse.isDown(key) then 
        x_i =x
        y_i =y
    end 
    if love.mouse.isDown(key) then
        KeyChecks[key] = true
        x_f = x
        y_f = y
    end
    if not love.mouse.isDown(key) and KeyChecks[key] then
        KeyChecks[key]=false
        x_f = x
        y_f = y
        luke = true
    end
    if love.mouse.isDown(key) then
        love.graphics.setColor(0, 1, 0)
        love.graphics.polygon("line",x_i,y_i,x_f,y_i,x_f,y_f,x_i,y_f)
    end
    if luke then
        for i,element_table in pairs(element_all) do  
            if x_i <= element_table.x and element_table.x <= x_f and y_i <= element_table.y  and  element_table.y <= y_f  then
                table.inster(element_table,element_select)
            end
        end
    end
    for i,element_ in pairs(element_select) do  
        square_draw("line", element_.x, element_.y, 20, 20)
    end    
    --end 
    return element_select 
end 

---  for i,element_table in pairs(table_all) do  
--if x_i < element_table.x < x_f and y_i < element_table.y < y_f then
---    table.inster(element_select,element_table)
--end 
--end