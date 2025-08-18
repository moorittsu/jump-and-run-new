camera = require 'libraries/camera'
cam = camera(0, 0, scale)

local referencewidth = 640
local referenceheight = 360

function cam:update(dt)

    function love.rezise(w, h)
    scale = 1.3
    end

    local camX, camY = player.collider:getPosition()

    local w = love.graphics.getWidth()
    local h = love.graphics.getHeight()
    local scaleX = w / referencewidth
    local scaleY = h / referenceheight
    local zoom = math.min(scaleX, scaleY)

    cam:zoomTo(zoom)

    -- Get width/height of background
    local mapW = gamemap.width * gamemap.tilewidth
    local mapH = gamemap.height * gamemap.tileheight

    --clamping camera to borders
    --[[if mapW > w then
        camX = math.max(w/2, math.min(camX, mapW - w/2))
    else
        camX = mapW / 2
    end

    if mapH > h then
        camY = math.max(h/2, math.min(camY, mapH - h/2))
    else
        camY = mapH / 2
    end]]

    cam:lockPosition(camX, camY)


end