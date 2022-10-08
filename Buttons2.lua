Object = require "lukeclassic"
Button = Object:extend()

function Button:new(text, func, param, width, height, x_pos, y_pos)
    self.width = width or 100
    self.height = height or 100
    self.func = func or function() print("Este Boton no tiene funcionalidad") end
    self.param = param
    self.text = text or "sin texto"
    self.button_x = x_pos or 0
    self.button_y = y_pos or 0
    self.text_x = 0
    self.text_y = 0
end

function Button:_check_click()
    hor_cond_1 = love.mouse.getX() <= self.button_x + self.width
    hor_cond_2 = love.mouse.getX() >= self.button_x
    ver_cond_1 = love.mouse.getY() <= self.button_y + self.height
    ver_cond_2 = love.mouse.getY() >= self.button_y
    if(hor_cond_1 and hor_cond_2 and ver_cond_1 and ver_cond_2)then
        self.func(self.param)
    end
end

function Button:draw()
    love.graphics.rectangle('line', self.button_x, self.button_y, self.width, self.height)
end


