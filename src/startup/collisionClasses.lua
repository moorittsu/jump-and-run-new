function createCollisionClasses()
    world:addCollisionClass('Player', {ignores = {}})
    world:addCollisionClass('Ground', {ignores = {}})
end