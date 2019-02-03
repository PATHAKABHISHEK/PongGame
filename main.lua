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
    
    love.window.setTitle('PONG GAME')

    math.randomseed(os.time())
    
    love.graphics.setDefaultFilter('nearest', 'nearest')
    
    pong_text_font = love.graphics.newFont('font.ttf', 8)

    score_font = love.graphics.newFont('font.ttf', 32)


    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, 
    WINDOW_HEIGHT, {
        fullscreen = false,
        resizable = true,
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
    servingPlayer = 1
    gameState = 'start'


    sounds = {
        ['paddle_hit'] = love.audio.newSource('sounds/paddle_hit.wav', 'static'),
        ['score'] = love.audio.newSource('sounds/score.wav', 'static'),
        ['wall_hit'] = love.audio.newSource('sounds/wall_hit.wav', 'static'),
    }
end

function love.resize(w, h)
    push:resize(w, h)
end

function love.update(dt)
    if gameState == 'serve' then
        -- before switching to play, initialize ball's velocity based
        -- on player who last scored
        ball.speed_y = math.random(-50, 50)
        if servingPlayer == 1 then
            ball.speed_x = math.random(140, 200)
        else
            ball.speed_x = -math.random(140, 200)
        end
    elseif gameState == 'play' then
        -- detect ball collision with paddles, reversing dx if true and
        -- slightly increasing it, then altering the dy based on the position of collision
        if ball:collides(player1) then
            ball.speed_x = -ball.speed_x * 1.03
            ball.x = player1.x + 5

            -- keep velocity going in the same direction, but randomize it
            if ball.speed_y < 0 then
                ball.speed_y = -math.random(10, 150)
            else
                ball.speed_y = math.random(10, 150)
            end
            sounds['paddle_hit']:play()
        end
        if ball:collides(player2) then
            ball.speed_x = -ball.speed_x * 1.03
            ball.x = player2.x - 4

            -- keep velocity going in the same direction, but randomize it
            if ball.speed_y < 0 then
                ball.speed_y = -math.random(10, 150)
            else
                ball.speedy = math.random(10, 150)
            end
            sounds['paddle_hit']:play()
        end

        -- detect upper and lower screen boundary collision and reverse if collided
        if ball.y <= 0 then
            ball.y = 0
            ball.speed_y = -ball.speed_y
            sounds['wall_hit']:play()
        end

        -- -4 to account for the ball's size
        if ball.y >= VIRTUAL_HEIGHT - 4 then
            ball.y = VIRTUAL_HEIGHT - 4
            ball.speed_y = -ball.speed_y
            sounds['wall_hit']:play()
        end
    end
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

    if ball.x < 0 then
        servingPlayer = 1
        player2_score = player2_score + 1
        sounds['score']:play()
        if player2_score == 10 then
            winningPlayer = 2
            gameState = 'done'
        else
            ball:reset()
            gameState = 'serve'
        end
    end

    if ball.x > VIRTUAL_WIDTH then
        servingPlayer = 2
        player1_score = player1_score + 1
        sounds['score']:play()
        if player1_score == 10 then
            winningPlayer = 1
            gameState = 'done'
        else
            ball:reset()
            gameState = 'serve'
        end
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
            gameState = 'serve'
        elseif gameState == 'serve' then
            gameState = 'play'
        elseif gameState == 'done' then
            gameState = 'serve'
            ball:reset()
            player1_score = 0
            player2_score = 0

            -- decide serving player as the opposite of who won
            if winningPlayer == 1 then
                servingPlayer = 2
            else
                servingPlayer = 1
            end
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
        love.graphics.setFont(pong_text_font)
        love.graphics.printf('Welcome to Pong!', 0, 10, VIRTUAL_WIDTH, 'center')
        love.graphics.printf('Press Enter to begin!', 0, 20, VIRTUAL_WIDTH, 'center')
    elseif gameState == 'serve' then
        love.graphics.setFont(pong_text_font)
        love.graphics.printf('Player ' .. tostring(servingPlayer) .. "'s serve!", 
            0, 10, VIRTUAL_WIDTH, 'center')
        love.graphics.printf('Press Enter to serve!', 0, 20, VIRTUAL_WIDTH, 'center')
    elseif gameState == 'play' then
        -- no UI messages to display in play
    elseif gameState == 'done' then
        -- UI messages
        love.graphics.setFont(score_font)
        love.graphics.printf('Player ' .. tostring(winningPlayer) .. ' wins!',
            0, 10, VIRTUAL_WIDTH, 'center')
        love.graphics.setFont(pong_text_font)
        love.graphics.printf('Press Enter to restart!', 0, 30, VIRTUAL_WIDTH, 'center')
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

    showFPS()
    player1:render()
    player2:render()

    ball:render()

    -- end rendering ate virtual resolution 
    push:apply('end')
end

function showFPS()
    love.graphics.setFont(pong_text_font)
    love.graphics.setColor(0, 255, 0, 255)
    love.graphics.print('FPS ' ..tostring(love.timer.getFPS()), 10, 10)
end

