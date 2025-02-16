require('Blocks/common')

local logic = function(self)
    local crafter = AbstractCrafter.cast(self)
    crafter.recipes = RecipeDictionary.find("AtmosphericCondenserRecipeDictionary")
    crafter.speed = VanillaSpeedF(crafter)
            
    local inv = ResourceInventory.new(crafter, "InputInv")
    inv.item = StaticItem.find("Kinetic")
    inv.capacity = VanillaConsumptionF(crafter, 20)
    crafter.energy_input_inventory = inv
    
    local acc = ResourceAccessor.new(crafter, "Input")
    acc.side, acc.pos = Vec3i.right, Vec3i.new(-1,-2,0)
    acc.inventory = inv
    acc.channel = "Kinetic"
    acc.is_input = true
    acc.cover = StaticCover.find("KineticInput")
    
    acc = ResourceAccessor.new(crafter, "CraftOutput")
    acc.side, acc.pos = Vec3i.front, Vec3i.zero
    acc.channel = "Fluid"
    acc.is_output = true
    acc.cover = StaticCover.find("FluidOutput")
end

return { logic_init = logic }