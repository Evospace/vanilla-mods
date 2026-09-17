local function describe(name, level)
    local item = StaticItem.find(name)
    if item == nil then
        return
    end
    local parts = item.description_parts
    parts[#parts + 1] = Loc.text("ipm", "common", string.format("%d", Balance.conveyor_per_minute(level)))
    item.description_parts = parts
end

return function(name, tier, level)
    local ticks = Balance.conveyor_ticks(level)
    describe(name, level)

    return {
        logic_init = function(self)
            ConveyorBlockLogic.cast(self).ticks_per_item = ticks
        end
    }
end
