require('Blocks/common')

local logic = function(self)
    local crafter = AbstractCrafter.cast(self)
    crafter.recipes = RecipeDictionary.find("DestroyerRecipeDictionary")
    crafter.speed = (crafter.static_block.level + 1)*100
            
    local inv = ResourceInventory.new(crafter, "InputInv")
    inv.capacity = 20
    crafter.energy_input_inventory = inv
    
    acc = ResourceAccessor.new(crafter, "FluidInput")
    acc.side, acc.pos = Vec3i.back, Vec3i.zero
    acc.channel = "Fluid"
    acc.is_input = true
    acc.cover = StaticCover.find("FluidInput")
    acc.inventory = inv
end

return { logic_init = logic }