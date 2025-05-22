local m = {}

local rain
local texture = require("libreria/texture")
function m.load()
  texture.load()
    -- Usa la tua texture esterna: linea bianca per la pioggia
    local rainImg = sprites.bullet

    -- Sistema particelle pioggia
    rain = love.graphics.newParticleSystem(rainImg, 500)
    rain:setParticleLifetime(1, 2)
    rain:setEmissionRate(200)
    rain:setSizeVariation(0.5)
    rain:setLinearAcceleration(-200, 400, -200, 400) -- pioggia diagonale da dx a sx
    rain:setAreaSpread("uniform", love.graphics.getWidth(), 0)
    rain:setDirection(math.rad(135))
    rain:setSpeed(400, 600)
    rain:setColors(1, 1, 1, 0.5, 1, 1, 1, 0)
    rain:setRotation(math.rad(-50), math.rad(-40))
end

function m.update(dt)
    if rain then
        rain:update(dt)
    end
end

function m.draw()
    if rain then
        love.graphics.draw(rain, love.graphics.getWidth() / 2, 0)
    end
end

return m