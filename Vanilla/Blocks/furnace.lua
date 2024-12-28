require('Blocks/common')

local logic = function(self)
    local crafter = AbstractCrafter.cast(self)
    crafter.recipes = RecipeDictionary.find("FurnaceRecipeDictionary")
    crafter.speed = (crafter.static_block.level + 1)*100
            
    local inv = ResourceInventory.new(crafter, "OutputInv")
    inv.item = StaticItem.find("Heat")
    inv.capacity = 20 * (crafter.static_block.level + 1)
    crafter.energy_output_inventory = inv
    
    local acc = ResourceAccessor.new(crafter, "Output")
    acc.side, acc.pos = Vec3i.up, Vec3i.zero
    acc.inventory = inv
    acc.is_output = true
    acc.channel = "Heat"
    acc.cover = StaticCover.find("HeatOutput")
end

return { logic_init = logic }