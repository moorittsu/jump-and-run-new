player = {}
-- Player position and size
player.x = 200
player.y = 400
player.width = 24
player.height = 32
player.onGround = false

player.collider = world:newBSGRectangleCollider(player.x, player.y, player.width, player.height, 6)

-- Player movement variables
player.xvel = 0
player.yvel = 0
player.maxspeed = 200
player.acceleration = 4000
player.friction = 3500

player.collider:setCollisionClass("Player")
player.collider:setFixedRotation(true)

--player animation
player.spritesheet = love.graphics.newImage("assets/individual_sheets/male_hero_template.png")
player.grid = anim8.newGrid(128, 128, player.spritesheet:getWidth(), player.spritesheet:getHeight())
player.animations = {}
player.animations.idle = anim8.newAnimation(player.grid("1-10", 2), 0.2)
  

function player:update(dt)
    player:move(dt)
    player.animations.idle:update(dt)
    player.x, player.y = player.collider:getPosition()
end

function player:move(dt)

     isMoving = false

    if isMoving == false then
        player.anim = player.animations.idle
    end

    -- Clamp the player's velocity to the maximum speed
    if math.abs(player.xvel) > player.maxspeed then
        player.xvel = player.maxspeed * (player.xvel < 0 and -1 or 1)
    end
    -- ...existing code...
end


function player:applyGravity(dt)
    if player.onGround == false then
        player.yvel = player.yvel + player.gravity * dt
    end
end

function player:draw()

    player.animations.idle:draw(player.spritesheet, player.x, player.y, nil, 1, 1, 64, 64)
end

return player