
local player = {}

function player:load()
    self.speed = 220
    self.shooting = 0
end

function player:update(dt)
    if self.shooting > 0 then
        self.shooting = self.shooting - dt
    end

    local vx, vy = 0, 0
    local sx, sy = 0, 0

    if love.keyboard.isScancodeDown('h') then
        vx = vx - self.speed
    end
    if love.keyboard.isScancodeDown('l') then
        vx = vx + self.speed
    end
    if love.keyboard.isScancodeDown('k') then
        vy = vy - self.speed
    end
    if love.keyboard.isScancodeDown('j') then
        vy = vy + self.speed
    end

    if love.keyboard.isScancodeDown('a') then
        sx = -self.speed*10
    elseif love.keyboard.isScancodeDown('f') then
        sx = self.speed*10
    elseif love.keyboard.isScancodeDown('d') then
        sy = -self.speed*10
    elseif love.keyboard.isScancodeDown('s') then
        sy = self.speed*10
    end

    if vx ~= 0 and vy ~= 0 then
        vx = 0
        vy = 0
    end

    if (sx ~= 0 or sy ~= 0) and self.shooting <= 0 then
        game.root:add(bullet(self.position+cpml.vec2(10, 10),
                             sx, sy))
        self.shooting = 1
    end

    self.position.x = self.position.x + vx*dt
    self.position.y = self.position.y + vy*dt
end
