local M = {}
local player = {}
local world = {}
local zombie = {}
local sti
local gamemap
function M.load(prl, word)
  sti = require("libreria/sti")
gamemap = sti('mappa/mappa.lua')
  --windfield
  world = word
  --player
  player = prl
  player.x = prl.x
  player.y = prl.y
  player.collider = world:newCircleCollider(love.graphics.getWidth()-50, love.graphics.getHeight(),25)
  player.collider:setFixedRotation(true)
  --zombie
  zombies = {}

  walls = {}
  local scale = 4
  if gamemap.layers["wlls"] then
    for i,obj in pairs(gamemap.layers["walls"].objects) do
      wall = world:newRectangleCollider(obj.x*scale,obj.y*scale,obj.width*scale,obj.height*scale)
      wall:setType("static")
      table.insert(walls,wall)
    end
  end
end

function M.update(dt)
world:update(dt)
player.x = player.collider:getX()
player.y = player.collider:getY()
    
  for _, z in ipairs(zombies) do
      z.x = z.collider:getX()
      z.y = z.collider:getY()
  end
end

function M.draw()
  world:draw()
end

function zombiespawn()
local zombie = {}
zombie.x = 0
zombie.y = 0
zombie.speed = 140
zombie.death = false
zombie.collider = world:newCircleCollider(zombie.x,zombie.y,25)
zombie.collider:setFixedRotation(true)
--zombie.collider:setType("static")
local side = math.random(1,4)
if side == 1 then
zombie.x = math.random(0, -40)
zombie.y = math.random(0,bh)
elseif side == 2 then
zombie.x = math.random(0,bw)
zombie.y = math.random(0, -40)
elseif side == 3 then
zombie.x = math.random(bw,bw + 40)
zombie.y = math.random(0, bh)
elseif side == 4 then
zombie.x = math.random(0, bw)
zombie.y = math.random(bh,bh + 40)
end
table.insert(zombies, zombie)
end

return M