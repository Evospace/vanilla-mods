local Vlib = require('@VanillaLib')

return function(name, tier, level)
    local ticks = Vlib.conveyor_ticks(level)

    return {
        logic_init = function(self)
            SplitterBlockLogic.cast(self).ticks_per_item = ticks
        end
    }
end