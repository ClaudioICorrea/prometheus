--variables globales
Object = require "lukeclassic"
require "enemies"
require "projectiles"
<<<<<<< HEAD
require "Utilities"
require "Buttons"
=======
require "Tools"
>>>>>>> 1b19500ed0408db47345cd96aa53aec5540f04c9
player = Object:extend()
bullets ={}
screen_width = love.graphics.getWidth() --ancho de la ventana
screen_height = love.graphics.getHeight() --alto de la ventana
--CLASES---
--Clase jugador--
function player:new(x, y, target_x, target_y, velocity, click_right, click_left, radius)
    self.radius = radius or 30
    self.velocity = velocity or 0
    self.x = x or 0
    self.y = y or 0
    self.target_x = target_x or 0
    self.target_y = target_y or 0
    self.click_right = click_right or false
    self.click_left = click_left or false
end



-- Menu --
game = {
    state = {
        menu = true,
        paused = false,
        running = false,
        ended = false
    }
}

--Other Fuctions--

<<<<<<< HEAD
=======


local function StartGame()
game.state["menu"]= false
game.state["running"] = true
end
---hola  luke
>>>>>>> 1b19500ed0408db47345cd96aa53aec5540f04c9


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
    player1 = player(750, 600, 50, 50, 5, 5)
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
    table.insert(enemies_range,enemy:newRanger(500,20,nil,nil,nil,nil,10,1,100))
    table.insert(enemies_range,enemy:newRanger(500,100,nil,nil,nil,nil,10,40,300))
    table.insert(enemies_mele,enemy(250,0))
    table.insert(enemies_mele,enemy(350,0))
end

function love.update()
    --movimientos del jugador--
    if game.state["running"] then
        if love.keyboard.isDown("w") then
            player1.y = player1.y - 1 * player1.velocity
        end
        if love.keyboard.isDown("s") then
            player1.y = player1.y + 1 * player1.velocity
        end
        if love.keyboard.isDown("a") then
            player1.x = player1.x - 1 * player1.velocity
        end
        if love.keyboard.isDown("d") then
            player1.x = player1.x + 1 * player1.velocity
        end
        if love.keyboard.isDown("m") then
            game.state["menu"]= true
            game.state["running"] = false
        end
    end
    player1.target_x = love.mouse.getX() -- ubicacion del mouse en x
    player1.target_y = love.mouse.getY() -- ubicacion del mouse en y
    player1.click_right = love.mouse.isDown(1)
    player1.click_left = love.mouse.isDown(2)

    --movimientos del los enemigos--
    if game.state["running"] then
        for i,enemy_mele in pairs(enemies_mele) do
            if dist(player1.x, player1.y, enemy_mele.x, enemy_mele.y) < enemy_mele.vision then
                enemy_mele.target_x = player1.x
                enemy_mele.target_y = player1.y
                enemy_mele:move_to(enemy_mele.target_x, enemy_mele.target_y)
            end
        end
        for i,enemy_range in pairs(enemies_range) do
            enemy_range.ratio = math.min(enemy_range.ratio + 1, enemy_range.max_ratio)
            if dist(player1.x, player1.y, enemy_range.x, enemy_range.y) < enemy_range.vision then
                enemy_range.target_x = player1.x
                enemy_range.target_y = player1.y
                enemy_range:move_to(enemy_range.target_x, enemy_range.target_y)
                Projectile.insert_projectile(enemy_range, bullets, enemy_range:shoot())
            end
        end
        for i,bullet in pairs(bullets) do
            bullet:move()
            bullet:kill_projectile(bullets, i)
        end
    end
end
--dibujar
function love.draw()

    if game.state["running"] then
    -- Dibujar Jugador 1 --
        love.graphics.setColor(360, 360, 360) --dibujar en el color indicado
        square_draw("fill", player1.x, player1.y, 20, 20)
        love.graphics.setColor(360, 360, 360) --dibujar en el color indicado
        if player1.click_right then
            love.graphics.setColor(1, 0, 0)
        end
        if player1.click_left then
            love.graphics.setColor(0, 1, 0)
        end
        love.graphics.circle("line", player1.target_x, player1.target_y, 10) --dibuja un circulo
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
