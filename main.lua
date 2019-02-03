-- This is the File which contains code to run by default

-- Reguiring/Importing push.lua file
push = require 'push' -- It will handle the graphics sizes in the game

-- Setting up the window width and height in pixels
WINDOW_HEIGHT = 720
WINDOW_WIDTH = 1280

VIRTUAL_HEIGHT = 243
VIRTUAL_WIDTH = 432

PADDLE_SPEED = 200


-- This is the function which will be called when game will be loaded
-- first time
function love.load()
    -- As now we are using push so we are not using setMode method
    --[[ love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT, {
        fullscreen = false,-- fullscreen mode cannot be accesed
        resizable = false, -- window will not be resized 
        vsync = true --this is for synching of monitors
    }) ]]
    love.graphics.setDefaultFilter('nearest', 'nearest')
 
    pong_text_font = love.graphics.newFont('font.ttf', 8)

    score_font = love.graphics.newFont('font.ttf', 32)


    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, 
    WINDOW_HEIGHT, {
        fullscreen = false,
        resizable = false,
        vsync = true
    })

    player1_score = 0
    player2_score = 0

    player1_y = 30
    player2_y = VIRTUAL_HEIGHT - 50

end

function love.update(dt)
    
    -- Player 1 Movements
    if love.keyboard.isDown('w') then
        player1_y = player1_y - (PADDLE_SPEED * dt)
    end
    if love.keyboard.isDown('s') then
        player1_y = player1_y + (PADDLE_SPEED * dt)
    end

    -- Player 2 Movements 
    if love.keyboard.isDown('up') then
        player2_y = player2_y - (PADDLE_SPEED * dt)
    end
    if love.keyboard.isDown('down') then
        player2_y = player2_y + (PADDLE_SPEED * dt)
    end
end


-- The below code will handle key handling in the game
-- The love.keypressed(key) will be called each and every frame and
-- the key which will be passed as the parameter will be of string type
-- eg:- 'escape'
function love.keypressed(key)
    if key == 'escape' then
        love.event.quit() -- This method will close the game
    end
 end


function love.draw()
    -- start rendering at virtual resolution
    push:apply('start')
    -- not using WINDOW_HEIGHT and WINDOW_WEIGHT as we are using
    -- virtual resolution rendering

    --[[  love.graphics.printf(
        'Pong Game',
        0,
        WINDOW_HEIGHT/2 - 6,
        WINDOW_WIDTH,
        'center'
    ) ]]

    -- This is the clear methods whicl will be used to color the screen
    -- with a specific color whenever draw function will be called
    
        --love.graphics.clear(40, 45, 52, 255)
    love.graphics.setFont(pong_text_font)
    love.graphics.printf('Pong Game', 0, VIRTUAL_HEIGHT/2 - 6,
        VIRTUAL_WIDTH,
        'center'
    )
    -- Setting the font for scores display
    love.graphics.setFont(score_font)
    -- Player1 Score Display
    love.graphics.print(tostring(player1_score), VIRTUAL_WIDTH / 2 - 50, VIRTUAL_HEIGHT / 3)

    -- Player2 Score Display
    love.graphics.print(tostring(player2_score), VIRTUAL_WIDTH / 2 + 50, VIRTUAL_HEIGHT / 3)


    -- first paddle
    love.graphics.rectangle('fill', 10, player1_y, 5, 20)

    -- second paddle
    love.graphics.rectangle('fill', VIRTUAL_WIDTH - 20, player2_y, 5, 20)

    -- Ball
    love.graphics.rectangle('fill', VIRTUAL_WIDTH / 2 - 2 , VIRTUAL_HEIGHT / 2 - 2, 4, 4)

    -- end rendering ate virtual resolution 
    push:apply('end')
end

