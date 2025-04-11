require "tetrominos"
require "tetroids"

local Button = require "rth_button2"
local menu_elements = {}
local base_elements = {}

local ONE_RAD = math.pi / 180

function love.load()
    love.graphics.setDefaultFilter("nearest", "nearest")

    math.randomseed(os.time())
    
    fontMenuNormal = love.graphics.newFont("fonts/normal.ttf", 20)
    fontMenuSmall = love.graphics.newFont("fonts/normal.ttf", 12)
    fontMoving = love.graphics.newFont("fonts/moving.ttf", 16)
    
    bgImg = love.graphics.newImage("gfx/background.png")
    shipImg = love.graphics.newImage("gfx/ship.png")
    tileImg = love.graphics.newImage("gfx/tile.png")
    shieldImg = love.graphics.newImage("gfx/shield.png")
    canisterImg = love.graphics.newImage("gfx/canister.png")
    weightImg = love.graphics.newImage("gfx/weight.png")
    moneyImg = love.graphics.newImage("gfx/money.png")
    frameSingleImg = love.graphics.newImage("gfx/frame_single.png")
    frameSegmentedImg = love.graphics.newImage("gfx/frame_segmented.png")
    frameFillImg = love.graphics.newImage("gfx/frame_fill.png")
    thrusterImg = love.graphics.newImage("gfx/thruster.png")
    explosionImg = love.graphics.newImage("gfx/explosion.png")
    
    thrusterFrames = {
        love.graphics.newQuad(0*16, 0, 16, 16, thrusterImg:getWidth(), thrusterImg:getHeight()),
        love.graphics.newQuad(1*16, 0, 16, 16, thrusterImg:getWidth(), thrusterImg:getHeight()),
        love.graphics.newQuad(2*16, 0, 16, 16, thrusterImg:getWidth(), thrusterImg:getHeight()),
        love.graphics.newQuad(3*16, 0, 16, 16, thrusterImg:getWidth(), thrusterImg:getHeight()),
        love.graphics.newQuad(4*16, 0, 16, 16, thrusterImg:getWidth(), thrusterImg:getHeight()),
        love.graphics.newQuad(5*16, 0, 16, 16, thrusterImg:getWidth(), thrusterImg:getHeight()),
    }
    
    explosionFrames = {
        love.graphics.newQuad(0*72, 0, 72, 72, explosionImg:getWidth(), explosionImg:getHeight()),
        love.graphics.newQuad(1*72, 0, 72, 72, explosionImg:getWidth(), explosionImg:getHeight()),
        love.graphics.newQuad(2*72, 0, 72, 72, explosionImg:getWidth(), explosionImg:getHeight()),
        love.graphics.newQuad(3*72, 0, 72, 72, explosionImg:getWidth(), explosionImg:getHeight()),
        love.graphics.newQuad(4*72, 0, 72, 72, explosionImg:getWidth(), explosionImg:getHeight()),
        love.graphics.newQuad(5*72, 0, 72, 72, explosionImg:getWidth(), explosionImg:getHeight()),
        love.graphics.newQuad(6*72, 0, 72, 72, explosionImg:getWidth(), explosionImg:getHeight()),
        love.graphics.newQuad(7*72, 0, 72, 72, explosionImg:getWidth(), explosionImg:getHeight()),
        love.graphics.newQuad(8*72, 0, 72, 72, explosionImg:getWidth(), explosionImg:getHeight()),
        love.graphics.newQuad(9*72, 0, 72, 72, explosionImg:getWidth(), explosionImg:getHeight()),
        love.graphics.newQuad(10*72, 0, 72, 72, explosionImg:getWidth(), explosionImg:getHeight()),
        love.graphics.newQuad(11*72, 0, 72, 72, explosionImg:getWidth(), explosionImg:getHeight()),
        love.graphics.newQuad(12*72, 0, 72, 72, explosionImg:getWidth(), explosionImg:getHeight()),
        love.graphics.newQuad(13*72, 0, 72, 72, explosionImg:getWidth(), explosionImg:getHeight()),
    }
    
    shipImgW2 = shipImg:getWidth() / 2
    shipImgH2 = shipImg:getHeight() / 2
    
    TILE_W = 24
    TILE_W2 = TILE_W/2
    TILE_H = 24
    TILE_H2 = TILE_H/2
    
    EXPLOSION_W2 = 72/2
    EXPLOSION_H2 = 72/2
    
    MAX_BAR_W = frameSingleImg:getWidth()
    MAX_BAR_H = frameSingleImg:getHeight()
    
    -- Menu
    
    table.insert(menu_elements, Button:new(love.graphics.getWidth()/2 - 200, 250, 400, 50, "NEW GAME", menuNewGame))
    table.insert(menu_elements, Button:new(love.graphics.getWidth()/2 - 200, 350, 400, 50, "SETTINGS", nil))
    table.insert(menu_elements, Button:new(love.graphics.getWidth()/2 - 200, 450, 400, 50, "QUIT", love.event.quit))
    menu_elements[1]:setFocusColor(1, 1, 0)
    menu_elements[2]:setFocusColor(1, 1, 0)
    menu_elements[3]:setFocusColor(1, 1, 0)
    menu_elements[1]:setFont(fontMenuNormal)
    menu_elements[2]:setFont(fontMenuNormal)
    menu_elements[3]:setFont(fontMenuNormal)
    menu_focus = 1
    menu_elements[menu_focus]:setFocus(true)
    
    logo = {
        {0,0},{1,0},{2,0}, {4,0},{5,0},{6,0}, {8,0},{9,0},{10,0}, {12,0},{13,0},        {16,0},{17,0},{18,0}, {20,0},{21,0},{22,0}, {24,0},{25,0},        {28,0},{29,0},{30,0},
              {1,1},       {4,1},                   {9,1},        {12,1},       {14,1}, {16,1},       {18,1},        {21,1},        {24,1},       {26,1}, {28,1},
              {1,2},       {4,2},{5,2},             {9,2},        {12,2},{13,2},        {16,2},       {18,2},        {21,2},        {24,2},       {26,2}, {28,2},{29,2},{30,2},
              {1,3},       {4,3},                   {9,3},        {12,3},       {14,3}, {16,3},       {18,3},        {21,3},        {24,3},       {26,3},               {30,3},
              {1,4},       {4,4},{5,4},{6,4},       {9,4},        {12,4},       {14,4}, {16,4},{17,4},{18,4}, {20,4},{21,4},{22,4}, {24,4},{25,4},        {28,4},{29,4},{30,4},
    }
    logo_colors = {}
    setLogoColors()
    
    LOGO_X = love.graphics.getWidth() / 2 - (31 * TILE_W) / 2
    LOGO_Y = TILE_H * 2
    
    -- Asteroids
    
    ship = {}
    
    SPEED = 300
    ACCEL = 5
    FRICTION = 0.7
    
    MAX_HULL = 100
    MAX_FUEL = 100
    MIN_WEIGHT = 54
    MAX_WEIGHT = 264
    
    shots = {}
    
    tetroids = {}
    
    TETROID_RADIUS = (5*TILE_W)/2
    TETROID_COLLISION_RADIUS = TETROID_RADIUS * 1.3
    TETROID_PIECE_RADIUS = TILE_W/2
    
    -- Tetris
    
    BOARD_W = 12
    BOARD_X = love.graphics.getWidth() / 2 - (BOARD_W*TILE_W) / 2 - TILE_W
    BOARD_H = 24
    
    board = {}
    
    currentTetromino = {
        id = 0,
        shape = 0,
        r = 0,
        c = 0,
    } 
    
    TETRIS_SPEED = 50
    
    -- Base
    
    base = {
        x = love.graphics.getWidth() / 2,
        y = love.graphics.getHeight() - shipImgW2*2,
        radius = shipImgW2*2,
    }
    
    table.insert(base_elements, Button:new(25*TILE_W, 3*TILE_H, 100, 30, "$ 100", repairHull))
    table.insert(base_elements, Button:new(25*TILE_W, 5*TILE_H, 100, 30, "$ 100", tankFuel))
    base_elements[1]:setFocusColor(1, 1, 0)
    base_elements[2]:setFocusColor(1, 1, 0)
    base_elements[1]:setFont(fontMenuSmall)
    base_elements[2]:setFont(fontMenuSmall)
    base_focus = 1
    base_elements[menu_focus]:setFocus(true)
    
    linesToClear = {}
    removingLines = 0
    removingAngle = 0
    removingScale = 1 
    
    REMOVING_LINES_COUNTER_MAX = 30
    
    -- General
    
    currentFrame = 1
    
    explosions = {}
    movingTexts = {}
    
    money = 0
    
    SCENE_MENU = 1
    SCENE_ASTEROIDS = 2
    SCENE_TETRIS = 3
    SCENE_BASE = 4
    
    current_scene = SCENE_MENU
    next_scene = 0
    
    delayBeforeNextScene = 0
    delayAfterNextScene = 0
    
    drawDebugInfo = false
    paused = false
