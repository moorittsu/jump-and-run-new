function gameStart()
    -- Initialize all global variables for the game

    -- Make pixels scale!
    love.graphics.setDefaultFilter("nearest", "nearest")

    anim8 = require("libraries/anim8")
    sti = require("libraries/sti")

    local windfield = require("libraries/windfield")
    world = windfield.newWorld(0, 98, false)

    gamemap = sti('map/map1.lua')
    gamemap.layers.solid.visible = false
    
    solid = {}
    if gamemap.layers["solid"] then
        for i, obj in pairs(gamemap.layers["solid"].objects) do
            local ground = world:newRectangleCollider(obj.x, obj.y, obj.width, obj.height)
            ground:setType("static")
            table.insert(solid, ground)
    end
    end

    require("src/startup/require")
    requireAll()

end