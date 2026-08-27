
local logic = function(self)
    local crafter = AbstractCrafter.cast(self)
    crafter.recipes = RecipeDictionary.get("GeneratorRecipeDictionary")
    crafter.speed = 100
    crafter.stable_supply = false
        
    local inv = ResourceInventory.new(crafter, "rio")
    crafter.energy_output_inventory = inv
    
    local acc = ResourceAccessor.new(crafter, "Output")
    acc.side, acc.pos = Vec3i.front, Vec3i.zero
    acc.inventory = inv
    acc.channel = "Kinetic"
    acc.cover = StaticCover.get("KineticOutput")
    acc.is_output = true
    
    local inv = ResourceInventory.new(crafter, "rii")
    crafter.energy_input_inventory = inv
    
    local acc = ResourceAccessor.new(crafter, "Input")
    acc.side, acc.pos = Vec3i.up, Vec3i.new(0, 0, 1)
    acc.inventory = inv
    acc.channel = "Fluid"
    acc.cover = StaticCover.get("FluidInput")
    acc.is_input = true
end

return function(name, tier, level)
    return { logic_init = logic }
end