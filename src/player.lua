player = {}
-- Player position and size
player.x = 200
player.y = 400
player.width = 24
player.height = 32

function player.initCollider()
    player.collider = world:newRectangleCollider(player.x, player.y, player.width, player.height)
    player.collider:setCollisionClass("Player")
    player.collider:setFixedRotation(true)
end
-- Player movement variables
player.xvel = 0
player.yvel = 0
player.maxspeed = 300
player.acceleration = 2000
player.airAcceleration = 20000
player.friction = 1000
player.frictionAir = 500
--player.gravity = 900
player.jumpVelocity = 500
player.isMoving = false
player.facing = "right"
player.prevFacing = "right"
player.coyoteTime = 0.15 --max coyoteTime in sec
player.coyoteTimer = 0 --timer which counts down

--player animation
player.spritesheet = love.graphics.newImage("assets/individual_sheets/male_hero_template.png")
player.grid = anim8.newGrid(128, 128, player.spritesheet:getWidth(), player.spritesheet:getHeight())
player.animations = {}
player.animations.idle = anim8.newAnimation(player.grid("1-10", 2), 0.2)
player.animations.walk = anim8.newAnimation(player.grid("1-10", 3), 0.1)
player.animations.run = anim8.newAnimation(player.grid("1-10", 4), 0.1)
player.animations.takeoff = anim8.newAnimation(player.grid(1, 5), 0.5)
player.animations.ascent = anim8.newAnimation(player.grid("2-3", 5), 0.5)
player.animations.peak = anim8.newAnimation(player.grid("4-5", 5), 0.2)
player.animations.fall = anim8.newAnimation(player.grid("1-4", 6), 0.2)

player.anim = player.animations.idle


function player:update(dt)
    player:move(dt)
    player.anim:update(dt)
    player.x, player.y = player.collider:getPosition()
end

function player:move(dt)
    --get first connected gamepad
    local gamepads = love.joystick.getJoysticks()
    local gamepad = gamepads[1]

    --sprinting lshift or left trigger
    sprinting = love.keyboard.isDown("lshift") or (gamepad and gamepad:getGamepadAxis("triggerleft") > 0.5)
    if sprinting then
        player.maxspeed = 1000 
        player.acceleration = 300
    else
        player.maxspeed = 200
        player.acceleration = 1000
    end

    --coyote time
    if player:isOnGround() then
        player.coyoteTimer = player.coyoteTime
    else
        player.coyoteTimer = math.max(0, player.coyoteTimer - dt)     
    end

    player.xvel, player.yvel = player.collider:getLinearVelocity()

    -- Movement: keyboard A/D or gamepad left stick
    local left = love.keyboard.isDown("a") or (gamepad and gamepad:getGamepadAxis("leftx") < -0.2)
    local right = love.keyboard.isDown("d") or (gamepad and gamepad:getGamepadAxis("leftx") > 0.2)

    -- Horizontal movement with acceleration
    if left then
        player.xvel = math.max(player.xvel - player.acceleration * dt, -player.maxspeed)
        player.isMoving = true
        player.facing = "left"
        player.prevFacing = "left"
        player.anim = sprinting and player.animations.run or player.animations.walk
    elseif left and not player:isOnGround() and player.prevFacing == "right" then
        player.xvel = math.max(player.xvel - player.airAcceleration * dt, -player.maxspeed)
        player.isMoving = true
        player.facing = "left"
        player.prevFacing = "left"
        player.anim = sprinting and player.animations.run or player.animations.walk
    elseif right then
        player.xvel = math.min(player.xvel + player.acceleration * dt, player.maxspeed)
        player.isMoving = true
        player.facing = "right"
        player.prevFacing = "right"
        player.anim = sprinting and player.animations.run or player.animations.walk
    elseif right and not player:isOnGround() and player.prevFacing == "left" then
        player.xvel = math.min(player.xvel + player.airAcceleration * dt, player.maxspeed)
        player.isMoving = true
        player.facing = "right"
        player.prevFacing = "right"
        player.anim = sprinting and player.animations.run or player.animations.walk
    else
        -- Apply friction when no key is pressed
        if player.xvel > 0 and player:isOnGround() then
            player.xvel = math.max(player.xvel - player.friction * dt, 0)
        elseif player.xvel < 0 and player:isOnGround() then
            player.xvel = math.min(player.xvel + player.friction * dt, 0)
        elseif player.xvel > 0 and not player:isOnGround() then
            player.xvel = math.max(player.xvel - player.frictionAir * dt, 0)
        elseif player.xvel < 0 and not player:isOnGround() then
            player.xvel = math.min(player.xvel + player.frictionAir * dt, 0)
        end
    end

    if player.isMoving == false then
        player.anim = player.animations.idle
    end


    -- Clamp the player's velocity to the maximum speed
    if math.abs(player.xvel) > player.maxspeed then
        player.xvel = player.maxspeed * (player.xvel < 0 and -1 or 1)
    end

    -- Set the new velocity
    player.collider:setLinearVelocity(player.xvel, player.yvel)

    if player.xvel == 0 then
        player.isMoving = false
    end

    if player.yvel < 0 and not player:isOnGround() then
        player.anim = player.animations.ascent
        player.isMoving = true
    elseif math.abs(player.yvel) < 1 and not player:isOnGround() then
                player.anim = player.animations.peak
                player.isMoving = true
    elseif player.yvel > 0 and not player:isOnGround() then
                player.anim = player.animations.fall
        player.isMoving = true
    elseif player.yvel == 0 and not player:isOnGround() then
        player.anim = player.animations.idle
    end

end


function player:draw()
    local sx = player.facing == "left" and -1 or 1
    player.anim:draw(player.spritesheet, player.x, player.y, nil, sx, 1, 64, 64)
end

function player:jump()
    if player:isOnGround() or player.coyoteTimer > 0 then
    player.xvel, player.yvel = player.collider:getLinearVelocity()
    player.collider:setLinearVelocity(player.xvel, 0)
    player.collider:applyLinearImpulse(0, -player.jumpVelocity)
    player.isMoving = true
    player.anim = player.animations.takeoff
    player.coyoteTimer = 0
    end
end

function player:isOnGround()
if sprinting then
local px, py = player.collider:getPosition()
local checkW = player.width
local checkH = 20 --how many pixels to check below
local checkX = px - player.width / 2
local checkY = py + player.height / 2
local colliders = world:queryRectangleArea(checkX, checkY, checkW, checkH, {'Ground'})
return #colliders > 0
elseif not sprinting then
local px, py = player.collider:getPosition()
local checkW = player.width
local checkH = 10 --how many pixels to check below
local checkX = px - player.width / 2
local checkY = py + player.height / 2
local colliders = world:queryRectangleArea(checkX, checkY, checkW, checkH, {'Ground'})
return #colliders > 0
end
end
return player