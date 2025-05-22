local console = require("libreria/console")
local movement = require("libreria/movement")
local texture = require("libreria/texture")
local joysticks = {}
function love.load()
  math.randomseed(os.time())
  love.window.setMode(1600, 720, { resizable = false, vsync = true, fullscreen = true })
  --anim8
  anim8 = require("libreria/anim8")
  --map
  sti = require("libreria/sti")
  gamemap = sti('mappa/mappa.lua')
  --camera
  camera = require"libreria/camera"
  cam = camera.new()
  --roba per immagini
  texture.load()
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
  player.spriteSheet = love.graphics.newImage("sprites/playerwalk.png")
  player.x = 360
  player.y = 152
  player.speed = 170
  player.grid = anim8.newGrid(35,45,player.spriteSheet:getWidth(), player.spriteSheet:getHeight())
  movement.load(true, player,pointer)
  player.animation = anim8.newAnimation(player.grid('1-3', 1), 0.2)
  player.anim = player.animation
  player.health = 100

  --roba per lo schermo
  start = love.graphics.newFont(30)
  bw = sprites.background:getWidth()
  bh = sprites.background:getHeight()
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
  --world:update(dt)
  --cam movement
  cam:lookAt(player.x,player.y)
  local w = love.graphics.getWidth()
  local h = love.graphics.getHeight()
  
  if cam.x < w/2 then 
    cam.x = w/2
  end
  if cam.y < h/2 then
    cam.y = h/2
  end
  
  if cam.x > (bw - w/2) then
    cam.x = (bw - w/2)
  end
  if cam.y > (bh - h/2) then
    cam.y = (bh - h/2)
  end
  
  
  --player movement
  player.animation:update(dt)
  for _, z in ipairs(zombies) do
  if z.animation then
    z.animation:update(dt)
  end
end
  local LsX = joystick:getGamepadAxis("leftx")
  local Lsy = joystick:getGamepadAxis("lefty")
  
  if LsX <= -0.2 or LsX >= 0.2 or Lsy <= -0.2 or Lsy >= 0.2 then
        player.anim = player.animation
    elseif LsX == 0 or Lsy == 0 then
        player.anim:gotoFrame(2)
    end
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
          player.health = player.health - 5
        if distancebtwn(z.x,z.y,player.x,player.y) < 15 and player.health <= 10 then
          gamestate = 1
          zombies[i] = nil
          player.x = love.graphics.getWidth()/2
          player.y = love.graphics.getHeight()/2
          
        end
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
    if b.x < bw-bh or b.y < bh-bh or b.x > bw or b.y > bh then
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
      player.health = 100
      gamestate = 2
      maxtime = 2
      timer = maxtime
      score = 0
      player.x = love.graphics.getWidth()/2
      player.y = love.graphics.getHeight()/2
      
      
    end
    if button == "rightshoulder" and gamestate == 2 then
      bullets.randomico = 1
      bulletspawn()
    end
    if button == "leftshoulder" and gamestate == 2 then
      bullets.randomico = 2
      bulletspawn()
    end
end

  
function love.draw()
  cam:attach()
  local scale = 4
  love.graphics.push()
  love.graphics.scale(scale)
    gamemap:drawLayer(gamemap.layers["Tile 1"])
    gamemap:drawLayer(gamemap.layers["sangue"])
  love.graphics.pop()
  -- texture.draw(sprites.background,0,0,nil)
    player.animation:draw(player.spriteSheet, player.x, player.y, rotazioneplayer(), nil, nil, sprites.player:getWidth()/2, sprites.player:getHeight()/2)
    love.graphics.setColor(1,1,1,1)
    for i,z in ipairs(zombies) do
      z.animation:draw(z.spriteSheet, z.x, z.y, zombierot(z), nil, nil, sprites.zombie:getWidth()/2, sprites.zombie:getHeight()/2)
    end
    for i,b in ipairs(bullets) do
      if bullets.randomico == 1 then
      texture.draw(sprites.bullet, b.x, b.y, rotazioneplayer(), nil, nil, sprites.bullet:getWidth()/2,-14)
      end
      if bullets.randomico == 2 then
      texture.draw(sprites.bullet, b.x, b.y, rotazioneplayer(), nil, nil, sprites.bullet:getWidth()/2,14)
      end
    end
    love.graphics.setColor(1,1,1,0.5)
    love.graphics.push()
  love.graphics.scale(scale)
    gamemap:drawLayer(gamemap.layers["altr"])
    gamemap:drawLayer(gamemap.layers["Layer 4"])
  love.graphics.pop()
  love.graphics.setColor(1,1,1,1)
    if gamestate == 1 then
      love.graphics.setFont(start)
      love.graphics.printf("schiaccia X per cominciare",cam.x - 360, cam.y -92, love.graphics.getWidth(), "center")
      end
    love.graphics.setFont(font)
    love.graphics.printf("punti: " ..score, cam.x - 360, cam.y-122, love.graphics.getWidth(), "center")
   console.draw()
   cam:detach()
   console.drew()
  if gamestate == 2 then
    love.graphics.draw(sprites.pointer,pointer.x - 20, pointer.y)
   end
end


function rotazioneplayer ()
  local mx, my = cam:worldCoords(pointer.x, pointer.y)
  return math.atan2(my - player.y, mx - player.x)
end

function zombierot(enemy)
  return math.atan2(player.y - enemy.y, player.x - enemy.x)
end

function zombiespawn()
  local zombie = {}
 zombie.spriteSheet = love.graphics.newImage("sprites/zombwalk.png")
  zombie.grid = anim8.newGrid(35,45,zombie.spriteSheet:getWidth(), zombie.spriteSheet:getHeight())
  zombie.animation = anim8.newAnimation(zombie.grid('1-3', 1), 0.2)
  zombie.anim = zombie.animation
  zombie.x = 0
  zombie.y = 0
  zombie.speed = 140
  zombie.death = false
  table.insert(zombies, zombie)
  local side = math.random(1,4)
  if side == 1 then
    zombie.x = math.random(0, -40)
    zombie.y = math.random(0,bh)
  elseif  side == 2 then
    zombie.x = math.random(0,bw)
    zombie.y = math.random(0, -40)
  elseif  side == 3 then
    zombie.x = math.random(bw,bw + 40 )
    zombie.y = math.random(0, bh)
  elseif side == 4 then
    zombie.x = math.random(0, bw)
    zombie.y = math.random(bh,bh + 40)
  end
end


function bulletspawn()
  local bullet = {}
  bullet.randomico = 0
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