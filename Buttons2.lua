Object = require "lukeclassic"
Button = Object:extend()

function Button:new(text, func, param, width, height, x_pos, y_pos, font)
    self.width = width or 100
    self.height = height or 100
    self.func = func or function() print("Este Boton no tiene funcionalidad") end
    self.param = param
    self.text = text or "sin texto"
    self.button_x = x_pos or 0
    self.button_y = y_pos or 0
    self.font = font or love.graphics.getFont()
    text = love.graphics.newText(self.font, self.text)
    text_width = text:getWidth()
    text_height = text:getHeight()
    self.text_x = (self.width - text_width)/2
    self.text_y = (self.height - text_height)/2

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

    love.graphics.setColor(0.6, 0.6, 0.6)
    love.graphics.rectangle("fill", self.button_x, self.button_y, self.width, self.height)
    love.graphics.setColor(0, 0, 0)
    love.graphics.print(self.text, self.button_x + self.text_x, self.button_y +self.text_y)
    love.graphics.setColor(1, 1, 1)
end