end

function reset()
    local count = #shots
    for i = 0,count do 
        shots[i] = nil
    end
    
    local count = #tetroids
    for i = 0,count do 
        tetroids[i] = nil
    end
    
    local count = #explosions
    for i = 0,count do 
        explosions[i] = nil
    end
    
    local count = #movingTexts
    for i = 0,count do 
        movingTexts[i] = nil
    end

    ship.radius = shipImgW2
    ship.x = love.graphics.getWidth() / 2
    ship.y = base.y - base.radius - ship.radius - 4
    ship.angle = -math.pi / 2
    ship.vx = 0
    ship.vy = 0
    ship.thrust = false
    ship.shootingFrame = 10
    ship.iframes = 0
    ship.hull = MAX_HULL
    ship.fuel = MAX_FUEL
    ship.weight = MIN_WEIGHT
    
    createTetroidBelt()
    
    resetBoard()
    
    money = 0
    
    currentFrame = 1
    
    -- testcase1()
    testcase2()
end

function resetBoard()
    board[1]  = {2,0,0,0,0,0,0,0,0,0,0,2}
    board[2]  = {2,0,0,0,0,0,0,0,0,0,0,2}
    board[3]  = {2,0,0,0,0,0,0,0,0,0,0,2}
    board[4]  = {2,0,0,0,0,0,0,0,0,0,0,2}
    board[5]  = {2,0,0,0,0,0,0,0,0,0,0,2}
    board[6]  = {2,0,0,0,0,0,0,0,0,0,0,2}
    board[7]  = {2,0,0,0,0,0,0,0,0,0,0,2}
    board[8]  = {2,0,0,0,0,0,0,0,0,0,0,2}
    board[9]  = {2,0,0,0,0,0,0,0,0,0,0,2}
    board[10] = {2,0,0,0,0,0,0,0,0,0,0,2}
    board[11] = {2,0,0,0,0,0,0,0,0,0,0,2}
    board[12] = {2,0,0,0,0,0,0,0,0,0,0,2}
    board[13] = {2,0,0,0,0,0,0,0,0,0,0,2}
    board[14] = {2,0,0,0,0,0,0,0,0,0,0,2}
    board[15] = {2,0,0,0,0,0,0,0,0,0,0,2}
    board[16] = {2,0,0,0,0,0,0,0,0,0,0,2}
    board[17] = {2,0,0,0,0,0,0,0,0,0,0,2}
    board[18] = {2,0,0,0,0,0,0,0,0,0,0,2}
    board[19] = {2,0,0,0,0,0,0,0,0,0,0,2}
    board[20] = {2,0,0,0,0,0,0,0,0,0,0,2}
    board[21] = {2,0,0,0,0,0,0,0,0,0,0,2}
    board[22] = {2,0,0,0,0,0,0,0,0,0,0,2}
    board[23] = {2,0,0,0,0,0,0,0,0,0,0,2}
    board[24] = {2,2,2,2,2,2,2,2,2,2,2,2}
