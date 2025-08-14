

function love.load()
    require("src/startup/gameStart")
    gameStart()

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
