require('Blocks/common')

local logic = function(self)
    local crafter = AbstractCrafter.cast(self)
    crafter.recipes = RecipeDictionary.find("ArcSmelterRecipeDictionary")
    crafter.recipes.start_tier = 2
    crafter.speed = VanillaSpeedF(crafter)
            
    local inv = ResourceInventory.new(crafter, "rii")
    inv.item = StaticItem.find("LV")
    inv.capacity = VanillaConsumptionF(crafter, 100)
    crafter.energy_input_inventory = inv

    Vlib.add_single_slot_invs(crafter.crafter_input_container, crafter, "ii", 1)
    Vlib.add_single_slot_invs(crafter.crafter_output_container, crafter, "io", 2)
    
    local acc = ResourceAccessor.new(crafter, "Input1")
    acc.side, acc.pos = Vec3i.back, Vec3i.new( -1, 1, 0 )
    acc.inventory = inv
    acc.is_input = true
    acc.channel = "LV"
    acc.cover = StaticCover.find("ElectricityInput")
end

return { logic_init = logic }