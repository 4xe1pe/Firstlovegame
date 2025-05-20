local console = false
local M = {}
local width
local height
local font
local grandezzaschermo

function M.load(attiva)
-- codice per load
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
end
end

function M.draw()
-- codice per draw
if console == true then
love.graphics.print(player.position,cam.x -350, cam.y -32)
love.graphics.print(grandezzaschermo,cam.x -350, cam.y -52)
love.graphics.print(numerozoombie,cam.x -350, cam.y -72)
love.graphics.print(numerobullet,cam.x -350, cam.y -92)
end
end

return M