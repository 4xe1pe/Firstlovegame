local M = {}

local anim8 = nil
local player = nil
local zombies = nil
local texture = require("libreria/texture")
local joysticks = {}

function M.load(playerObj, zombiesTable)
    --roba per controller
  joysticks = love.joystick.getJoysticks()
  joystick = joysticks[1]
  texture.load()
    anim8 = require("libreria/anim8")
    player = playerObj
    zombies = zombiesTable
    
    player.spriteSheet = love.graphics.newImage("sprites/playerwalk.png")
    player.grid = anim8.newGrid(35, 45, player.spriteSheet:getWidth(), player.spriteSheet:getHeight())
    player.animation = anim8.newAnimation(player.grid('1-4', 1), 0.2)
    player.anim = player.animation
    
    
    shotgun = {}
    shotgun.spriteSheet = love.graphics.newImage("sprites/playershotgun.png")
    shotgun.grid = anim8.newGrid(48, 43, shotgun.spriteSheet:getWidth(), shotgun.spriteSheet:getHeight())
    shotgun.animation = anim8.newAnimation(shotgun.grid('1-4', 1), 0.2)
    shotgun.anim = shotgun.animation
    shotgun.gun = false
    
  zombies.spriteSheet = love.graphics.newImage("sprites/zombwalk.png")
  zombies.grid = anim8.newGrid(35,45,zombies.spriteSheet:getWidth(), zombies.spriteSheet:getHeight())
  zombies.animation = anim8.newAnimation(zombies.grid('1-3', 1), 0.2)
  zombies.anim = zombies.animation
    
end

function M.update(dt)
  local LsX = joystick:getGamepadAxis("leftx")
  local Lsy = joystick:getGamepadAxis("lefty")
  if shotgun.gun == false then
  player.animation:update(dt)
    if LsX <= -0.2 or LsX >= 0.2 or Lsy <= -0.2 or Lsy >= 0.2 then
          player.anim = player.animation
      elseif LsX == 0 or Lsy == 0 then
          player.anim:gotoFrame(2)
      end
  end
  if shotgun.gun == true then
    shotgun.animation:update(dt)
    if LsX <= -0.2 or LsX >= 0.2 or Lsy <= -0.2 or Lsy >= 0.2 then
          shotgun.anim = shotgun.animation
      elseif LsX == 0 or Lsy == 0 then
          shotgun.anim:gotoFrame(2)
      end
  end
    
    
  for _, z in ipairs(zombies) do
  if z.animation then
    z.animation:update(dt)
  end
end
end

function M.playerdraw( px, py, rot, sx, sy, ox,oy)
  if shotgun.gun ==  false then
    player.animation:draw(player.spriteSheet, px, py, rot, nil, nil, ox, oy)
      love.graphics.setColor(1,1,1,1)
  end
  
  if shotgun.gun ==  true then
    shotgun.animation:draw(shotgun.spriteSheet, px, py, rot, nil, nil, ox, oy)
      love.graphics.setColor(1,1,1,1)
  end
    
    
end
function M.zombdraw()
  for i,z in ipairs(zombies) do
      z.animation:draw(z.spriteSheet, z.x, z.y, zombierot(z), nil, nil, sprites.zombie:getWidth()/2, sprites.zombie:getHeight()/2)
    end
end

return M