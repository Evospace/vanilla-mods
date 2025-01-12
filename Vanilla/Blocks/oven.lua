require('Blocks/common')

local logic = function(self)
    local crafter = AbstractCrafter.cast(self)
    crafter.recipes = RecipeDictionary.find("OvenRecipeDictionary")
    crafter.speed = (crafter.static_block.level + 1)*100
            
    local inv = ResourceInventory.new(crafter, "InputInv")
    inv.item = StaticItem.find("Heat")
    inv.capacity = 20 * (crafter.static_block.level + 1)
    crafter.energy_input_inventory = inv
    
    local acc = ResourceAccessor.new(crafter, "Input")
    acc.side, acc.pos = Vec3i.down, Vec3i.new(-1,1,1)
    acc.inventory = inv
    acc.is_input = true
    acc.channel = "Heat"
    acc.cover = StaticCover.find("HeatInput")

    local inv = ResourceInventory.new(crafter, "OutputInv")
    inv.capacity = 1000

    local acc = ResourceAccessor.new(crafter, "Output")
    acc.side, acc.pos = Vec3i.front, Vec3i.zero
    acc.inventory = inv
    acc.is_output = true
    acc.channel = "Fluid"
    acc.cover = StaticCover.find("FluidOutput")
end

return { logic_init = logic }