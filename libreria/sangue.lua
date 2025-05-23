local m = {}
blodtrue = false
local blood
local texture = require("libreria/texture")
function m.load()
  texture.load()
    bloods = {}
end

function m.bloodspawn(bx,by)
  local blood = {}
  blood.x = bx
  blood.y = by
  blood.sangue = love.graphics.newParticleSystem(sprites.blood, 200)
  blood.sangue:setParticleLifetime(0.1,0.7)
  blood.sangue:setEmissionRate(30)
  blood.sangue:setSizes(2)
  blood.sangue:setSizeVariation(1)
  blood.sangue:setSpeed(100, 300)
  blood.sangue:setSpread(math.rad(360))
  blood.sangue:setLinearAcceleration(0, 0)
  blood.sangue:setColors(1, 0, 0, 0.5, 1, 0, 0, 0)
  blood.sangue:setRotation(math.rad(-50), math.rad(-40))
  blood.sangue:emit(30)
  blood.sangue:stop()
  table.insert(bloods, blood)
end


function m.update(dt)
  for i,b in ipairs(bloods) do
  b.sangue:update(dt)
  end
end

function m.draw()
 
  for i,b in ipairs(bloods) do
    local scale = math.random(0.5,2)
--  love.graphics.push()
  --love.graphics.scale(scale)
    love.graphics.draw(b.sangue, b.x, b.y)
    b.sangue:stop()
--  love.graphics.pop()
  end
end


return m