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
player.acceleration = 800
player.friction = 500
--player.gravity = 900
player.jumpVelocity = 700
player.isMoving = false
player.facing = "right"

--player animation
player.spritesheet = love.graphics.newImage("assets/individual_sheets/male_hero_template.png")
player.grid = anim8.newGrid(128, 128, player.spritesheet:getWidth(), player.spritesheet:getHeight())
player.animations = {}
player.animations.idle = anim8.newAnimation(player.grid("1-10", 2), 0.2)
player.animations.walk = anim8.newAnimation(player.grid("1-10", 3), 0.1)
player.animations.run = anim8.newAnimation(player.grid("1-10", 4), 0.1)
player.animations.jump = anim8.newAnimation(player.grid("1-6", 5), 0.2)
player.animations.fall = anim8.newAnimation(player.grid("1-4", 6), 0.2)

player.anim = player.animations.idle
  

function player:update(dt)
    player:move(dt)
    player.anim:update(dt)
    player.x, player.y = player.collider:getPosition()
    print("contactCounter:", player.contactCounter)
end

function player:move(dt)
    --get first connected gamepad
    local gamepads = love.joystick.getJoysticks()
    local gamepad = gamepads[1]

    --sprinting lshift or left trigger
    local sprinting = love.keyboard.isDown("lshift") or (gamepad and gamepad:getGamepadAxis("triggerleft") > 0.5)
    if sprinting then
        player.maxspeed = 200 
        player.acceleration = 1000
    else
        player.maxspeed = 100
        player.acceleration = 800
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
        player.anim = sprinting and player.animations.run or player.animations.walk
    elseif right then
        player.xvel = math.min(player.xvel + player.acceleration * dt, player.maxspeed)
        player.isMoving = true
        player.facing = "right"
        player.anim = sprinting and player.animations.run or player.animations.walk
    else
        -- Apply friction when no key is pressed
        if player.xvel > 0 then
            player.xvel = math.max(player.xvel - player.friction * dt, 0)
        elseif player.xvel < 0 then
            player.xvel = math.min(player.xvel + player.friction * dt, 0)
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
end


function player:draw()
    local sx = player.facing == "left" and -1 or 1
    player.anim:draw(player.spritesheet, player.x, player.y, nil, sx, 1, 64, 64)
end

function player:jump()
    if player:isOnGround() then
    player.xvel, player.yvel = player.collider:getLinearVelocity()
    player.collider:setLinearVelocity(player.xvel, 0)
    player.collider:applyLinearImpulse(0, -player.jumpVelocity)
    player.isMoving = true
    end
end

function player:isOnGround()
local px, py = player.collider:getPosition()
local checkW = player.width
local checkH = 10--how many pixels to check below
local checkX = px - player.width / 2
local checkY = py + player.height / 2

local colliders = world:queryRectangleArea(checkX, checkY, checkW, checkH, {'Ground'})
return #colliders > 0
end

return player