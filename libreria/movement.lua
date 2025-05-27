local M = {}
local move = false
local player = {}
local pointer = {}
local zombie = {}
local pointeri = false
local collision = require("libreria/collisioni")
local healthbar = require("libreria/healthbar")
function M.load(attiva,plr,pnt,wrld)
  zombie = zmb
  move = attiva or false
  if move == true then
  world = wrld
  --player
  player = plr
  healthbar.gethealth()
  collision.load(player,world,zombie)
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
  collision.update(dt)
  local vx = 0
  local vy = 0
  if move == true then
  vx = vx + joystick:getGamepadAxis("leftx") * player.speed * dt
  vy = vy + joystick:getGamepadAxis("lefty") * player.speed * dt
  local x = player.collider:getPosition()
  local y = player.collider:getPosition()
  local bw = sprites.background:getWidth()
  local bh = sprites.background:getHeight()
  player.collider:setLinearVelocity(vx,vy)
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