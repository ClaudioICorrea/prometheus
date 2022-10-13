Object = require("lukeclassic")
Player = Object:extend()


function Player:new(x, y, target_x, target_y, velocity, click_right, click_left, radius)
    self.radius = radius or 30
    self.velocity = velocity or 0
    self.x = x or 0
    self.y = y or 0
    self.target_x = target_x or 0
    self.target_y = target_y or 0
    self.click_right = click_right or false
    self.click_left = click_left or false
end

function Player:_move()
    if game.state["running"] then
        if love.keyboard.isDown("w") then
            self.y = self.y - 1 * self.velocity
        end
        if love.keyboard.isDown("s") then
            self.y = self.y + 1 * self.velocity
        end
        if love.keyboard.isDown("a") then
            self.x = self.x - 1 * self.velocity
        end
        if love.keyboard.isDown("d") then
            self.x = self.x + 1 * self.velocity
        end
        if love.keyboard.isDown("m") then
            game.state["menu"]= true
            game.state["running"] = false
        end
    end
    self.target_x = love.mouse.getX() -- ubicacion del mouse en x
    self.target_y = love.mouse.getY() -- ubicacion del mouse en y
    self.click_right = love.mouse.isDown(1)
    self.click_left = love.mouse.isDown(2)
end

function Player:draw()
    love.graphics.setColor(360, 360, 360) --dibujar en el color indicado
    square_draw("fill", self.x, self.y, 20, 20)
    love.graphics.setColor(360, 360, 360) --dibujar en el color indicado
    if self.click_right then
        love.graphics.setColor(1, 0, 0)
    end
    if self.click_left then
        love.graphics.setColor(0, 1, 0)
    end
    love.graphics.circle("line", self.target_x, self.target_y, 10) --dibuja un circulo
end