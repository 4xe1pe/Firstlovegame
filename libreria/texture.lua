local M = {}
function M.load()
  love.graphics.setDefaultFilter("nearest", "nearest")
  sprites = {}
  sprites.background = love.graphics.newImage("sprites/alberi.png")
  sprites.trees = love.graphics.newImage("sprites/sangue.png")
  sprites.bullet = love.graphics.newImage("sprites/bullet.png")
  sprites.pointer = love.graphics.newImage("sprites/pointer.png")
  sprites.player = love.graphics.newImage("sprites/player.png")
  sprites.zombies = love.graphics.newImage("sprites/zombie.png")
end

function M.draw(sprite, x,y, rot, sx, sy, ox,oy)
  
love.graphics.draw(sprite, x,y, rot, sx, sy, ox,oy)
end 

return M