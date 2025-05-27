local M = {}
local state = {}

function M.load(plr)
    state.player = plr
    state.player.max_health = 100
    state.player.health = 100
end

function M.update(dt)
    if not state.player or not state.player.health then return end
    local new_health = math.min(state.player.health, state.player.max_health)
    state.player.health = new_health
end

function M.draw()
    if not state.player then return end
    local c = state.player.health / state.player.max_health
    local color = {2 - 2 * c, 2 * c, 0}
    love.graphics.setColor(color)
    love.graphics.print('health: ' .. math.floor(state.player.health), 10, 5)
    love.graphics.rectangle('fill', 10, 1.5 * 22, state.player.health, 20 / 2)
    love.graphics.setColor(0, 0, 0)
    love.graphics.rectangle('line', 10, 1.5 * 22, state.player.max_health, 20 / 2)
    love.graphics.setColor(1, 1, 1)
end

function M.damage(amount)
    if state.player then
        state.player.health = math.max(state.player.health - amount, 0)
    end
end

function M.gethealth()
    return state.player and state.player.health or 0
end

function M.setHealth(value)
    if state.player then
        state.player.health = math.max(0, math.min(value, state.player.max_health))
    end
end

return M