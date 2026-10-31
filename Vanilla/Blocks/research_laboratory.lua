local logic = function(self)
    local crafter = AbstractCrafter.cast(self)
    crafter.recipes = RecipeDictionary.get("ResearchLaboratoryRecipeDictionary")
    crafter.speed = 100 + 10 * crafter.static_block.level

    local inv = ResourceInventory.new(crafter, "rii")
    crafter.energy_input_inventory = inv

    local acc = ResourceAccessor.new(crafter, "rai")
    acc.side, acc.pos = Vec3i.back, Vec3i.new(-2, 0, 0)
    acc.inventory = inv
    acc.is_input = true
    acc.channel = "Electricity"
    acc.cover = StaticCover.get("ElectricityInput")
end

return function(name, tier, level)
    return { logic_init = logic }
end
