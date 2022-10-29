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
    
    conn = read_luke('conn.txt')
    node = read_luke('node.txt')


    info_game = false
    player1 = Player(750, 600, 50, 50, 100, 5)-- jugador
    load_menu() -- menu
    --escenario--
    wall_word = {}

    for i,con in pairs(conn) do
        table.insert(wall_word, Wall( node[con[1]][1], node[con[1]][2], node[con[2]][1], node[con[2]][2]))
    end
    --table.insert(wall_word, Wall( 50, 50, 700, 180))
    --table.insert(wall_word, Wall(0,0,0,700))
    --table.insert(wall_word, Wall(0, 0, 700, 0))
    --table.insert(wall_word, Wall(100, 300, 700, 0))
    --table.insert(wall_word, Wall(10, 700, 800, 0))
    --table.insert(wall_word, _helper(Wall(),{"x_0", 10, "y_0", 10, "x_f", 700, "y_f", 200 }))
    --enemigos y npc--
    enemies_mele = {}
    enemies_range = {}
    --table.insert(enemies_range, _helper(Enemy:_new_ranger(),{"x", 500, "y", 20, "velocity_shoot", 10, "max_ratio", 1, "range", 100}))
    --table.insert(enemies_range, _helper(Enemy:_new_ranger(),{"x", 500, "y", 100, "velocity_shoot", 10, "max_ratio", 40,  "range", 300}))
    --table.insert(enemies_mele, Enemy(250,0))
    --table.insert(enemies_mele, Enemy(350,0))
end

function love.update(dt)
    --movimientos del jugador--
    player1:_input_player()
    for i,wall in pairs(wall_word) do
        wall:_wall_collider(player1, dt)
    end
    --ball_collider(screen_width/2,screen_height/2,30,player1,dt)
    player1:_move(dt)


    --movimientos del los enemigos--
    if game.state["running"] then
        for i,enemy_mele in pairs(enemies_mele) do
            if dist(player1.x, player1.y, enemy_mele.x, enemy_mele.y) < enemy_mele.vision then
                enemy_mele.target_x = player1.x
                enemy_mele.target_y = player1.y
                enemy_mele:_move_to(enemy_mele.target_x, enemy_mele.target_y)
            end
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
            love.graphics.circle("fill",ejem_x, ejem_y, 10)
        end
        --experimento 
        if info_game then
            love.graphics.print("velocidad_x =" .. tostring(trunc(player1.velocity*player1.direction_x,3)) , 0 , 400 )
            love.graphics.print("velocidad_y = " .. tostring(trunc(player1.velocity*player1.direction_y,3)), 0 , 410 )
            love.graphics.print("direccion = (" .. tostring(trunc(player1.direction_x,3)) .. "," .. tostring(trunc(player1.direction_y,3)) .. ")", 0 , 420 )
            love.graphics.print("(x,y) = " .. "(" .. tostring(trunc(player1.x,3)) .. "," .. tostring(trunc(player1.y,3)).. ")", 0 , 430 )
            love.graphics.print("velocidad = " .. tostring(trunc(player1.velocity,3))  , 0 , 440 )
            love.graphics.print("dist_to_wall = " .. tostring(dist_to_wall), 0 , 450 )
        end
        --love.graphics.line(50, 50, 700, 180)
    elseif game.state["menu"] then
        draw_menu()        
    end
end
