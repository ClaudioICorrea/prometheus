
require "buttons"

function love.mousepressed(x, y, pressed_button, is_touch, presses)
    if not game.state['running'] then
        if pressed_button == 1 then
            if game.state["menu"] then
                for i,button in ipairs(menu_buttons) do
                    button:_check_click()
                end
            end

        end
    elseif edit_mode then
        save_edit_button:_check_click()
    end
end

function load_menu()
    menu_buttons ={}
    table.insert(menu_buttons,Button("Play Game",
            function()
                game.state["menu"]= false
                game.state["running"] = true
            end
    , nil, 110, 50,screen_width / 2 - 55, screen_height / 7 ))
    table.insert(menu_buttons,Button("Settings", nil, nil, 110, 50,screen_width / 2 - 55, 2 * screen_height / 7 ))
    table.insert(menu_buttons,Button("Exit Game",
            function(event_status)
                love.event.quit(event_status )
            end
    , 0, 110, 50,screen_width / 2 - 55, 3 * screen_height / 7 ))
    table.insert(menu_buttons,Button("Re-Start", nil, nil, 110, 50,screen_width / 2 - 55, 4 * screen_height / 7 ))
end

function draw_menu()
    love.graphics.print("MENU", screen_width / 2 - 25, 10)
    for i,button in ipairs(menu_buttons) do
        button:draw()
    end
end