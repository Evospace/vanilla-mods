require('Blocks/common')

local logic = function(self)
    local crafter = AbstractCrafter.cast(self)
    crafter.recipes = RecipeDictionary.find("OreWasherRecipeDictionary")
    crafter.speed = VanillaSpeedF(crafter)
            
    local inv = ResourceInventory.new(crafter, "InputInv")
    inv.item = StaticItem.find("Kinetic")
    inv.capacity = VanillaConsumptionF(crafter, 20)
    crafter.energy_input_inventory = inv

    local acc = ResourceAccessor.new(crafter, "Input")
    acc.side, acc.pos = Vec3i.front, Vec3i.new(0,1,0)
    acc.inventory = inv
    acc.is_input = true
    acc.channel = "Kinetic"
    acc.cover = StaticCover.find("KineticInput")

    local acc = ResourceAccessor.new(crafter, "Output2")
    acc.side, acc.pos = Vec3i.left, Vec3i.new(-2,1,0)
    acc.is_output = true
    acc.channel = "Fluid"
    acc.cover = StaticCover.find("FluidOutput")

    local acc = ResourceAccessor.new(crafter, "Input2")
    acc.side, acc.pos = Vec3i.right, Vec3i.new(-2,0,1)
    acc.is_input = true
    acc.channel = "Fluid"
    acc.cover = StaticCover.find("FluidInput")
end

return { logic_init = logic }