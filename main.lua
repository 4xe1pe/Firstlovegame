local console = require("console")
local movement = require("movement")
local joysticks = {}
function love.load()
  math.randomseed(os.time())
  love.window.setMode(1600, 720, { resizable = false, vsync = true, fullscreen = true })
  
  --camerau
  camera = require"libreria/camera"
  cam = camera.new()
  
  --mappa
  sti = require"libreria/sti"
  gamemap = sti("maps/mappa.lua")
  
  --roba per immagini
  sprites = {}
  sprites.background = love.graphics.newImage("sprites/background.png")
  sprites.bullet = love.graphics.newImage("sprites/bullet.png")
  sprites.player = love.graphics.newImage("sprites/player.png")
  sprites.player:setFilter("nearest", "nearest")
  sprites.zombie = love.graphics.newImage("sprites/zombie.png")
  sprites.zombie:setFilter("nearest", "nearest")
  sprites.pointer = love.graphics.newImage("sprites/pointer.png")
  sprites.pointer:setFilter("nearest", "nearest")
  sprites.playernoarm= love.graphics.newImage("sprites/playernoarm.png")
  sprites.playernoarm:setFilter("nearest", "nearest")
  sprites.arm = love.graphics.newImage("sprites/arm.png")
  sprites.arm:setFilter("nearest", "nearest")
  --zombie 
  zombies = {}
  --proiettile
  bullets = {}
  
  
  --roba puntatore e player
  pointer = {}
  pointer.x = 200
  pointer.y = 200
  pointer.speed = 700

  
  player = {}
  player.x = love.graphics.getWidth() / 2
  player.y = love.graphics.getHeight() / 2
  player.speed = 170
  movement.load(true, player,pointer)


  --roba per lo schermo
  start = love.graphics.newFont(30)
  --roba per controller
  joysticks = love.joystick.getJoysticks()
  joystick = joysticks[1]
  
  -- settings
  console.load(true)
  gamestate = 1
  maxtime = 2
  timer = maxtime
  score = 0
  font = love.graphics.newFont(18)
end

function love.update(dt)
  --cam movement
  cam:lookAt(player.x,player.y)
  --player movement
  if gamestate == 2  then
  movement.update(dt)
  end 
  --zombie movement
  for i,z in ipairs(zombies) do
    z.x = z.x + math.cos( zombierot(z) ) * z.speed * dt
    z.y = z.y + math.sin( zombierot(z) ) * z.speed * dt
    if distancebtwn(z.x,z.y,player.x,player.y) < 15 then
        for i,z in ipairs(zombies) do
          zombies[i] = nil
          gamestate = 1
          player.x = love.graphics.getWidth()/2
          player.y = love.graphics.getHeight()/2
        end
      end
    end

    --bullet movement
  for i,b in ipairs(bullets) do
    b.x = b.x + math.cos( b.direction ) * b.speed * dt
    b.y = b.y + math.sin( b.direction ) * b.speed * dt
  end
  for i=#bullets, 1, -1 do 
    local b = bullets[i]
    if b.x < 0 or b.y < 0 or b.x > love.graphics.getWidth() or b.y > love.graphics.getHeight() then
      table.remove(bullets, i)
    end
  end
  
  for i,z in ipairs(zombies) do
    for j,b in ipairs(bullets) do
      if distancebtwn(z.x,z.y,b.x,b.y) < 15 then
        z.death = true
        b.death = true
        score = score + 1
      end
    end
  end
  for i=#zombies,1,-1 do
    local z = zombies[i]
    if z.death == true then
      table.remove(zombies, i)
    end
  end
  for i=#bullets,1,-1 do
    local b = bullets[i]
    if b.death == true then
      table.remove(bullets, i)
    end
  end

  if gamestate == 2 then
    timer = timer - dt
    if timer <= 0 then
      zombiespawn()
      maxtime = 0.95 ^ maxtime
      timer = maxtime
    end
  end
-- console
console.update(dt)
  --proiettili a schermo
  numerobullet = ("numero bullets: " .. tostring(#bullets))
  numerozoombie = ("numero zombie: " .. tostring(#zombies))

end
function love.gamepadpressed(joystick, button)
    if button == "a" and gamestate == 1 then
      gamestate = 2
      maxtime = 2
      timer = maxtime
      score = 0
      player.x = love.graphics.getWidth()/2
      player.y = love.graphics.getHeight()/2
      
      
    end
    if button == "rightshoulder" and gamestate == 2 then
      bulletspawn()
    end
end

  
function love.draw()
  cam:attach()
    gamemap:drawLayer("Tile 1")
    gamemap:drawLayer("altr")
    gamemap:drawLayer("sangue")
    if gamestate == 1 then
      love.graphics.setFont(start)
      love.graphics.printf("schiaccia X per cominciare",0, 70, love.graphics.getWidth(), "center")
      end
    love.graphics.setFont(font)
    love.graphics.printf("punti: " ..score, 0, 50, love.graphics.getWidth(), "center")
   console.draw()
  
   if gamestate == 2 then
    love.graphics.draw(sprites.pointer,pointer.x, pointer.y)
   end
  
    for i,z in ipairs(zombies) do
      love.graphics.draw(sprites.zombie, z.x, z.y, zombierot(z), nil, nil, sprites.zombie:getWidth()/2, sprites.zombie:getHeight()/2)
    end
    for i,b in ipairs(bullets) do
      love.graphics.draw(sprites.bullet, b.x, b.y, rotazioneplayer(), nil, nil, sprites.bullet:getWidth()/2,-14)
    end
    love.graphics.draw(sprites.player, player.x, player.y, rotazioneplayer(), nil, nil, sprites.player:getWidth()/2, sprites.player:getHeight()/2)
  cam:detach()
end


function rotazioneplayer ()
  return math.atan2(pointer.y - player.y, pointer.x - player.x)
end

function zombierot(enemy)
  return math.atan2(player.y - enemy.y, player.x - enemy.x)
end

function zombiespawn()
  local zombie = {}
  zombie.x = 0
  zombie.y = 0
  zombie.speed = 140
  zombie.death = false
  table.insert(zombies, zombie)
  local side = math.random(1,4)
  if side == 1 then
    zombie.x = math.random(0, -40)
    zombie.y = math.random(0, love.graphics.getHeight())
  elseif  side == 2 then
    zombie.x = math.random(0, love.graphics.getWidth())
    zombie.y = math.random(0, -40)
  elseif  side == 3 then
    zombie.x = math.random(love.graphics.getWidth(),love.graphics.getWidth() + 40 )
    zombie.y = math.random(0, love.graphics.getHeight())
  elseif side == 4 then
    zombie.x = math.random(0, love.graphics.getWidth())
    zombie.y = math.random(love.graphics.getHeight(),love.graphics.getHeight() + 40)
  end
end

function armo()
  local arms = {}
  arm.x = player.x
  arm.y = player.y
  table.insert(arm, arms)
end

function bulletspawn()
  local bullet = {}
  bullet.x = player.x
  bullet.y = player.y
  bullet.speed = 1000
  bullet.death = false
  bullet.direction = rotazioneplayer()
  table.insert(bullets, bullet)
end

function distancebtwn(x1,y1,x2,y2)
  return math.sqrt((x2-x1)^2 + (y2-y1)^2)
end