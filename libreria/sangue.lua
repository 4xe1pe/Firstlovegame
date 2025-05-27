local m = {}
blodtrue = false
local texture = require("libreria/texture")
function m.load()
  texture.load()
    bloods = {}
    bluds = {}
end

function m.bloodspawn(bx,by)
  local blood = {}
  blood.x = bx
  blood.y = by
  blood.sangue = love.graphics.newParticleSystem(sprites.blood, 200)
  blood.sangue:setParticleLifetime(0.1,0.7)
  blood.sangue:setEmissionRate(60)
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
function m.playerbloodspawn(bx,by)
  local blud = {}
  blud.x = bx
  blud.y = by
  blud.sangue = love.graphics.newParticleSystem(sprites.blood, 15)
  blud.sangue:setParticleLifetime(0.1,0.7)
  blud.sangue:setEmissionRate(2)
  blud.sangue:setSizes(2)
  blud.sangue:setSizeVariation(1)
  blud.sangue:setSpeed(100, 300)
  blud.sangue:setSpread(math.rad(360))
  blud.sangue:setLinearAcceleration(0, 0)
  blud.sangue:setColors(1, 0, 0, 0.5, 1, 0, 0, 0)
  blud.sangue:setRotation(math.rad(-50), math.rad(-40))
  blud.sangue:emit(30)
  blud.sangue:stop()
  table.insert(bluds, blud)
end


function m.update(dt)
  for i,b in ipairs(bloods) do
  b.sangue:update(dt)
  end
  for i,u in ipairs(bluds) do
  u.sangue:update(dt)
  end
    for i = #bloods, 1, -1 do
        local b = bloods[i]
        b.sangue:update(dt)
        if b.sangue:getCount() == 0 then
            table.remove(bloods, i)
        end
    end

    for i = #bluds, 1, -1 do
        local u = bluds[i]
        u.sangue:update(dt)
        if u.sangue:getCount() == 0 then
            table.remove(bluds, i)
        end
    end
end

function m.draw()
 
  for i,b in ipairs(bloods) do
    love.graphics.draw(b.sangue, b.x, b.y)
  end
  for i,u in ipairs(bluds) do
    love.graphics.draw(u.sangue, u.x, u.y)
  end
end


return m