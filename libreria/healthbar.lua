local M = {}
global = {}
global.player = {}

function M.load()
    global.player.max_health = 100
    global.player.health = 100
end

function M.update(dt)
    local new_health = math.min(global.player.health, global.player.max_health)
    global.player.health = new_health
end

function M.draw()
  
    local c = global.player.health / global.player.max_health
    local color = {2 - 2 * c, 2 * c, 0}
    love.graphics.setColor(color)
    love.graphics.print('Health: ' .. math.floor(global.player.health), 10, 5)
    love.graphics.rectangle('fill', 10, 1.5 * 22, global.player.health, 20 / 2)
    love.graphics.setColor(0, 0, 0)
    love.graphics.rectangle('line', 10, 1.5 * 22, global.player.max_health, 20 / 2)
    love.graphics.setColor(1, 1, 1)
end

function M.damage(amount)
    global.player.health = math.max(global.player.health - amount, 0)
end

function M.getHealth()
    return global.player.health
end

return M