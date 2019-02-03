-- This is the File which contains code to run by default

-- Reguiring/Importing push.lua file
push = require 'push' -- It will handle the graphics sizes in the game

-- Setting up the window width and height in pixels
WINDOW_HEIGHT = 720
WINDOW_WIDTH = 1280

VIRTUAL_HEIGHT = 243
VIRTUAL_WIDTH = 432


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
    love.graphics.setFont(pong_text_font)

    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, 
    WINDOW_HEIGHT, {
        fullscreen = false,
        resizable = false,
        vsync = true
    })
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
    love.graphics.clear(40, 45, 52, 255)

     love.graphics.printf('Pong Game', 0, VIRTUAL_HEIGHT/2 - 6,
        VIRTUAL_WIDTH,
        'center'
    )

    -- end rendering ate virtual resolution 
    push:apply('end')
end

