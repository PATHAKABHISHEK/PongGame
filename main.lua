-- This is the File which contains code to run by default

-- Reguiring/Importing push.lua file
push = require 'push' -- It will handle the graphics sizes in the game

Class = require 'class'

require 'Paddle'
require 'Ball'

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
    math.randomseed(os.time())

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

    -- player1_y = 30
    -- player2_y = VIRTUAL_HEIGHT - 50

    -- ball_x = VIRTUAL_WIDTH / 2 - 2
    -- ball_y = VIRTUAL_HEIGHT / 2 - 2 

    -- ball_speed_x = math.random(2) == 1 and 100 or -100
    -- ball_speed_y = math.random(-50, 50)

    player1 = Paddle(10, 30, 5, 20)
    player2 = Paddle(VIRTUAL_WIDTH - 20, VIRTUAL_HEIGHT - 30, 5, 20)

    ball = Ball(VIRTUAL_WIDTH / 2 - 2, VIRTUAL_HEIGHT / 2 - 2, 4, 4)

    gameState = 'start'

end

function love.update(dt)
    
    -- Player 1 Movements
    if love.keyboard.isDown('w') then
        player1.dy = -PADDLE_SPEED 
    elseif love.keyboard.isDown('s') then
        player1.dy =  PADDLE_SPEED
    else
        player1.dy = 0
    end

    -- Player 2 Movements 
    if love.keyboard.isDown('up') then
        player2.dy = -PADDLE_SPEED
    elseif love.keyboard.isDown('down') then
        player2.dy = PADDLE_SPEED
    else
        player2.dy = 0
    end

    if gameState == 'play' then
        ball:update(dt)
    end

    player1:update(dt)
    player2:update(dt)
end


-- The below code will handle key handling in the game
-- The love.keypressed(key) will be called each and every frame and
-- the key which will be passed as the parameter will be of string type
-- eg:- 'escape'
function love.keypressed(key)
    if key == 'escape' then
        love.event.quit() -- This method will close the game
    elseif key == 'return' or key == 'enter' then
        if gameState == 'start' then
            gameState = 'play'
        else
            gameState = 'start'
            ball:reset()
        end
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
    if gameState == 'start' then
        love.graphics.printf('Start Game By Pressing Enter', 0, 20,
            VIRTUAL_WIDTH,
            'center'
        )
    else
        love.graphics.printf('Game Started', 0, 20, VIRTUAL_WIDTH,
        'center')
    end

    -- Setting the font for scores display
    love.graphics.setFont(score_font)
    -- Player1 Score Display
    love.graphics.print(tostring(player1_score), VIRTUAL_WIDTH / 2 - 50, VIRTUAL_HEIGHT / 3)

    -- Player2 Score Display
    love.graphics.print(tostring(player2_score), VIRTUAL_WIDTH / 2 + 50, VIRTUAL_HEIGHT / 3)


    -- -- first paddle
    -- love.graphics.rectangle('fill', 10, player1_y, 5, 20)

    -- -- second paddle
    -- love.graphics.rectangle('fill', VIRTUAL_WIDTH - 20, player2_y, 5, 20)

    -- -- Ball
    -- love.graphics.rectangle('fill', ball_x, ball_y, 4, 4)


    player1:render()
    player2:render()

    ball:render()

    -- end rendering ate virtual resolution 
    push:apply('end')
end

