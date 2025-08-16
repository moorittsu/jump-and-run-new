

function love.load()
    require("src/startup/gameStart")
    gameStart()
    require("src/startup/require")
    requireAll()
end

function love.update(dt)
    updateAll(dt)
end

function love.draw()

    cam:attach()
        world:draw()
        player:draw()
        gamemap:drawLayer(gamemap.layers["surface"])
    cam:detach()

end

function love.keypressed(key)
    if key == "space"
    then player:jump()
    end
end

function love.gamepadpressed(joystick , button)
    if button == "a"
    then player:jump()
    end
end
