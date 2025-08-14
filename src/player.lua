player = {}
-- Player position and size
player.x = 200
player.y = 400
player.width = 24
player.height = 32

player.collider = world:newBSGRectangleCollider(player.x, player.y, player.width, player.height, 6)

-- Player movement variables
player.xvel = 0
player.yvel = 0
player.maxspeed = 50
player.acceleration = 800
player.friction = 500
player.gravity = 900
player.onGround = false
player.isMoving = false
player.facing = "right"

player.collider:setCollisionClass("Player")
player.collider:setFixedRotation(true)

--player animation
player.spritesheet = love.graphics.newImage("assets/individual_sheets/male_hero_template.png")
player.grid = anim8.newGrid(128, 128, player.spritesheet:getWidth(), player.spritesheet:getHeight())
player.animations = {}
player.animations.idle = anim8.newAnimation(player.grid("1-10", 2), 0.2)
player.animations.walk = anim8.newAnimation(player.grid("1-10", 3), 0.2)
player.animations.run = anim8.newAnimation(player.grid("1-10", 4), 0.1)
player.animations.jump = anim8.newAnimation(player.grid("1-6", 5), 0.2)
player.animations.fall = anim8.newAnimation(player.grid("1-4", 6), 0.2)

player.anim = player.animations.idle
  

function player:update(dt)
    player:move(dt)
    player.anim:update(dt)
    player.x, player.y = player.collider:getPosition()
end

function player:move(dt)

    --sprinting
    local sprinting = love.keyboard.isDown("lshift")
    if sprinting then
        player.maxspeed = 200 
        player.acceleration = 1000
    else
        player.maxspeed = 50
        player.acceleration = 800
    end

    local vx, vy = player.collider:getLinearVelocity()
            -- Gravity
    if not player.onGround then
        vy = vy + player.gravity * dt
    end

    -- Horizontal movement with acceleration
    if love.keyboard.isDown("a") then
        vx = math.max(vx - player.acceleration * dt, -player.maxspeed)
        player.isMoving = true
        player.facing = "left"
        player.anim = sprinting and player.animations.run or player.animations.walk
    elseif love.keyboard.isDown("d") then
        vx = math.min(vx + player.acceleration * dt, player.maxspeed)
        player.isMoving = true
        player.facing = "right"
        player.anim = sprinting and player.animations.run or player.animations.walk
    else
        -- Apply friction when no key is pressed
        if vx > 0 then
            vx = math.max(vx - player.friction * dt, 0)
        elseif vx < 0 then
            vx = math.min(vx + player.friction * dt, 0)
        end
    end

    if player.isMoving == false then
        player.anim = player.animations.idle
    end

    -- Clamp the player's velocity to the maximum speed
    if math.abs(vx) > player.maxspeed then
        vx = player.maxspeed * (vx < 0 and -1 or 1)
    end

    -- Set the new velocity
    player.collider:setLinearVelocity(vx, vy)

    if vx == 0 then
        player.isMoving = false
    end
end


function player:draw()
    local sx = player.facing == "left" and -1 or 1
    player.anim:draw(player.spritesheet, player.x, player.y, nil, sx, 1, 64, 64)
end

return player