end

function testcase1()
    board[23] = {2,1,1,1,1,1,1,1,1,1,1,2}
    board[24] = {2,2,2,2,2,2,2,2,2,2,2,2}
    calculateWeight()
end

function testcase2()
    board[20] = {2,1,1,1,1,1,1,1,1,1,1,2}
    board[21] = {2,1,1,1,0,1,1,0,1,1,1,2}
    board[22] = {2,1,1,1,1,1,1,1,1,1,1,2}
    board[23] = {2,1,1,1,1,1,1,1,1,1,1,2}
    board[24] = {2,2,2,2,2,2,2,2,2,2,2,2}
    calculateWeight()
end

function setLogoColors()
    for i=1,#logo,1 do
        cidx = math.random(1, 7)
        logo_colors[i] = {tetrominos[cidx].color.r, tetrominos[cidx].color.g, tetrominos[cidx].color.b}
    end
end

function changeScene(s, b, a)
    -- must be > 0 !
    delayBeforeNextScene = b
    delayAfterNextScene = a
    next_scene = s
end

function randomAngle()
    return ((math.random(0, 360) * math.pi) / 180)
end

function dist(x1, y1, x2, y2)
    return math.sqrt( (x2 - x1)^2 + (y2 - y1)^2 )
end

function checkDistance(x1, y1, x2, y2, d)
    if math.abs(x2 - x1) > d then return false end    -- too far in x
    if math.abs(y2 - y1) > d then return false end    -- too far in y
    return true
end

function checkCollisionC(x1, y1, r1, x2, y2, r2)
    local d = (x2 - x1)^2 + (y2 - y1)^2
    local r = (r1 + r2)^2
    if d < r then return true
    else return false end
end

function calculateWeight()
    local weight = 0
    for r = 1,BOARD_H,1 do
        for c = 1,BOARD_W,1 do
            if board[r][c] == 1 or board[r][c] == 2 then
                weight = weight + 1
            end
        end
    end
    ship.weight = weight
    print("WEIGHT: "..tostring(ship.weight))
end

function createTetroidBelt()
    for i=1,5,1 do
        local d = 0
        local x = 0
        local y = 0
        repeat
            x = math.random(0, love.graphics.getWidth())
            y = math.random(0, love.graphics.getHeight())
            d = dist(ship.x, ship.y, x, y)
        until d > 200
        table.insert(tetroids, createTetroid(x, y, math.random(LARGE_MIN, LARGE_MAX), 1))
    end
end

function createTetroid(x, y, id, shp)
    local t = {}
    
    t.x = x
    t.y = y
    
    t.vx = 100 * math.cos( randomAngle() )
    t.vy = 100 * math.sin( randomAngle() )
    
    t.a = (math.random() - 0.5) / 10
    t.cos_a = math.cos(t.a)
    t.sin_a = math.sin(t.a)
    t.rot = t.a
    
    t.id = id
    t.shape = shp
    
    t.points = {}
    local py = t.y - 2*TILE_H
    for r=1,5,1 do
        px = t.x - 2*TILE_W
        for c=1,5,1 do
            if tetroidTypes[t.id].shapes[t.shape][r][c] ~= 0 then
                table.insert(t.points, { x = px, y = py, empty = false })
            else
                table.insert(t.points, { x = px, y = py, empty = true })
            end
            px = px + TILE_W
        end
        py = py + TILE_H
    end
    
    t.alive = true 
    
    print("Add tetroid: "..tostring(id))
    -- print(": "..tostring(t.x)..","..tostring(t.y)..") ~ ("..tostring(t.vx)..","..tostring(t.vy)..") ~ "..tostring(t.a))
    
    return t
end

function createExplosion(posx, posy)
    table.insert(explosions, {
        x = posx,
        y = posy,
        frm = 1,
        alive = true,
    })
end

function moveTetroid(t, dt)
    t.x = t.x + t.vx * dt
    t.y = t.y + t.vy * dt
    t.rot = t.rot + t.a
    
    for _, p in ipairs(t.points) do
        p.x = p.x + t.vx * dt
        p.y = p.y + t.vy * dt

        p.x = p.x - t.x
        p.y = p.y - t.y
        local nx = p.x * t.cos_a - p.y * t.sin_a;
        local ny = p.x * t.sin_a + p.y * t.cos_a;
        p.x = nx + t.x
        p.y = ny + t.y
    end
    
    if t.x < 0 then 
        t.x = t.x + love.graphics.getWidth()
        for _, p in ipairs(t.points) do
            p.x = p.x + love.graphics.getWidth()
        end
    end
    if t.x > love.graphics.getWidth() then 
        t.x = t.x - love.graphics.getWidth()
        for _, p in ipairs(t.points) do
            p.x = p.x - love.graphics.getWidth()
        end
    end
    if t.y < 0 then 
        t.y = t.y + love.graphics.getHeight()
        for _, p in ipairs(t.points) do
            p.y = p.y + love.graphics.getHeight()
        end
    end
    if t.y > love.graphics.getHeight() then 
        t.y = t.y - love.graphics.getHeight()
        for _, p in ipairs(t.points) do
            p.y = p.y - love.graphics.getHeight()
        end
    end
end

