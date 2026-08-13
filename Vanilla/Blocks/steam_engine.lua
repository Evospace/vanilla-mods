
local logic = function(self)
    local crafter = AbstractCrafter.cast(self)
    crafter.recipes = RecipeDictionary.get("GeneratorRecipeDictionary")
    crafter.stable_supply = false
        
    local inv = ResourceInventory.new(crafter, "rii")
    inv.item = StaticItem.get("Steam")
    crafter.energy_input_inventory = inv
    
    local acc = ResourceAccessor.new(crafter, "Input1")
    acc.side, acc.pos = Vec3i.down, Vec3i.zero
    acc.inventory = inv
    acc.is_input = true
    acc.channel = "Fluid"
    acc.cover = StaticCover.get("FluidInput")
    
    local inv = ResourceInventory.new(crafter, "rio")
    inv.item = StaticItem.get("Kinetic")
    crafter.energy_output_inventory = inv
    
    local acc = ResourceAccessor.new(crafter, "Output")
    acc.side, acc.pos = Vec3i.back, Vec3i.zero
    acc.inventory = inv
    acc.is_output = true
    acc.channel = "Kinetic"
    acc.cover = StaticCover.get("KineticOutput")
end

return function(name, tier, level)
    return { logic_init = logic }
end