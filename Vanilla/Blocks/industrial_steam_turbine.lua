
local logic = function(self)
    local crafter = AbstractCrafter.cast(self)
    crafter.recipes = RecipeDictionary.get("GeneratorRecipeDictionary")
    crafter.speed = 100
    crafter.stable_supply = false
    --crafter.map_register = true
        
    local inv = ResourceInventory.new(crafter, "rio")
    inv.item = StaticItem.get("Kinetic")
    crafter.energy_output_inventory = inv
    
    local acc = ResourceAccessor.new(crafter, "Output")
    acc.side, acc.pos = Vec3i.back, Vec3i.new(-5, -1, 0)
    acc.inventory = inv
    acc.channel = "Kinetic"
    acc.cover = StaticCover.get("KineticOutput")
    acc.is_output = true
    
    local inv = ResourceInventory.new(crafter, "rii")
    inv.item = StaticItem.get("Steam")
    crafter.energy_input_inventory = inv
    
    local acc = ResourceAccessor.new(crafter, "Input")
    acc.side, acc.pos = Vec3i.front, Vec3i.new(0, 0, 0)
    acc.inventory = inv
    acc.channel = "Fluid"
    acc.cover = StaticCover.get("FluidInput")
    acc.is_input = true
end

return function(name, tier, level)
    return { logic_init = logic }
end