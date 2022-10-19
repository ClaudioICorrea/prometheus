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
    player1 = Player(750, 600, 50, 50, 5, 5)-- jugador
    load_menu() -- menu
    --escenario--
    wall_word = {}
    table.insert(wall_word, _helper(Wall(),{"x_0", 50, "y_0", 50, "x_f", 700, "y_f", 180}))
    table.insert(wall_word, _helper(Wall(),{"x_0", 0, "y_0", 0, "x_f", 0, "y_f", 700}))
    table.insert(wall_word, _helper(Wall(),{"x_0", 0, "y_0", 0, "x_f", 700, "y_f", 0 }))
    table.insert(wall_word, _helper(Wall(),{"x_0", 10, "y_0", 300, "x_f", 700, "y_f", 0 }))
    table.insert(wall_word, _helper(Wall(),{"x_0", 10, "y_0", 700, "x_f", 800, "y_f", 0 }))
    --table.insert(wall_word, _helper(Wall(),{"x_0", 10, "y_0", 10, "x_f", 700, "y_f", 200 }))
    --enemigos y npc--
    enemies_mele = {}
    enemies_range = {}
    --table.insert(enemies_range, _helper(Enemy:_new_ranger(),{"x", 500, "y", 20, "velocity_shoot", 10, "max_ratio", 1, "range", 100}))
    --table.insert(enemies_range, _helper(Enemy:_new_ranger(),{"x", 500, "y", 100, "velocity_shoot", 10, "max_ratio", 40,  "range", 300}))
    --table.insert(enemies_mele, Enemy(250,0))
    --table.insert(enemies_mele, Enemy(350,0))
end

function love.update()
    --movimientos del jugador--
    player1:_move()
    player1:_input_player()

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
        
        --love.graphics.line(50, 50, 700, 180)
    elseif game.state["menu"] then
        draw_menu()        
    end
end
