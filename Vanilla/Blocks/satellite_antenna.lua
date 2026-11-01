local logic = function(self)
    local antenna = PortalProjectBlockLogic.cast(self)
    antenna.stages = RecipeDictionary.get("SatelliteAntennaStageRecipeDictionary")
end

return function(name, tier, level)
    return { logic_init = logic }
end
