local M = {}
function M.load()
  sprites = {}
  sprites.background = love.graphics.newImage("sprites/alberi.png")
  sprites.background:setFilter("nearest", "nearest")
  sprites.trees = love.graphics.newImage("sprites/sangue.png")
  sprites.trees:setFilter("nearest", "nearest")
  sprites.bullet = love.graphics.newImage("sprites/bullet.png")
  sprites.player = love.graphics.newImage("sprites/player.png")
  sprites.player:setFilter("nearest", "nearest")
  sprites.zombie = love.graphics.newImage("sprites/zombie.png")
  sprites.zombie:setFilter("nearest", "nearest")
  sprites.pointer = love.graphics.newImage("sprites/pointer.png")
  sprites.pointer:setFilter("nearest", "nearest")
end

function M.draw(sprite, x,y, rot, sx, sy, ox,oy)
  
love.graphics.draw(sprite, x,y, rot, sx, sy, ox,oy)
end 

return M