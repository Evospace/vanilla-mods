
local logic = function(self)
    local crafter = AbstractCrafter.cast(self)
    crafter.recipes = RecipeDictionary.get("SmelterRecipeDictionary")
    crafter.speed = Vlib.get_speed(crafter)

    Vlib.add_single_slot_invs(crafter.crafter_input_container, crafter, "ii", 1)
    Vlib.add_single_slot_invs(crafter.crafter_output_container, crafter, "io", 2)
        
    local input = ResourceInventory.new(crafter, "rii")
    input.item = StaticItem.get("Heat")
    crafter.energy_input_inventory = input
    
    local acc = ResourceAccessor.new(crafter, "Input")
    acc.side, acc.pos = Vec3i.down, Vec3i.zero
    acc.inventory = input
    acc.is_input = true
    acc.channel = "Heat"
end

return function(name, tier, level)
    return { logic_init = logic }
end