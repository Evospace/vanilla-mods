local logic = function(self)
    local antenna = PortalProjectBlockLogic.cast(self)
    antenna.stages = RecipeDictionary.get("SatelliteAntennaStageRecipeDictionary")

    local acc = ResourceAccessor.new(antenna, "rai")
    acc.side, acc.pos = Vec3i.front, Vec3i.new(1, 0, 0)
    acc.inventory = antenna.inventories.Energy
    acc.is_input = true
    acc.channel = "Electricity"
    acc.cover = StaticCover.get("ElectricityInput")
end

return function(name, tier, level)
    return { logic_init = logic }
end
