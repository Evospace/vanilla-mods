Balance_internal = {
    boiler_per_tick = 200
}

Balance = {
    boiler_per_tick = Balance_internal.boiler_per_tick,
    industrial_boiler_per_tick = Balance_internal.boiler_per_tick * 20 * 8,
    conveyor_ticks_per_item = { 12, 8, 6, 4, 3, 2, 1 }
}

function Balance.conveyor_ticks(level)
    local ticks = Balance.conveyor_ticks_per_item
    return ticks[math.min(level + 1, #ticks)]
end

function Balance.conveyor_per_minute(level)
    return math.floor(game.tick_rate * 60 / Balance.conveyor_ticks(level) + 0.5)
end