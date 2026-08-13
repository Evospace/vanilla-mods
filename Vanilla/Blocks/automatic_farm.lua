local logic = function(self)
    local crafter = AbstractCrafter.cast(self)
    crafter.recipes = RecipeDictionary.get("AutomaticFarmRecipeDictionary")
    crafter.speed = Vlib.get_speed(crafter)
    -- crafter.map_register = true

    local acc = ResourceAccessor.new(crafter, "rai")
    acc.side, acc.pos = Vec3i.front, Vec3i.zero
    acc.is_input = true
    acc.channel = "Fluid"
    acc.cover = StaticCover.get("FluidInput")
end

return function(name, tier, level)
    return { logic_init = logic }
end
