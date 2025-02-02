require('Blocks/common')

local logic = function(self)
    local crafter = AbstractCrafter.cast(self)
    crafter.recipes = RecipeDictionary.find("SmelterRecipeDictionary")
    crafter.speed = VanillaSpeedF(crafter)
        
    local input = ResourceInventory.new(crafter, "InputInv")
    input.item = StaticItem.find("Heat")
    input.capacity = VanillaConsumptionF(crafter, 20)
    crafter.energy_input_inventory = input
    
    local acc = ResourceAccessor.new(crafter, "Input")
    acc.side, acc.pos = Vec3i.down, Vec3i.zero
    acc.inventory = input
    acc.is_input = true
    acc.channel = "Heat"
end

return { logic_init = logic }