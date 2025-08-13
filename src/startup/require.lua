function requireAll()
    require("src/startup/collisionClasses")
    createCollisionClasses()

    require("src/player")
    require("src/update")
    require("src/draw")

    
end