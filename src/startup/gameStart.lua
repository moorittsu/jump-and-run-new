
function gameStart()

    anim8 = require("libraries/anim8")
    sti = require("libraries/sti")
    local windfield = require("libraries/windfield")

    -- Make pixels scale!
    love.graphics.setDefaultFilter("nearest", "nearest")
    love.window.setMode(1024, 640, {resizable = true, fullscreen = false})

    world = windfield.newWorld(0, 900, false)

    require("src/startup/collisionClasses")
    createCollisionClasses()

    gamemap = sti('map/map1.lua')
    gamemap.layers.solid.visible = false

    solid = {}
    if gamemap.layers["solid"] then
        for i, obj in pairs(gamemap.layers["solid"].objects) do
            ground = world:newRectangleCollider(obj.x, obj.y, obj.width, obj.height)
            ground:setType("static")
            ground:setCollisionClass('Ground')
            table.insert(solid, ground)
        end
    end

    player = require("src/player")
    player.initCollider()


end