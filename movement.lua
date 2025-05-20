local M = {}
local move = false
local player = {}
local pointer = {}
local pointeri = false
function M.load(attiva,plr,pnt)
  move = attiva or false
  if move == true then
  --player
  player = plr
  --joystick
  joysticks = love.joystick.getJoysticks()
  joystick = joysticks[1]
  -- pointer
  pointer = pnt
  pointeri = true
  --camera
  camera = require"libreria/camera"
  cam = camera.new()
  end
end

function M.update(dt)
  if move == true then
  player.x = player.x + joystick:getGamepadAxis("leftx") * player.speed * dt
  player.y = player.y + joystick:getGamepadAxis("lefty") * player.speed * dt
  end

  local bw = sprites.background:getWidth()
  local bh = sprites.background:getHeight()
  
if player.x < bw - bw then
    player.x = bw - bw
end
if player.y < bh - bh then 
    player.y = bh - bh
end
if player.x > bw then
    player.x = bw
end
if player.y > bh then
    player.y = bh
end

if move == true and pointeri == true then
    pointer.x = pointer.x + joystick:getGamepadAxis("rightx") * pointer.speed * dt
    pointer.y = pointer.y + joystick:getGamepadAxis("righty") * pointer.speed * dt
end
local sw = love.graphics.getWidth()
local sh = love.graphics.getHeight()
if pointer.x < 0 then 
  pointer.x = 0
end
if pointer.y < 0 then 
  pointer.y = 0
end
if pointer.x >  sw - 40 then
  pointer.x = sw - 40
end
if pointer.y > sh - 40 then
  pointer.y =  sh - 40
end

end

function M.draw()
end

return M