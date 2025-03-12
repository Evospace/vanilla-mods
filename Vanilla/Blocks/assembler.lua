require('Blocks/common')

local logic = function(self)
    local crafter = AbstractCrafter.cast(self)
    crafter.recipes = RecipeDictionary.find("AssemblerRecipeDictionary")
    crafter.speed = VanillaSpeedF(crafter)
            
    local inv = ResourceInventory.new(crafter, "rii")
    inv.item = StaticItem.find("LV")
    inv.capacity = 40 * (crafter.static_block.level + 1)
    crafter.energy_input_inventory = inv
    
    local acc = ResourceAccessor.new(crafter, "rai")
    acc.side, acc.pos = Vec3i.front, Vec3i.zero
    acc.inventory = inv
    acc.is_input = true
    acc.channel = "LV"
end

return { logic_init = logic }