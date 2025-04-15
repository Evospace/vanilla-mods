local logic = function(self)
    local crafter = AbstractCrafter.cast(self)
    crafter.recipes = RecipeDictionary.find("FluidFurnaceRecipeDictionary")
    crafter.speed = Vlib.get_speed(crafter)

    Vlib.add_single_slot_invs(crafter.crafter_input_container, crafter, "ii", 1)
            
    local inv = ResourceInventory.new(crafter, "rio")
    inv.item = StaticItem.find("Heat")
    inv.capacity = Vlib.get_consumption(crafter, 200)
    crafter.energy_output_inventory = inv
    
    local acc = ResourceAccessor.new(crafter, "rao")
    acc.side, acc.pos = Vec3i.up, Vec3i.zero
    acc.inventory = inv
    acc.is_output = true
    acc.channel = "Heat"
    acc.cover = StaticCover.find("HeatOutput")
    
    local acc = ResourceAccessor.new(crafter, "rai")
    acc.side, acc.pos = Vec3i.back, Vec3i.zero
    acc.is_input = true
    acc.channel = "Fluid"
    acc.cover = StaticCover.find("FluidInput")
end

return { logic_init = logic }