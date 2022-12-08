--variables globales
Object = require "lukeclassic"
require "enemies"
require "projectiles"
require "tools"
require "player"
require "wall"
require "menu"
require "physics"


bullets ={}
screen_width = love.graphics.getWidth() --ancho de la ventana
screen_height = love.graphics.getHeight() --alto de la ventana
KeyChecks = {}


-- Estados de Juego --
game = {
    state = {
        menu = true,
        paused = false,
        running = false,
        ended = false
    }
}

function love.load()
    
    conn = read_luke('conn_nivel_test.txt')
    node = read_luke('node_nivel_test.txt')


    info_game = false
    player1 = Player(700, 400, 50, 50, 100, 5)-- jugador
    load_menu() -- menu
    --escenario--
    wall_word = {}
    door_word = {}
    window_word = {}

    for i,con in pairs(conn) do
        if con[3] == 2 then
            table.insert(door_word, Wall:_door(node[con[1]][1], node[con[1]][2], node[con[2]][1], node[con[2]][2],con[3]))
        elseif con[3] == 3 then
            table.insert(window_word, Wall( node[con[1]][1], node[con[1]][2], node[con[2]][1], node[con[2]][2],con[3]))
        else
            table.insert(wall_word, Wall( node[con[1]][1], node[con[1]][2], node[con[2]][1], node[con[2]][2],con[3]))
        end
    end
    --enemigos y npc--
    enemies_mele = {}
    enemies_range = {}
    --table.insert(enemies_range, _helper(Enemy:_new_ranger(),{"x", 500, "y", 20, "velocity_shoot", 10, "max_ratio", 1, "range", 100}))
    --table.insert(enemies_range, _helper(Enemy:_new_ranger(),{"x", 500, "y", 100, "velocity_shoot", 10, "max_ratio", 40,  "range", 300}))
    table.insert(enemies_mele, Enemy(250,100))
    table.insert(enemies_mele, Enemy(350,100))
end

function love.update(dt)
    --movimientos del jugador--
    player1:_input_player()
    for i,wall in pairs(wall_word) do
        wall:_wall_collider(player1, dt)
    end
    for i,door in pairs(door_word) do
        door:_toc_toc_door(player1,30)
        if  not door.open then
            door:_wall_collider(player1, dt)
        end
    end
    for i,window in pairs(window_word) do
        window:_wall_collider(player1, dt)
    end
    --ball_collider(screen_width/2,screen_height/2,30,player1,dt)
    player1:_move(dt)


    --movimientos del los enemigos--
    if game.state["running"] then
        for i,enemy_mele in pairs(enemies_mele) do
            if dist(player1.x, player1.y, enemy_mele.x, enemy_mele.y) < enemy_mele.vision then
                enemy_mele.target_x = player1.x
                enemy_mele.target_y = player1.y
                enemy_mele:_direction(enemy_mele.target_x, enemy_mele.target_y)
            end
            for j,wall in pairs(wall_word) do
                wall:_wall_collider(enemy_mele, dt)
            end
            for j,door in pairs(door_word) do
                door:_wall_collider(enemy_mele, dt)
            end
            for j,window in pairs(window_word) do
                window:_wall_collider(enemy_mele, dt)
            end
            enemy_mele:_move_to(dt)
        end
        for i,enemy_range in pairs(enemies_range) do
            enemy_range.ratio = math.min(enemy_range.ratio + 1, enemy_range.max_ratio)
            if dist(player1.x, player1.y, enemy_range.x, enemy_range.y) < enemy_range.vision then
                enemy_range.target_x = player1.x
                enemy_range.target_y = player1.y
                enemy_range:_move_to(enemy_range.target_x, enemy_range.target_y)
                Projectile._insert_projectile(enemy_range, bullets, enemy_range:_shoot())
            end
        end
        for i,bullet in pairs(bullets) do
            bullet:_move()
            bullet:_kill_projectile(bullets, i)
        end
    end
    --experimento
    
end
--dibujar
function love.draw()
    --love.graphics.circle("line",screen_width/2,screen_height/2,30)
    if game.state["running"] then
        -- Dibujar Jugador 1 --
        player1:draw()
        -- Dibujar Enemigos
        love.graphics.setColor(360, 360, 360)
        for i,enemy_mele in pairs(enemies_mele) do
            enemy_mele:draw()
        end
        for i,enemy in pairs(enemies_range) do
            enemy:draw()
        end
        for i,bullet in ipairs(bullets) do
            bullet:draw()
        end
        --Dibujar escenario (experimento)
        for i,wall in pairs(wall_word) do
            wall:draw()
            ejem=project_in_wall(player1,wall)
            ejem_x =ejem[1]
            ejem_y =ejem[2]
            love.graphics.circle("fill",ejem_x, ejem_y, 1)
        end
        for i,door in pairs(door_word) do
            door:draw()
            ejem=project_in_wall(player1,door)
            ejem_x =ejem[1]
            ejem_y =ejem[2]
            love.graphics.circle("fill",ejem_x, ejem_y, 1)
        end
        for i,window in pairs(window_word) do
            window:draw()
            ejem=project_in_wall(player1,window)
            ejem_x =ejem[1]
            ejem_y =ejem[2]
            love.graphics.circle("fill",ejem_x, ejem_y, 1)
        end

        --experimento 
        if info_game then
            love.graphics.print("velocidad_x =" .. tostring(trunc(player1.velocity*player1.direction_x,3)) , 0 , 400 )
            love.graphics.print("velocidad_y = " .. tostring(trunc(player1.velocity*player1.direction_y,3)), 0 , 410 )
            love.graphics.print("direccion = (" .. tostring(trunc(player1.direction_x,3)) .. "," .. tostring(trunc(player1.direction_y,3)) .. ")", 0 , 420 )
            love.graphics.print("(x,y) = " .. "(" .. tostring(trunc(player1.x,3)) .. "," .. tostring(trunc(player1.y,3)).. ")", 0 , 430 )
            love.graphics.print("velocidad = " .. tostring(trunc(player1.velocity,3))  , 0 , 440 )
            love.graphics.print("screen_width = " .. tostring(screen_width), 0 , 450 )
            love.graphics.print("screen_height = " .. tostring(screen_height), 0 , 460 )
            --love.graphics.print("distance_to_door = " .. tostring(distance_to_door), 0 , 470 )
        end
        --love.graphics.line(50, 50, 700, 180)
    elseif game.state["menu"] then
        draw_menu()        
    end
end
