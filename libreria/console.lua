local console = false
local M = {}
local w
local h
local font
local grandezzaschermo
local wf = require("libreria/windfield")
function M.load(attiva)
-- codice per load
console = attiva or false
w = love.graphics.getWidth()
h = love.graphics.getHeight()
font = love.graphics.newFont(18)
grandezzaschermo = "largo " .. w .. " alto " .. h
end

function M.update(dt)
-- codice per update
if console == true then
player.position = "X: " ..math.ceil(player.x).." Y: " ..math.ceil(player.y)
grandezzaschermo = "largo " .. w .. " alto " .. h
end
end

function M.draw()
-- codice per draw
if console == true then
  local scale = 0.8
  love.graphics.push()
  love.graphics.scale(scale)
  love.graphics.print(player.position,10,80)
  love.graphics.print(grandezzaschermo,10,100)
  love.graphics.print(numerozoombie,10, 120)
  love.graphics.print(numerobullet,10, 140)
  love.graphics.pop()
end
end
function M.drew()
  if console == false then
  local scale = 0.8
  love.graphics.push()
  love.graphics.scale(scale)
  love.graphics.print("RS to move camera",10, h-60)
  love.graphics.print("LS to move", 10 , h-40)
  love.graphics.print("RB/R1 or LB/L1 to shoot",10,h-20)
  love.graphics.print("or both",10, h )
  --love.graphics.print(player.health,10, 10)
  love.graphics.pop()
  end
end



return M