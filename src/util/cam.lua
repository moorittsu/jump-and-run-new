camera = require 'libraries/camera'
local scale = 1.3
cam = camera(0, 0, scale)

function cam:update(dt)

    local camX, camY = player.collider:getPosition()

    local w = love.graphics.getWidth()
    local h = love.graphics.getHeight()

    -- Get width/height of background
    local mapW = gamemap.width * gamemap.tilewidth
    local mapH = gamemap.height * gamemap.tileheight

    --clamping camera to borders
    --[[camX = math.max(w/2, math.min(camX, mapW - w/2))
    camY = math.max(h/2, math.min(camY, mapH - h/2))]]

    cam:lockPosition(camX, camY)


end