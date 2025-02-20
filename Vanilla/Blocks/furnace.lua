require('Blocks/common')

local logic = function(self)
    local crafter = AbstractCrafter.cast(self)
    crafter.recipes = RecipeDictionary.find("FurnaceRecipeDictionary")
    crafter.speed = VanillaSpeedF(crafter)
            
    local inv = ResourceInventory.new(crafter, "rio")
    inv.item = StaticItem.find("Heat")
    inv.capacity = VanillaConsumptionF(crafter, 50)
    crafter.energy_output_inventory = inv
    
    local acc = ResourceAccessor.new(crafter, "Output")
    acc.side, acc.pos = Vec3i.up, Vec3i.zero
    acc.inventory = inv
    acc.is_output = true
    acc.channel = "Heat"
    acc.cover = StaticCover.find("HeatOutput")
end

return { logic_init = logic }