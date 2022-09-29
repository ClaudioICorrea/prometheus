--variables globales
Object = require "lukeclassic"
player = Object:extend()
enemy = Object:extend()
--CLASES---
--Clase jugador
function player:new(x, y, target_x, target_y, velocity, clik_right, click_left)
    self.velocity = velocity or 0
    self.x = x or 0
    self.y = y or 0
    self.target_x = target_x or 0
    self.target_y = target_y or 0
    self.clik_right = clik_right or false
    self.clik_left = click_left or false 
end
--Clase Enemigo
function enemy:new(x,y,target_x,target_y,velocity,vision)
    self.vision = vision or 300
    self.velocity = velocity or 2
    self.x = x or 0
    self.y = y or 0
    self.target_x = target_x or 0
    self.target_y = target_y or 0
end

--Other Fuctions--

function dist(x1,y1,x2,y2)
    d = ((x1-x2)^2 + (y1-y2)^2)^(0.5)
    return d
end

function norm(x,y)
    d = (x^2 + y^2)^(0.5)
    return d
end  


--Other Methods--
-- enemy --
function enemy:move_to(location_x,location_y)
    direction ={(location_x-self.x )/norm(self.x-location_x,self.y-location_y),(location_y-self.y)/norm(self.x-location_x,self.y-location_y)} 
    self.x = self.x + direction[1]*self.velocity
    self.y = self.y + direction[2]*self.velocity
end    


player1 = player(750,600,50,50,5)
enemies_mele = {}
table.insert(enemies_mele,enemy(500,0))
table.insert(enemies_mele,enemy(750,0))
enemy1 = enemy(750,0)
--cargar
function love.load()

end
--actualizar
function love.update()
    --movimientos del jugador-- 
    if love.keyboard.isDown("w") then
        player1.y = player1.y - 1*player1.velocity
    end
    if love.keyboard.isDown("s") then
        player1.y = player1.y + 1*player1.velocity
    end
    if love.keyboard.isDown("a") then
        player1.x = player1.x - 1*player1.velocity
    end
    if love.keyboard.isDown("d") then
        player1.x = player1.x + 1*player1.velocity
    end
    player1.target_x = love.mouse.getX() -- ubicacion del mouse en x
    player1.target_y = love.mouse.getY() -- ubicacion del mouse en y 
    player1.click_right = love.mouse.isDown(1)
    player1.click_left = love.mouse.isDown(2)

    --movimientos del los enemigos--
    for i,enemy_mele in pairs(enemies_mele) do
        if dist(player1.x, player1.y, enemy_mele.x, enemy_mele.y) < enemy_mele.vision then
            enemy_mele.target_x = player1.x
            enemy_mele.target_y = player1.y
            enemy_mele:move_to(enemy_mele.target_x,enemy_mele.target_y)
        end
    end
end
--dibujar 
function love.draw() 
    -- Dibujar Jugador 1 --
    love.graphics.setColor(360, 360, 360) --dibujar en el color indicado 
    love.graphics.rectangle("fill", (player1.x +20)/2, (player1.y +20)/2,20,20)
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
        love.graphics.rectangle("line", (enemy_mele.x +20)/2, (enemy_mele.y +20)/2,20,20)
    end
    love.graphics.rectangle("line", (enemy1.x +20)/2, (enemy1.y +20)/2,20,20)
    love.graphics.print("Luke es bonito", 500,10)

end