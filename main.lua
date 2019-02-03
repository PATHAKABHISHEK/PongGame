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

    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, 
    WINDOW_HEIGHT, {
        fullscreen = false,
        resizable = false,
        vsync = true
    })
end

function love.draw()
    love.graphics.printf(
        'Pong Game',
        0,
        WINDOW_HEIGHT/2 - 6,
        WINDOW_WIDTH,
        'center'
    )
end

