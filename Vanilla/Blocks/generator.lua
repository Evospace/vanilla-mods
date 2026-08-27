
local logic = function(self)
    local crafter = AbstractCrafter.cast(self)
    crafter.recipes = RecipeDictionary.get("GeneratorRecipeDictionary")
    crafter.speed = 100
    crafter.stable_supply = false
    --crafter.map_register = true
        
    local inv = ResourceInventory.new(crafter, "rio")
    crafter.energy_output_inventory = inv
    
    local acc = ResourceAccessor.new(crafter, "rao")
    acc.side, acc.pos = Vec3i.front, Vec3i.zero
    acc.inventory = inv
    acc.channel = "Electricity"
    acc.cover = StaticCover.get("ElectricityOutput")
    acc.is_output = true
    
    local inv = ResourceInventory.new(crafter, "rii")
    crafter.energy_input_inventory = inv
    
    local acc = ResourceAccessor.new(crafter, "rai")
    acc.side, acc.pos = Vec3i.back, Vec3i.new(-1, 1, 0)
    acc.inventory = inv
    acc.channel = "Kinetic"
    acc.cover = StaticCover.get("KineticInput")
    acc.is_input = true
end

return function(name, tier, level)
    return { logic_init = logic }
end