require('Blocks/common')

local logic = function(self)
    local crafter = AbstractCrafter.cast(self)
    crafter.recipes = RecipeDictionary.find("AssemblerRecipeDictionary")
    crafter.speed = (crafter.static_block.level + 1)*100
            
    local inv = ResourceInventory.new(crafter, "InputInv")
    inv.item = StaticItem.find("Electricity")
    inv.capacity = 40 * (crafter.static_block.level + 1)
    crafter.energy_input_inventory = inv
    
    local acc = ResourceAccessor.new(crafter, "Input")
    acc.side, acc.pos = Vec3i.front, Vec3i.zero
    acc.inventory = inv
    acc.is_input = true
    acc.channel = "Electricity"
end

return { logic_init = logic }