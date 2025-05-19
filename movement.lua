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
  end
end

function M.update(dt)
  if move == true then
  player.x = player.x + joystick:getGamepadAxis("leftx") * player.speed * dt
  player.y = player.y + joystick:getGamepadAxis("lefty") * player.speed * dt
  end
  if player.x <= 0 then
    player.x = 0
elseif player.y <= 0 then 
    player.y = 0
elseif player.x >= love.graphics.getWidth() then
    player.x = love.graphics.getWidth()
elseif player.y >= love.graphics.getHeight() then
    player.y = love.graphics.getHeight()
end

if move == true and pointeri == true then
    pointer.x = pointer.x + joystick:getGamepadAxis("rightx") * pointer.speed * dt
    pointer.y = pointer.y + joystick:getGamepadAxis("righty") * pointer.speed * dt
  end
  
if pointer.x <= 0 then
  pointer.x = 0
elseif pointer.y <= 0 then 
  pointer.y = 0
elseif pointer.x >= love.graphics.getWidth() - 40 then 
  pointer.x = love.graphics.getWidth() - 40
elseif pointer.y >= love.graphics.getHeight() - 40 then
  pointer.y = love.graphics.getHeight() - 40
end
end

function M.draw()
end

return M