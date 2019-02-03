-- This is the File which contains code to run by default

--Setting up the window width and height in pixels
WINDOW_HEIGHT = 720
WINDOW_WIDTH = 1280

-- This is the function which will be called when game will be loaded
-- first time
function love.load()
    love.window.setmode(WINDOW_WIDTH, WINDOW_HEIGHT, {
        fullscreen = false,-- fullscreen mode cannot be accesed
        resizable = false, -- window will not be resized 
        vsync = true --this is for synching of monitors
    })
end


