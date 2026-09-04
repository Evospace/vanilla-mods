
local logic = function(self)
    local crafter = AbstractCrafter.cast(self)
    crafter.recipes = RecipeDictionary.get("GeneratorRecipeDictionary")
    crafter.speed = 100
    crafter.stable_supply = false

    local inv = ResourceInventory.new(crafter, "rio")
    crafter.energy_output_inventory = inv

    local acc = ResourceAccessor.new(crafter, "rao")
    acc.side, acc.pos = Vec3i.back, Vec3i.new(-1,0,0)
    acc.inventory = inv
    acc.is_output = true
    acc.channel = "Electricity"
    acc.cover = StaticCover.get("ElectricityOutput")
end

return function(name, tier, level)
    return { logic_init = logic }
end