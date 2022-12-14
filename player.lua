Object = require("lukeclassic")
Player = Object:extend()


function Player:new(x, y, target_x, target_y, velocity, click_right, click_left, radius)
    self.radius = radius or 10
    self.velocity = velocity or 0
    self.x = x or 0
    self.y = y or 0
    self.direction_x = 0
    self.direction_y = 0
    self.target_x = target_x or 0
    self.target_y = target_y or 0
    self.click_right = click_right or false
    self.click_left = click_left or false
    self.coefficient = 1
end
function keypressed(key,prop)
    if love.keyboard.isDown(key) then
        check1 = true     
    end
    if not love.keyboard.isDown(key) and check1 then
        check2 = true 
    end    
    if check1 and check2 then
        prop =not prop
        check1 =false
        check2 =false
    end
    return prop
end



function Player:_input_player()
    self.direction_x = 0
    self.direction_y = 0
    self.target_x = love.mouse.getX() -- ubicacion del mouse en x
    self.target_y = love.mouse.getY() -- ubicacion del mouse en y
    self.click_right = love.mouse.isDown(1)
    self.click_left = love.mouse.isDown(2)
    if game.state["running"] then 
    -- direccion del jugador     
        if love.keyboard.isDown("w") and not love.keyboard.isDown("s") then
            self.direction_y = (self.direction_y - 1)
        end
        if  love.keyboard.isDown("s")  and not love.keyboard.isDown("w") then
            self.direction_y = (self.direction_y + 1)
        end
        if  love.keyboard.isDown("a") and not love.keyboard.isDown("d") then
            self.direction_x = (self.direction_x - 1)
        end
        if love.keyboard.isDown("d") and not love.keyboard.isDown("a") then
            self.direction_x = (self.direction_x + 1)
        end
        norm_direc =norm(self.direction_x,self.direction_y) 
        if not( norm_direc  == 0) then 
            self.direction_x = self.direction_x/norm_direc
            self.direction_y = self.direction_y/norm_direc
        end
        if love.keyboard.isDown("m") then
            game.state["menu"]= true
            game.state["running"] = false
        end
        info_game = keypressed("1", info_game)
    end 
end


function Player:_move(dt)
    if game.state["running"] then
        self.y = self.y + self.direction_y * self.velocity * dt * self.coefficient
        self.x = self.x + self.direction_x * self.velocity * dt * self.coefficient
    end
end

function Player:draw()
    love.graphics.setColor(360, 360, 360) --dibujar en el color indicado
    --square_draw("fill", self.x, self.y, 20, 20)
    love.graphics.circle("fill", self.x, self.y, self.radius)
    love.graphics.setColor(360, 360, 360) --dibujar en el color indicado
    if self.click_right then
        love.graphics.setColor(1, 0, 0)
    end
    if self.click_left then
        love.graphics.setColor(0, 1, 0)
    end
    love.graphics.circle("line", self.target_x, self.target_y, 10) --dibuja un circulo
end