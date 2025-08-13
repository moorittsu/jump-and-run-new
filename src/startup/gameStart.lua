function gameStart()
    -- Initialize all global variables for the game

    -- Make pixels scale!
    love.graphics.setDefaultFilter("nearest", "nearest")

    anim8 = require("libraries/anim8")
    sti = require("libraries/sti")

    local windfield = require("libraries/windfield")
    world = windfield.newWorld(0, 0, false)

    require("src/startup/require")
    requireAll()

end