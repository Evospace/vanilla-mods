require('Blocks/common')

local logic = function(self)
    local crafter = AbstractCrafter.cast(self)
    crafter.recipes = RecipeDictionary.find("IndustrialSeparatorRecipeDictionary")
    crafter.speed = VanillaSpeedF(crafter)
            
    local inv = ResourceInventory.new(crafter, "rii")
    inv.item = StaticItem.find("Kinetic")
    inv.capacity = VanillaConsumptionF(crafter, 160)
    crafter.energy_input_inventory = inv
    
    local acc = ResourceAccessor.new(crafter, "Input1")
    acc.side, acc.pos = Vec3i.back, Vec3i.new(-1,1,0)
    acc.inventory = inv
    acc.is_input = true
    acc.channel = "Kinetic"
    acc.cover = StaticCover.find("KineticInput")
end

return { logic_init = logic }