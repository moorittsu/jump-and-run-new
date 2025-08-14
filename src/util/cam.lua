camera = require 'libraries/camera'
cam = camera(0, 0, scale)

function cam:update(dt)

    local camX, camY = player.collider:getPosition()

    local w = love.graphics.getWidth()
    local h = love.graphics.getHeight()

    -- Get width/height of background
    local mapW = gamemap.width * gamemap.tilewidth
    local mapH = gamemap.height * gamemap.tileheight

        -- Left border
    if camX < w/2 then
        camX = w/2
    end

    -- Right border
    if camY < h/2 then
        camY = h/2
    end

    -- Right border
    if camX > (mapW - w/2) then
        camX = (mapW - w/2)
    end
    -- Bottom border
    if camY > (mapH - h/2) then
        camY = (mapH - h/2)
    end

    cam:lockPosition(camX, camY)

    cam.x, cam.y = cam:position()
end