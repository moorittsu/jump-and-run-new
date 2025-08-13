function updateAll(dt)
    updateGame(dt)
end

function updateGame(dt)
    player:update(dt)
    world:update(dt)
    
end