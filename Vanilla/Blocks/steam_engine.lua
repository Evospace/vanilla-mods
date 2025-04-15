local logic = function(self)
    local crafter = AbstractCrafter.cast(self)
    crafter.recipes = RecipeDictionary.find("GeneratorRecipeDictionary")
    crafter.stable_supply = false
        
    local inv = ResourceInventory.new(crafter, "rii")
    inv.item = StaticItem.find("Steam")
    inv.capacity = Vlib.get_consumption(crafter, 100)
    crafter.energy_input_inventory = inv
    
    local acc = ResourceAccessor.new(crafter, "Input1")
    acc.side, acc.pos = Vec3i.down, Vec3i.zero
    acc.inventory = inv
    acc.is_input = true
    acc.channel = "Fluid"
    acc.cover = StaticCover.find("FluidInput")
    
    local inv = ResourceInventory.new(crafter, "rio")
    inv.item = StaticItem.find("Kinetic")
    inv.capacity = Vlib.get_consumption(crafter, 100)
    crafter.energy_output_inventory = inv
    
    local acc = ResourceAccessor.new(crafter, "Output")
    acc.side, acc.pos = Vec3i.back, Vec3i.zero
    acc.inventory = inv
    acc.is_output = true
    acc.channel = "Kinetic"
    acc.cover = StaticCover.find("KineticOutput")
end

return { logic_init = logic }