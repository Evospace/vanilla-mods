local logic = function(self)
    local crafter = AbstractCrafter.cast(self)
    crafter.recipes = RecipeDictionary.find("GeneratorRecipeDictionary")
    crafter.speed = 100
    crafter.stable_supply = false
        
    local inv = ResourceInventory.new(crafter, "rii")
    inv.item = StaticItem.find("Electricity")
    inv.capacity = Vlib.get_consumption(crafter, 55)
    crafter.energy_input_inventory = inv
    
    local acc = ResourceAccessor.new(crafter, "rai_")
    acc.side, acc.pos = Vec3i.down, Vec3i.zero
    acc.inventory = inv
    acc.is_input = true
    acc.channel = "Electricity"
    acc.cover = StaticCover.find("ElectricityInput")
    
    local inv = ResourceInventory.new(crafter, "rio")
    inv.item = StaticItem.find("Kinetic")
    inv.capacity = Vlib.get_consumption(crafter, 55)
    crafter.energy_output_inventory = inv
    
    local acc = ResourceAccessor.new(crafter, "rao")
    acc.side, acc.pos = Vec3i.back, Vec3i.zero
    acc.inventory = inv
    acc.channel = "Kinetic"
    acc.cover = StaticCover.find("KineticOutput")
    acc.is_output = true

    local acc = ResourceAccessor.new(crafter, "rao_")
    acc.side, acc.pos = Vec3i.front, Vec3i.zero
    acc.inventory = inv
    acc.channel = "Kinetic"
    acc.cover = StaticCover.find("KineticOutput")
    acc.is_output = true
end

return { logic_init = logic }