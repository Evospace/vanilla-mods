require('Blocks/common')

local logic = function(self)
    local crafter = AbstractCrafter.cast(self)
    crafter.recipes = RecipeDictionary.find("ArcSmelterRecipeDictionary")
    crafter.speed = VanillaSpeedF(crafter)
            
    local inv = ResourceInventory.new(crafter, "InputInv")
    inv.item = StaticItem.find("Electricity")
    inv.capacity = VanillaConsumptionF(crafter, 100)
    crafter.energy_input_inventory = inv
    
    local acc = ResourceAccessor.new(crafter, "Input1")
    acc.side, acc.pos = Vec3i.back, Vec3i.new( -1, 1, 0 )
    acc.inventory = inv
    acc.is_input = true
    acc.channel = "Electricity"
    acc.cover = StaticCover.find("ElectricityInput")
end

return { logic_init = logic }