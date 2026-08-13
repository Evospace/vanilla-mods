
local logic = function(self)
    local crafter = AbstractCrafter.cast(self)
    crafter.recipes = RecipeDictionary.get("ArcSmelterRecipeDictionary")
    crafter.speed = Vlib.get_speed(crafter)
    --crafter.map_register = true
            
    local inv = ResourceInventory.new(crafter, "rii")
    inv.item = StaticItem.get("Electricity")
    crafter.energy_input_inventory = inv

    Vlib.add_single_slot_invs(crafter.crafter_input_container, crafter, "ii", 1)
    Vlib.add_single_slot_invs(crafter.crafter_output_container, crafter, "io", 2)
    
    local acc = ResourceAccessor.new(crafter, "Input1")
    acc.side, acc.pos = Vec3i.back, Vec3i.new( -1, 1, 0 )
    acc.inventory = inv
    acc.is_input = true
    acc.channel = "Electricity"
    acc.cover = StaticCover.get("ElectricityInput")
end

return function(name, tier, level)
    return { logic_init = logic }
end