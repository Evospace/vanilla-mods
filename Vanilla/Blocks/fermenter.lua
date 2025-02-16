require('Blocks/common')

local logic = function(self)
    local crafter = AbstractCrafter.cast(self)
    crafter.recipes = RecipeDictionary.find("FermenterRecipeDictionary")
    crafter.speed = VanillaSpeedF(crafter)

    local inv = ResourceInventory.new(crafter, "InputInv")
    inv.item = StaticItem.find("Electricity")
    inv.capacity = VanillaConsumptionF(crafter, 20)
    crafter.energy_input_inventory = inv
    
    local acc = ResourceAccessor.new(crafter, "Input")
    acc.side, acc.pos = Vec3i.back, Vec3i.zero
    acc.inventory = inv
    acc.cover = StaticCover.find("ElectricityInput")
    acc.channel = "Electricity"
end

return { logic_init = logic }