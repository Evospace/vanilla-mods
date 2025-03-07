require('Blocks/common')

local logic = function(self)
    local crafter = AbstractCrafter.cast(self)
    crafter.recipes = RecipeDictionary.find("AutomaticHammerRecipeDictionary")
    crafter.speed = VanillaSpeedF(crafter)
            
    local inv = ResourceInventory.new(crafter, "rii")
    inv.item = StaticItem.find("Kinetic")
    inv.capacity = VanillaConsumptionF(crafter, 20)
    crafter.energy_input_inventory = inv

    Vlib.add_single_slot_invs(crafter.crafter_input_container, crafter, "Inv", 1)
    Vlib.add_single_slot_invs(crafter.crafter_output_container, crafter, "Inv", 2)
    
    local acc = ResourceAccessor.new(crafter, "Input")
    acc.side, acc.pos = Vec3i.back, Vec3i.zero
    acc.inventory = inv
    acc.is_input = true
    acc.channel = "Kinetic"
    acc.cover = StaticCover.find("KineticInput")
end

return { logic_init = logic }