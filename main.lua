

function love.load()
    require("src/startup/gameStart")
    gameStart()

end

function love.update(dt)
    updateAll(dt)
end

function love.draw()
world:draw()
player:draw()
end
