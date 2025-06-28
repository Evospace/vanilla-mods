local energy = 20

local logic = function(self)
    local crafter = AbstractCrafter.cast(self)
    crafter.recipes = RecipeDictionary.find("SmelterRecipeDictionary")
    crafter.recipes.start_tier = 0
    crafter.speed = Vlib.get_speed(crafter)

    Vlib.add_single_slot_invs(crafter.crafter_input_container, crafter, "ii", 1)
    Vlib.add_single_slot_invs(crafter.crafter_output_container, crafter, "io", 2)
        
    local input = ResourceInventory.new(crafter, "rii")
    input.item = StaticItem.find("Heat")
    input.capacity = Vlib.get_consumption(crafter, energy)
    crafter.energy_input_inventory = input
    
    local acc = ResourceAccessor.new(crafter, "Input")
    acc.side, acc.pos = Vec3i.down, Vec3i.zero
    acc.inventory = input
    acc.is_input = true
    acc.channel = "Heat"
end

return function(name, tier, level)
    LocData.set(name, Vlib.ToPower(energy, level))
    return { logic_init = logic }
end