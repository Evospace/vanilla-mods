local logic = function(self)
    local chest = ChestBlockLogic.cast(self)
    chest.signal.export = {
        LogicExportOption.find("ChestExportInventory")
    }

    local t = chest.static_block.tier

    chest.capacity = 20 + t * 5
end

return function(name, tier, level)
    LocData.set(name, Vlib.ToPower(level, 1))
    return { logic_init = logic }
end