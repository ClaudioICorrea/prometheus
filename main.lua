--variables globales
Object = require "lukeclassic"
local button = require "Buttons"
require "enemies"
require "projectiles"
require "Utilities"
require "Buttons2"

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

botoncito = Button("HOLA", function(param) love.mouse.setX( param) end, 500, 200,50,30,30)

-- Menu --
local game = {
    state = {
        menu = true,
        paused = false,
        running = false,
        ended = false
    }
}




local buttons = {
    menu_states = {}
}


--Other Fuctions--

local function StartGame()
game.state["menu"]= false
game.state["running"] = true
end
---hola  luke


function love.mousepressed(x, y, button, is_touch, presses)
    if not game.state['running'] then
        if button == 1 then
            if game.state["menu"] then
                botoncito:_check_click()
                for index in  pairs(buttons.menu_states) do
                    buttons.menu_states[index]:checkPressed(x, y , 1)
                end
            end
        end
    end
end
--Other Methods--hola apu
-- enemy --
function enemy:move_to(location_x,location_y)
    direction ={(location_x-self.x) / norm(self.x-location_x,self.y-location_y), (location_y-self.y) / norm(self.x-location_x,self.y-location_y)}
    self.x = self.x + direction[1] * self.velocity
    self.y = self.y + direction[2] * self.velocity
end

--cargar
function love.load()
    --jugador---
    player1 = player(750, 600, 50, 50, 5, 5)
    --menu--
    buttons.menu_states.play_game = newButton("Play Game", StartGame , nil, 110, 50)
    buttons.menu_states.setting = newButton("Setting", nil, nil, 110, 50)
    buttons.menu_states.exit_game = newButton("Exit Game", love.event.quit, nil, 110, 50)
    buttons.menu_states.restart_game = newButton("Re-start", nil, nil, 110, 50)
    --escenario--
    --enemigos y npc--
    enemies_mele = {}
    enemies_range = {}
    table.insert(enemies_range,enemy:newRanger(500,20,nil,nil,nil,nil,10,1))
    table.insert(enemies_range,enemy:newRanger(500,100,nil,nil,nil,nil,10,40))
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
            if (bullet.life == 0) then
                table.remove(bullets, i)
            end
        end
    end
end
--dibujar
function love.draw()
    botoncito:draw()
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
        buttons.menu_states.play_game:draw(screen_width / 2 - 55, screen_height / 7 * 1, 20, 20)
        buttons.menu_states.setting:draw(screen_width / 2 - 55, screen_height / 7 * 2, 20, 20)
        buttons.menu_states.exit_game:draw(screen_width / 2 - 55, screen_height / 7 * 3, 20, 20)
        buttons.menu_states.restart_game:draw(screen_width / 2 - 55, screen_height / 7 * 4, 20, 20)
    end
end
