require('Blocks/common')

local base_consumption = 100

local logic = function(self)
    local crafter = AbstractCrafter.cast(self)
    crafter.recipes = RecipeDictionary.find("IndustrialChemReactorRecipeDictionary")
    crafter.speed = VanillaSpeedF(crafter)
        
    local inv = ResourceInventory.new(crafter, "InputInv")
    inv.item = StaticItem.find("Electricity")
    inv.capacity = VanillaConsumptionF(crafter, base_consumption)
    crafter.energy_input_inventory = inv

    local acc = ResourceAccessor.new(crafter, "Fluid1InputAccessor")
    acc.side, acc.pos = Vec3i.left, Vec3i.new(-1,1,1)
    acc.is_input = true
    acc.channel = "Fluid"
    acc.cover = StaticCover.find("FluidInput")

    local acc = ResourceAccessor.new(crafter, "Fluid2InputAccessor")
    acc.side, acc.pos = Vec3i.left, Vec3i.new(0,1,0)
    acc.is_input = true
    acc.channel = "Fluid"
    acc.cover = StaticCover.find("FluidInput")

    local acc = ResourceAccessor.new(crafter, "Input1")
    acc.side, acc.pos = Vec3i.front, Vec3i.zero
    acc.inventory = inv
    acc.is_input = true
    acc.channel = "Electricity"
    acc.cover = StaticCover.find("ElectricityInput")

    local acc = ResourceAccessor.new(crafter, "Fluid1OutputAccessor")
    acc.side, acc.pos = Vec3i.back, Vec3i.new(-1,1,0)
    acc.is_output = true
    acc.channel = "Fluid"
    acc.cover = StaticCover.find("FluidOutput")
end

return { logic_init = logic }