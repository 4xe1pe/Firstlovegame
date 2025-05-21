local console = false
local M = {}
local width
local height
local font
local grandezzaschermo
local wf = require("libreria/windfield")
function M.load(attiva)
-- codice per load

world = wf.newWorld(0,0)
console = attiva or false
width = love.graphics.getWidth()
height = love.graphics.getHeight()
font = love.graphics.newFont(18)
grandezzaschermo = "largo " .. width .. " alto " .. height
end

function M.update(dt)
-- codice per update
if console == true then
player.position = "X: " ..math.ceil(player.x).." Y: " ..math.ceil(player.y)
grandezzaschermo = "largo " .. width .. " alto " .. height
world:update(dt)
end
end

function M.draw()
-- codice per draw
if console == true then
love.graphics.print(player.position,cam.x -350, cam.y -32)
love.graphics.print(grandezzaschermo,cam.x -350, cam.y -52)
love.graphics.print(numerozoombie,cam.x -350, cam.y -72)
love.graphics.print(numerobullet,cam.x -350, cam.y -92)
world:draw()
end
end
function M.drew()
  if console == false then
  love.graphics.print("RS to move camera",10, 20)
  love.graphics.print("LS to move", 10 , 40)
  love.graphics.print("RB/R1 or LB/L1 to shoot",10,60)
  love.graphics.print("or both",10, 80)
  end
end



return M