function moveShip(dt)
    ship.vx = ship.vx - FRICTION * ship.vx * dt;
    ship.vy = ship.vy - FRICTION * ship.vy * dt;
    ship.x = ship.x + ship.vx
    ship.y = ship.y + ship.vy
    
    if ship.x < 0 then ship.x = love.graphics.getWidth() end
    if ship.x > love.graphics.getWidth() then ship.x = 0 end
    if ship.y < 0 then ship.y = love.graphics.getHeight() end
    if ship.y > love.graphics.getHeight() then ship.y = 0 end
    
    if ship.iframes > 0 then
        ship.iframes = ship.iframes - 1
    end
    
    if checkDistance(ship.x, ship.y, base.x, base.y, base.radius - 4) == true then
        checkFullLines(linesToClear)
        print("Lines to clear: "..tostring(#linesToClear))
        if #linesToClear > 0 then
            clearLines(linesToClear, 3)
            removingLines = REMOVING_LINES_COUNTER_MAX
            removingAngle = 0
            removingScale = 1
        end
        changeScene(SCENE_BASE, 10, 10)
    end
end

function processInputAsteroids(dt)
    if love.keyboard.isDown("left") then
        ship.angle = ship.angle - ONE_RAD * SPEED * dt
    end
    
    if love.keyboard.isDown("right") then
        ship.angle = ship.angle + ONE_RAD * SPEED * dt
    end
    
    if love.keyboard.isDown("up") then
        ship.vx = ship.vx + ACCEL * dt * math.cos(ship.angle)
        ship.vy = ship.vy + ACCEL * dt * math.sin(ship.angle)
        ship.fuel = ship.fuel - (0.02 * ship.weight / MIN_WEIGHT)
        ship.thrust = true
    else
        ship.thrust = false
    end
    
    if love.keyboard.isDown("space") then
        if ship.shootingFrame % 10 == 0 then
            table.insert(shots, {
                x = ship.x,
                y = ship.y,
                vx = SPEED*2 * math.cos(ship.angle),
                vy = SPEED*2 * math.sin(ship.angle),
                alive = true,
            })
        end
        ship.shootingFrame = ship.shootingFrame + 1
    else
        ship.shootingFrame = 10
    end
end

function processInputTetris(dt)
    if currentFrame % 4 == 0 then
        if love.keyboard.isDown("left") then
            if checkTetromino(currentTetromino.r, currentTetromino.c-1, currentTetromino.shape) == true then
                currentTetromino.c = currentTetromino.c - 1
            end
        end

        if love.keyboard.isDown("right") then
            if checkTetromino(currentTetromino.r, currentTetromino.c+1, currentTetromino.shape) == true then
                currentTetromino.c = currentTetromino.c + 1
            end
        end

        if love.keyboard.isDown("down") then
            if checkTetromino(currentTetromino.r+1, currentTetromino.c, currentTetromino.shape) == true then
                currentTetromino.r = currentTetromino.r + 1
            end
        end
    end
end

function respawnShip()
    ship.x = love.graphics.getWidth() / 2
    ship.y = base.y - base.radius - ship.radius - 4
    ship.angle = -math.pi / 2
    ship.vx = 0
    ship.vy = 0
    ship.shootingFrame = 10
    ship.radius = shipImgW2
    ship.iframes = 120
    ship.hull = ship.hull - 10
end

function checkShotCollisionWithTetroid(x, y, t)
    for _, p in ipairs(t.points) do
        if p.empty == false then
            if checkDistance(x, y, p.x, p.y, TETROID_PIECE_RADIUS) == true then
                return true
            end
        end
    end
    return false
end

function checkShipCollisionWithTetroid(t)
    for _, p in ipairs(t.points) do
        if p.empty == false then
            if checkCollisionC(ship.x, ship.y, ship.radius, p.x, p.y, TETROID_PIECE_RADIUS) == true then
                return true
            end
        end
    end
    return false
end

function processShots(dt)
    for _, shot in ipairs(shots) do
        shot.x = shot.x + shot.vx * dt
        shot.y = shot.y + shot.vy * dt
        
        -- is shot out of screen ?
        if shot.x < 0 or shot.x > love.graphics.getWidth() or shot.y < 0 or shot.y > love.graphics.getHeight() then
            shot.alive = false
        end
        
        -- check shot collision with testroids
        for _, t in ipairs(tetroids) do
            -- first: rough collision
            if checkDistance(shot.x, shot.y, t.x, t.y, TETROID_COLLISION_RADIUS) == true then
                -- second: fine collision
                if checkShotCollisionWithTetroid(shot.x, shot.y, t) == true then
                    if t.shape == 1 then 
                        money = money + 50
                        table.insert(movingTexts, { x = shot.x, y = shot.y, txt = "+ $50", timer = 50 })
                    elseif t.shape == 2 or t.shape == 3 then 
                        money = money + 30
                        table.insert(movingTexts, { x = shot.x, y = shot.y, txt = "+ $30", timer = 50 })
                    else 
                        money = money + 10
                        table.insert(movingTexts, { x = shot.x, y = shot.y, txt = "+ $10", timer = 50 })
                        createExplosion(t.x - EXPLOSION_W2, t.y - EXPLOSION_H2)
                    end
                    t.alive = false
                    shot.alive = false
                    break
                end
            end
        end 
    end
end

function getTetrominoFromTetroid(t)
    for r=1,5,1 do
        for c=1,5,1 do
            if tetroidTypes[t.id].shapes[t.shape][r][c] ~= 0 then
                return tetroidTypes[t.id].shapes[t.shape][r][c]
            end
        end
    end
    return 0
end

function processTetroids(dt)
    for _, t in ipairs(tetroids) do
        moveTetroid(t, dt)
        
        -- chect tetroid collision with ship
        if ship.iframes == 0 then
            -- first: rough collision
            if checkCollisionC(ship.x, ship.y, ship.radius, t.x, t.y, TETROID_COLLISION_RADIUS) == true then
                -- second: fine collision
                if checkShipCollisionWithTetroid(t) == true then
                    t.alive = false
                    if (t.shape >= 4) then
                        local id = getTetrominoFromTetroid(t)
                        assert(id >= 1 and id <= 7, "Invalid tetromino id ("..tostring(id)..")!")
                        currentTetromino.id = id
                        currentTetromino.shape = 0
                        currentTetromino.r = tetrominos[currentTetromino.id].startR
                        currentTetromino.c = tetrominos[currentTetromino.id].startC
                        changeScene(SCENE_TETRIS, 1, 30)
                    else
                        createExplosion(ship.x - EXPLOSION_W2, ship.y - EXPLOSION_H2)
                        respawnShip()
                    end
                end
            end
        end
    end
end

function cleanShots()
    -- remove dead shots
    for i=#shots,1,-1 do
        if shots[i].alive == false then
            table.remove(shots, i)
        end
    end
end

function cleanTetroids()
    -- remove dead tetroids & spawn smaller ones (if possible)
    local toBeAdded = {}
    for i=#tetroids,1,-1 do
        if tetroids[i].alive == false then
            if tetroids[i].shape == 1 then
                table.insert(toBeAdded, createTetroid(tetroids[i].x, tetroids[i].y, tetroids[i].id, 2))
                table.insert(toBeAdded, createTetroid(tetroids[i].x, tetroids[i].y, tetroids[i].id, 3))
            elseif tetroids[i].shape == 2 then
                table.insert(toBeAdded, createTetroid(tetroids[i].x, tetroids[i].y, tetroids[i].id, 4))
                table.insert(toBeAdded, createTetroid(tetroids[i].x, tetroids[i].y, tetroids[i].id, 5))
            elseif tetroids[i].shape == 3 then
                table.insert(toBeAdded, createTetroid(tetroids[i].x, tetroids[i].y, tetroids[i].id, 6))
                table.insert(toBeAdded, createTetroid(tetroids[i].x, tetroids[i].y, tetroids[i].id, 7))
            end
            table.remove(tetroids, i)
        end
    end

    for _, t in ipairs(toBeAdded) do
        table.insert(tetroids, t)
    end
end

function cleanExplosions()
    for i=#explosions,1,-1 do
        if explosions[i].alive == false then
            table.remove(explosions, i)
        end
    end
end

function checkTetromino(testR, testC, testShp)
    for r = 1,tetrominos[currentTetromino.id].h,1 do
        for c = 1,tetrominos[currentTetromino.id].w,1 do
            if tetrominos[currentTetromino.id].shapes[testShp+1][r][c] == 1 and board[testR+(r-1)][testC+(c-1)] ~= 0 then
                return false
            end
        end
    end
    return true
end

function setTetromino()
    print("SET: Current weight: "..tostring(ship.weight))
    for r = 1,tetrominos[currentTetromino.id].h,1 do
        for c = 1,tetrominos[currentTetromino.id].w,1 do
            if tetrominos[currentTetromino.id].shapes[currentTetromino.shape+1][r][c] == 1 then
                board[currentTetromino.r+(r-1)][currentTetromino.c+(c-1)] = 1
                ship.weight = ship.weight + 1
            end
        end
    end
    print("SET: New weight: "..tostring(ship.weight))
end

function checkFullLines(ltc)
    -- check full lines from top to bottom
    for line=1,23,1 do
        local full = true
        for c=2,11,1 do
            if board[line][c] == 0 then
                full = false
                break
            end
        end
        if full then
            table.insert(ltc, line)
        end
    end
end 

function clearLine(idx, val)
    print("Clear line: "..tostring(idx))
    for c=2,11,1 do
        board[idx][c] = val
    end
    if val == 0 then
        print("CLEAR: Current weight: "..tostring(ship.weight))
        ship.weight = ship.weight - 10
        print("CLEAR: New weight: "..tostring(ship.weight))
    end
end

function clearLines(ltc, val)
    print("Clear lines...")
    for _, line in ipairs(ltc) do
        clearLine(line, val)
    end
end

function moveLine(idxFrom, idxTo)
    -- print("Move line: "..tostring(idxFrom).." -> "..tostring(idxTo))
    for c=2,11,1 do
        board[idxTo][c] = board[idxFrom][c]
    end
end

function moveLines(ltc)
    print("Move lines...")
    for _, line in ipairs(ltc) do
        for l=line,2,-1 do
            moveLine(l-1, l)
        end
    end
end

function clearLinesToClear()
    local count = #linesToClear
    for i = 0,count do 
        linesToClear[i] = nil
    end 
end 

function processMovingTexts()
    for i, t in ipairs(movingTexts) do
        t.y = t.y - 1
        t.timer = t.timer - 1
        if t.timer == 0 then
            table.remove(movingTexts, i)
        end
    end
end

function processExplosions()
    for _, expl in ipairs(explosions) do
        if currentFrame % 2 == 0 then
            expl.frm = expl.frm + 1
            if expl.frm > #explosionFrames then
                expl.alive = false
            end
        end
    end
end

function love.update(dt)
    if paused then return end
    
    if delayBeforeNextScene > 0 then
        print("Wait for next scene...")
        delayBeforeNextScene = delayBeforeNextScene - 1
        if delayBeforeNextScene == 0 then
            assert(next_scene ~= 0, "Invalid scene ("..tostring(next_scene)..")!")
            if next_scene == SCENE_MENU then
                for _, e in ipairs(menu_elements) do
                    if e:typeName() == "button2" then
                        e.isHoover = false
                    end
                end
            end
            current_scene = next_scene
            next_scene = 0
        else
            return
        end
    end
    
    if delayBeforeNextScene == 0 and delayAfterNextScene > 0 then
        print("Wait after scene changed...")
        delayAfterNextScene = delayAfterNextScene - 1
        -- if delayAfterNextScene == 0 then
        -- end
        return
    end
    
    if current_scene == SCENE_MENU then
        if currentFrame % 10 == 0 then
            setLogoColors()
        end
    elseif current_scene == SCENE_ASTEROIDS then
        -- process
        processInputAsteroids(dt)
        moveShip(dt)
        processShots(dt)
        processTetroids(dt)
        processExplosions()
        processMovingTexts()
        -- clean
        cleanShots()
        cleanTetroids()
        cleanExplosions()
    elseif current_scene == SCENE_TETRIS then
        processInputTetris(dt)
        if currentFrame % TETRIS_SPEED == 0 then
            if checkTetromino(currentTetromino.r+1, currentTetromino.c, currentTetromino.shape) == true then
                currentTetromino.r = currentTetromino.r + 1
            else
                setTetromino()
                ship.iframes = 120
                ship.vx = 0
                ship.vy = 0
                changeScene(SCENE_ASTEROIDS, 30, 10)
            end
        end
    elseif current_scene == SCENE_BASE then
        if removingLines > 0 then
            if removingLines == REMOVING_LINES_COUNTER_MAX-1 then
                for _, line in ipairs(linesToClear) do
                    money = money + 100
                    table.insert(movingTexts, { x = BOARD_W*TILE_W+TILE_W2, y = (line-1)*TILE_H, txt = "+ $100", timer = 50 })
                end
            end
            removingLines = removingLines - 1
            removingAngle = removingAngle + (2*math.pi/30)
            removingScale = removingScale - (1/30)
            if removingLines == 0 then
                clearLines(linesToClear, 0)
                moveLines(linesToClear)
                clearLinesToClear()
            end
        end
        processMovingTexts()
    end
    
    currentFrame = currentFrame + 1
end

function drawCross(x, y, size)
    love.graphics.line(x-size, y, x+size, y)
    love.graphics.line(x, y-size, x, y+size)
end

function drawTetroid(t)
    love.graphics.push()
    love.graphics.translate(t.x, t.y)
    love.graphics.rotate(t.rot)
    
    for r=1,5,1 do
        for c=1,5,1 do
            local tid = tetroidTypes[t.id].shapes[t.shape][r][c]
            if tid > 0 then
                love.graphics.setColor(tetrominos[tid].color.r, tetrominos[tid].color.g, tetrominos[tid].color.b);
                love.graphics.draw(tileImg, -TETROID_RADIUS + ((c-1)*TILE_W), -TETROID_RADIUS + ((r-1)*TILE_H));
            end
        end
    end

    love.graphics.pop()
end

function drawShip()
    -- iframes blinking
    if ship.iframes > 0 then
        if ship.iframes % 6 == 0 then
            love.graphics.setColor(1, 1, 1)
        else
            love.graphics.setColor(0, 0, 0)
        end
    else
        love.graphics.setColor(1, 1, 1)
    end
    
    love.graphics.push()
    
    love.graphics.translate(ship.x, ship.y)

    love.graphics.push()
    love.graphics.rotate(ship.angle + math.pi*0.5)
    love.graphics.draw(shipImg, -shipImgW2, -shipImgH2)
    love.graphics.pop()
    
    love.graphics.rotate(ship.angle)
    if ship.thrust then
        love.graphics.setColor(1, 1, 0)
        love.graphics.draw(thrusterImg, thrusterFrames[(currentFrame % #thrusterFrames)+1], -shipImg:getWidth(), -8)
    end

    love.graphics.pop()
    
    if drawDebugInfo then
        love.graphics.setColor(1, 0, 0)
        drawCross(ship.x, ship.y, 10)
        love.graphics.circle("line", ship.x, ship.y, ship.radius)
    end
end

function drawShots()
    love.graphics.setColor(1, 1, 0)
    for _, shot in ipairs(shots) do
        love.graphics.rectangle("fill", shot.x - 1, shot.y - 1, 3, 3)
    end
end

function drawTetroids()
    love.graphics.setColor(0, 1, 1)
    for _, t in ipairs(tetroids) do
        drawTetroid(t)
        
        if drawDebugInfo then
            love.graphics.setColor(1, 1, 1)
            for _, p in ipairs(t.points) do
                drawCross(p.x, p.y, 3)
                if p.empty then
                    love.graphics.circle("line", p.x, p.y, TETROID_PIECE_RADIUS)
                else
                    love.graphics.circle("fill", p.x, p.y, TETROID_PIECE_RADIUS)
                end
            end
            love.graphics.setColor(1, 0, 0)
            drawCross(t.x, t.y, 7)
            love.graphics.circle("line", t.x, t.y, TETROID_COLLISION_RADIUS)
        end
    end
end

function drawBoard(posx, posy)
    for r = 3,BOARD_H,1 do
        for c = 1,BOARD_W,1 do
            if board[r][c] == 1 then
                -- placed tile
                love.graphics.setColor(1,1,1);
                love.graphics.draw(tileImg, posx + (c*TILE_W), posy + (r*TILE_H) - TILE_H)
            elseif board[r][c] == 2 then
                -- frame
                love.graphics.setColor(0.5,0.5,0.5);
                love.graphics.draw(tileImg, posx + (c*TILE_W), posy + (r*TILE_H) - TILE_H)
            elseif board[r][c] == 3 then
                -- animation
                love.graphics.setColor(1,1,1);
                love.graphics.draw(tileImg, posx + (c*TILE_W) + TILE_W2, posy + (r*TILE_H) - TILE_H + TILE_H2, removingAngle, removingScale, removingScale, TILE_W2, TILE_H2)
            else
                -- empty tile (grid)
                love.graphics.setColor(0.2,0.2,0.2);
                love.graphics.rectangle("line", posx + (c*TILE_W), posy + (r*TILE_H) - TILE_H, TILE_W, TILE_H)
            end
        end
    end
end

function coverTopOfBoard(posx, posy)
    -- Cover top side of visible part of board, so that parts of tetrominos rotated out of top edge are not visible
    love.graphics.setColor(0,0,0);
    love.graphics.rectangle("fill", posx + 1*TILE_W, posy, BOARD_W*TILE_W, 2*TILE_H)
end

function drawTetromino(posx, posy)
    love.graphics.setColor(tetrominos[currentTetromino.id].color.r, tetrominos[currentTetromino.id].color.g, tetrominos[currentTetromino.id].color.b);
    local tx = posx + ((currentTetromino.c-1)*TILE_W)
    local ty = posy + ((currentTetromino.r-1)*TILE_H) - TILE_H
    for r = 1,tetrominos[currentTetromino.id].h,1 do
        for c = 1,tetrominos[currentTetromino.id].w,1 do
            if tetrominos[currentTetromino.id].shapes[currentTetromino.shape+1][r][c] == 1 then
                love.graphics.draw(tileImg, tx + (c*TILE_W), ty + (r*TILE_H))
            end
            if drawDebugInfo == true then
                love.graphics.rectangle("fill", tx + (c*TILE_W) + TILE_W*0.5, ty + (r*TILE_H) + TILE_H*0.5, 2, 2)
            end
        end
    end
end

function drawBar(posx, posy, currentv, maxv, fc, ic, isSegmented)
    love.graphics.setColor(0.3, 0.3, 0.3)
    love.graphics.draw(frameFillImg, posx, posy+2, 0, MAX_BAR_W, 0.8)
    love.graphics.setColor(ic[1], ic[2], ic[3])
    love.graphics.draw(frameFillImg, posx, posy+2, 0, (currentv/maxv)*MAX_BAR_W, 0.8)
    love.graphics.setColor(fc[1], fc[2], fc[3])
    if isSegmented == true then
        love.graphics.draw(frameSegmentedImg, posx, posy)
    else
        love.graphics.draw(frameSingleImg, posx, posy)
    end
end

function drawHull(posx, posy)
    love.graphics.setColor(0, 1, 0)
    love.graphics.draw(shieldImg, posx, posy)
    drawBar(posx + shieldImg:getWidth() + 10, posy, ship.hull, MAX_HULL, {0.4,0.4,0.4}, {0,1,0}, true)
end

function drawFuel(posx, posy)
    love.graphics.setColor(0, 1, 1)
    love.graphics.draw(canisterImg, posx, posy)
    drawBar(posx + canisterImg:getWidth() + 10, posy, ship.fuel, MAX_FUEL, {0.4,0.4,0.4}, {0,1,1}, false)
end

function drawWeight(posx, posy)
    love.graphics.setColor(0.5, 0.5, 0.5)
    love.graphics.draw(weightImg, posx, posy)
    drawBar(posx + weightImg:getWidth() + 10, posy, ship.weight, MAX_WEIGHT, {0.4,0.4,0.4}, {1,0.5,0}, false)
end

function drawMovingTexts()
    love.graphics.setColor(1, 1, 1)
    love.graphics.setFont(fontMoving)
    for _, t in ipairs(movingTexts) do
        love.graphics.print(t.txt, t.x, t.y)
    end
end

function drawMoney(posx, posy)
    love.graphics.setColor(1, 1, 0)
    love.graphics.draw(moneyImg, posx, posy)
    love.graphics.setFont(fontMenuNormal)
    love.graphics.print(money, posx + moneyImg:getWidth() + 10, posy + moneyImg:getHeight()*0.5 - fontMenuNormal:getHeight()*0.5)
end

function drawExplosions()
    love.graphics.setColor(1, 1, 1)
    for _, expl in ipairs(explosions) do
        love.graphics.draw(explosionImg, explosionFrames[expl.frm], expl.x, expl.y)
    end
end

function love.draw()
    love.graphics.setColor(1,1,1)
    
    if current_scene == SCENE_MENU then
        -- logo
        for i, p in ipairs(logo) do
            love.graphics.setColor(logo_colors[i][1], logo_colors[i][2], logo_colors[i][3])
            love.graphics.draw(tileImg, LOGO_X + TILE_W * p[1], LOGO_Y + TILE_H * p[2])
        end
        -- ui
        for _, e in ipairs(menu_elements) do
            e:draw()
        end
        love.graphics.setColor(1,1,1)
        love.graphics.draw(shipImg, menu_elements[menu_focus].x - 10, menu_elements[menu_focus].y + 6, math.pi*0.5)
        love.graphics.draw(shipImg, menu_elements[menu_focus].x + menu_elements[menu_focus].w + 10, menu_elements[menu_focus].y + 6, math.pi*0.5, 1, -1)
    elseif current_scene == SCENE_ASTEROIDS then
        love.graphics.setColor(1,1,1)
        love.graphics.draw(bgImg, 0, 0)
        love.graphics.circle("fill", base.x, base.y, base.radius)
        drawShip()
        drawShots()
        drawTetroids()
        drawExplosions()
        drawHull(10, 10)
        drawFuel(10, 50)
        drawWeight(10, 90)
        drawMovingTexts()
        drawMoney(love.graphics.getWidth()*0.5, 10)
    elseif current_scene == SCENE_TETRIS then
        drawBoard(BOARD_X, 0)
        if delayBeforeNextScene == 0 then
            drawTetromino(BOARD_X, 0)
        end
        coverTopOfBoard(BOARD_X, 0)
    elseif current_scene == SCENE_BASE then
        drawBoard(0, TILE_H)
        coverTopOfBoard(0, 0)
        drawHull(14*TILE_W, 3*TILE_H)
        drawFuel(14*TILE_W, 5*TILE_H)
        -- ui
        for _, e in ipairs(base_elements) do
            e:draw()
        end
        drawMovingTexts()
        drawMoney(love.graphics.getWidth()*0.5, 10)
    elseif current_scene == 999 then
        -- debug: draw all large tetroids
        x = TILE_W
        y = TILE_H
        for i=LARGE_MIN,LARGE_MAX,1 do
            g = tetroidTypes[i].shapes[1]
            for r=1,5,1 do
                for c=1,5,1 do
                    local tid = g[r][c]
                    if tid > 0 then
                        love.graphics.setColor(tetrominos[tid].color.r, tetrominos[tid].color.g, tetrominos[tid].color.b);
                        love.graphics.draw(tileImg, x + (c-1)*TILE_W, y + (r-1)*TILE_H);
                    end
                end
            end
            x = x + TILE_W*6
            if x > love.graphics.getWidth() then
                x = TILE_W
                y = y + TILE_H*6
            end
        end
    end
    
    -- axes
    if drawDebugInfo then
        love.graphics.setColor(0, 1, 0)
        drawCross(love.graphics.getWidth()*0.5, love.graphics.getHeight()*0.5, love.graphics.getWidth())
    end
end

function love.keypressed(key, scancode, isrepeat)
    if key == "r" then
        reset()
    end
    
    if key == "p" then
        paused = not paused
    end
    
    if key == "d" then
        drawDebugInfo = not drawDebugInfo
    end
    
    if current_scene == SCENE_MENU then
        if key == "escape" then
            love.event.quit()
        end
        
        if key == "up" then
            print("MENU: up")
            menu_elements[menu_focus]:setFocus(false)
            if menu_focus > 1 then menu_focus = menu_focus - 1 end
            menu_elements[menu_focus]:setFocus(true)
        end
        
        if key == "down" then
            print("MENU: down")
            menu_elements[menu_focus]:setFocus(false)
            if menu_focus < #menu_elements then menu_focus = menu_focus + 1 end
            menu_elements[menu_focus]:setFocus(true)
        end
        
        if key == "return" then
            menu_elements[menu_focus]:doAction()
        end
    end

    if current_scene == SCENE_ASTEROIDS then
        if key == "escape" then
            changeScene(SCENE_MENU, 1, 1)
        end
    end

    if current_scene == SCENE_TETRIS then
        -- rotate
        if key == "space" then
            local nextShape = (currentTetromino.shape + 1) % #(tetrominos[currentTetromino.id].shapes)
            if checkTetromino(currentTetromino.r, currentTetromino.c, nextShape) == true then
                currentTetromino.shape = nextShape
            end
        end
    end

    if current_scene == SCENE_BASE then
        if removingLines == 0 then
            if key == "escape" then
                ship.iframes = 120
                ship.angle = -math.pi*0.5
                ship.x = love.graphics.getWidth()*0.5
                ship.y = base.y - base.radius - ship.radius - 4
                ship.vx = 0
                ship.vy = 0
                changeScene(SCENE_ASTEROIDS, 1, 30)
            end
            
            if key == "up" then
                base_elements[base_focus]:setFocus(false)
                if base_focus > 1 then base_focus = base_focus - 1 end
                base_elements[base_focus]:setFocus(true)
            end
            
            if key == "down" then
                base_elements[base_focus]:setFocus(false)
                if base_focus < #base_elements then base_focus = base_focus + 1 end
                base_elements[base_focus]:setFocus(true)
            end
            
            if key == "return" then
                base_elements[base_focus]:doAction()
            end
        end
    end
end

function love.mousepressed(x, y, button, istouch, presses)
    if current_scene == SCENE_MENU then
        for _, e in ipairs(menu_elements) do
            e:checkClick(x, y)
        end
    elseif current_scene == SCENE_BASE then
        for _, e in ipairs(base_elements) do
            e:checkClick(x, y)
        end
    end
end

function love.mousemoved(x, y, dx, dy, istouch)
    if current_scene == SCENE_MENU then
        for _, e in ipairs(menu_elements) do
            e:checkHoover(x, y)
        end
        for i, e in ipairs(menu_elements) do
            if e.isHoover then 
                e:setFocus(true)
                menu_focus = i
            else 
                e:setFocus(false) 
            end
        end
    elseif current_scene == SCENE_BASE then
        for _, e in ipairs(base_elements) do
            e:checkHoover(x, y)
        end
    end
end

function love.mousereleased(x, y, button, istouch, presses)
    if current_scene == SCENE_MENU then
        for _, e in ipairs(menu_elements) do
            e:reset()
        end
    elseif current_scene == SCENE_BASE then
        for _, e in ipairs(base_elements) do
            e:reset()
        end
    end
end

function menuNewGame()
    reset()
    changeScene(SCENE_ASTEROIDS, 20, 30)
end

function repairHull()
    money = money - 100
    table.insert(movingTexts, { x = 29*TILE_W + 10, y = 3*TILE_H, txt = "- $100", timer = 50 })
    if ship.hull < MAX_HULL then
        ship.hull = ship.hull + 10
        if ship.hull > MAX_HULL then
            ship.hull = MAX_HULL
        end
    end
end

function tankFuel()
    money = money - 100
    table.insert(movingTexts, { x = 29*TILE_W + 10, y = 5*TILE_H, txt = "- $100", timer = 50 })
    if ship.fuel < MAX_FUEL then
        ship.fuel = ship.fuel + 10
        if ship.fuel > MAX_FUEL then
            ship.fuel = MAX_FUEL
        end
    end
end
