local M = {}
local player = {}
local world = {}
local zombie = {}
local sti
local gamemap
function M.load(prl, word,zmb)
  sti = require("libreria/sti")
gamemap = sti('mappa/mappa.lua')
  --windfield
  world = word
  --player
  player = prl
  player.x = prl.x
  player.y = prl.y
  player.collider = world:newCircleCollider(400,250,25)
  player.collider:setFixedRotation(true)
  --zombie
  zombie = zmb
  zombie.x = zmb.x
  zombie.y = zmb.y
  zombie.collider = world:newCircleCollider(400,250,25)
  zombie.collider:setFixedRotation(true)
  walls = {}
  local scale = 4
  if gamemap.layers["walls"] then
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
end

function M.draw()
  world:draw()
end

return M