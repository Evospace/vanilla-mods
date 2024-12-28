require('Blocks/common')

local logic = function(self)
    local crafter = AbstractCrafter.cast(self)
    crafter.recipes = RecipeDictionary.find("FermenterRecipeDictionary")
    crafter.speed = (crafter.static_block.level + 1)*100

    local input = ResourceInventory.new(crafter, "InputInv")
    input.item = StaticItem.find("Electricity")
    input.capacity = 20
    crafter.energy_input_inventory = inv
    
    local acc = ResourceAccessor.new(crafter, "Input")
    acc.side = Vec3i.back
    acc.pos = Vec3i.zero
    acc.inventory = input
    acc.cover = StaticCover.find("ElectricityInput")
end

return { logic_init = logic }