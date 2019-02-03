Ball = Class{}


function Ball:init(x, y, width, height)
    self.x = x
    self.y = y
    self.width = width
    self.height = height

    self.speed_x = math.random(2) == 1 and 100 or -100
    self.speed_y = math.random(-50, 50)
end

function Ball:update(dt)
    self.x = self.x + self.speed_x * dt
    self.y = self.y + self.speed_y * dt
end

function Ball:reset()
    self.x = VIRTUAL_WIDTH / 2 - 2
    self.y = VIRTUAL_HEIGHT / 2 - 2
    self.speed_x = math.random(2) == 1 and 100 or -100
    self.speed_y = math.random(-50,50)  
end

function Ball:render()
    love.graphics.rectangle('fill', self.x, self.y, self.width, self.height)
end