local Vlib = require('@VanillaLib')

local function describe(name, ticks)
    local item = StaticItem.find(name)
    if item == nil then
        return
    end
    local per_minute = math.floor(game.tick_rate * 60 / ticks + 0.5)
    local parts = item.description_parts
    parts[#parts + 1] = Loc.text("ipm", "common", string.format("%d", per_minute))
    item.description_parts = parts
end

return function(name, tier, level)
    local ticks = Vlib.conveyor_ticks(level)
    describe(name, ticks)

    return {
        logic_init = function(self)
            ConveyorBlockLogic.cast(self).ticks_per_item = ticks
        end
    }
end