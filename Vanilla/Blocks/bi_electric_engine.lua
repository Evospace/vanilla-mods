local logic = function(self)
    local crafter = AbstractCrafter.cast(self)
    crafter.recipes = RecipeDictionary.get("GeneratorRecipeDictionary")
    crafter.speed = 100
    crafter.stable_supply = false
        
    local inv = ResourceInventory.new(crafter, "rii")
    inv.item = StaticItem.get("Electricity")
    crafter.energy_input_inventory = inv
    
    local acc = ResourceAccessor.new(crafter, "rai_")
    acc.side, acc.pos = Vec3i.down, Vec3i.zero
    acc.inventory = inv
    acc.is_input = true
    acc.channel = "Electricity"
    acc.cover = StaticCover.get("ElectricityInput")
    
    local inv = ResourceInventory.new(crafter, "rio")
    inv.item = StaticItem.get("Kinetic")
    crafter.energy_output_inventory = inv
    
    local acc = ResourceAccessor.new(crafter, "rao")
    acc.side, acc.pos = Vec3i.back, Vec3i.zero
    acc.inventory = inv
    acc.channel = "Kinetic"
    acc.cover = StaticCover.get("KineticOutput")
    acc.is_output = true

    local acc = ResourceAccessor.new(crafter, "rao_")
    acc.side, acc.pos = Vec3i.front, Vec3i.zero
    acc.inventory = inv
    acc.channel = "Kinetic"
    acc.cover = StaticCover.get("KineticOutput")
    acc.is_output = true
end

return function(name, tier, level)
    return { logic_init = logic }
end