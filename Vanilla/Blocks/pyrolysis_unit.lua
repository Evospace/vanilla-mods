require('Blocks/common')

local logic = function(self)
    local crafter = AbstractCrafter.cast(self)
    crafter.recipes = RecipeDictionary.find("PyrolysisUnitRecipeDictionary")
    crafter.speed = VanillaSpeedF(crafter)

    local inv = ResourceInventory.new(crafter, "InputInv")
    inv.item = StaticItem.find("Heat")
    inv.capacity = VanillaConsumptionF(crafter, 20)
    crafter.energy_input_inventory = inv

    local acc = ResourceAccessor.new(crafter, "Fluid1OutputAccessor")
    acc.side, acc.pos = Vec3i.left, Vec3i.new(0,2,0)
    acc.is_output = true
    acc.channel = "Fluid"
    acc.cover = StaticCover.find("FluidOutput")

    local acc = ResourceAccessor.new(crafter, "Fluid1InputAccessor")
    acc.side, acc.pos = Vec3i.front, Vec3i.new(0,2,0)
    acc.is_input = true
    acc.channel = "Fluid"
    acc.cover = StaticCover.find("FluidInput")
    
    local acc = ResourceAccessor.new(crafter, "Input")
    acc.side, acc.pos = Vec3i.down, Vec3i.zero
    acc.inventory = inv
    acc.cover = StaticCover.find("HeatInput")
    acc.channel = "Heat"
    acc.is_input = true
end

return { logic_init = logic }