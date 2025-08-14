function gameStart()
    -- Initialize all global variables for the game

    -- Make pixels scale!
    love.graphics.setDefaultFilter("nearest", "nearest")

    anim8 = require("libraries/anim8")
    sti = require("libraries/sti")

    local windfield = require("libraries/windfield")
    world = windfield.newWorld(0, 98, false)

    require("src/startup/require")
    requireAll()

    gamemap = sti('map/map1.lua')
    gamemap.layers.solid.visible = false
    
    solid = {}
    if gamemap.layers["solid"] then
        for i, obj in pairs(gamemap.layers["solid"].objects) do
            ground = world:newRectangleCollider(obj.x, obj.y, obj.width, obj.height)
            ground:setType("static")
            table.insert(solid, ground)
            ground:setCollisionClass('Ground')
    end
    end

        function beginContact(a, b, coll)
            if a.collision_class == 'Player' and b.collision_class == 'Ground' then
                player.onGround = true
                player.yvel = 0
            end
        end

        function endContact(a, b, coll)
            if a.collision_class == 'Player' and b.collision_class == 'Ground' then
                player.onGround = false
            end
        end

    world:setCallbacks(beginContact, endContact)

end