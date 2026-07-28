local logic = function(self)
    local crafter = AbstractCrafter.cast(self)
    crafter.recipes = RecipeDictionary.find("GeneratorRecipeDictionary")
    crafter.speed = 100
    crafter.stable_supply = false

    local env = EnvironmentCrafter.cast(self)
    env.wind_powered = true
    env.cut_in_wind_speed = 3.0
    env.rated_wind_speed = 14.0

    local inv = ResourceInventory.new(crafter, "rio")
    inv.item = StaticItem.find("Electricity")
    crafter.energy_output_inventory = inv

    local acc = ResourceAccessor.new(crafter, "rao")
    acc.side, acc.pos = Vec3i.back, Vec3i.zero
    acc.inventory = inv
    acc.is_output = true
    acc.channel = "Electricity"
    acc.cover = StaticCover.find("ElectricityOutput")
end

return function(name, tier, level)
    return { logic_init = logic }
end
