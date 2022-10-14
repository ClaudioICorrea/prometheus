--variables globales
Object = require "lukeclassic"
require "enemies"
require "projectiles"
require "buttons"
require "tools"
require "player"


bullets ={}
screen_width = love.graphics.getWidth() --ancho de la ventana
screen_height = love.graphics.getHeight() --alto de la ventana


-- Menu --
game = {
    state = {
        menu = true,
        paused = false,
        running = false,
        ended = false
    }
}


function love.mousepressed(x, y, pressed_button, is_touch, presses)
    if not game.state['running'] then
        if pressed_button == 1 then
            if game.state["menu"] then
                for i,button in ipairs(buttons) do
                    button:_check_click()
                end
            end
        end
    end
end

--cargar
function love.load()
    --jugador---
    player1 = Player(750, 600, 50, 50, 5, 5)
    --menu--
    buttons ={}
    table.insert(buttons,Button("Play Game",
            function()
                game.state["menu"]= false
                game.state["running"] = true
            end
    , nil, 110, 50,screen_width / 2 - 55, screen_height / 7 ))
    table.insert(buttons,Button("Settings", nil, nil, 110, 50,screen_width / 2 - 55, 2 * screen_height / 7 ))
    table.insert(buttons,Button("Exit Game",
            function(event_status)
                love.event.quit(event_status )
            end
    , 0, 110, 50,screen_width / 2 - 55, 3 * screen_height / 7 ))
    table.insert(buttons,Button("Re-Start", nil, nil, 110, 50,screen_width / 2 - 55, 4 * screen_height / 7 ))
    --escenario--
    --enemigos y npc--
    enemies_mele = {}
    enemies_range = {}
    table.insert(enemies_range, _helper(Enemy:_new_ranger(),{"x", 500, "y", 20, "velocity_shoot", 10, "max_ratio", 1, "range", 100}))
    table.insert(enemies_range, _helper(Enemy:_new_ranger(),{"x", 500, "y", 100, "velocity_shoot", 10, "max_ratio", 40,  "range", 300}))
    table.insert(enemies_mele, Enemy(250,0))
    table.insert(enemies_mele, Enemy(350,0))
end

function love.update()
    --movimientos del jugador--
    player1:_move()

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
    elseif game.state["menu"] then
        love.graphics.print("MENU", screen_width / 2 - 25, 10)
        for i,button in ipairs(buttons) do
            button:draw()
        end
    end
end
