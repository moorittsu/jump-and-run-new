function updateAll(dt)
    updateGame(dt)
end

function updateGame(dt)
    world:update(dt)
    player:update(dt)
    cam:update(dt)
end