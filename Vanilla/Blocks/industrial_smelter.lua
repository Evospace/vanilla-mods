require('Blocks/common')

local logic = function(self)
    local crafter = AbstractCrafter.cast(self)
    crafter.recipes = RecipeDictionary.find("IndustrialSmelterRecipeDictionary")
    crafter.speed = VanillaSpeedF(crafter)
        
    local input = ResourceInventory.new(crafter, "InputInv")
    input.item = StaticItem.find("Heat")
    input.capacity = VanillaConsumptionF(crafter, 1000)
    crafter.energy_input_inventory = input
    
    local acc = ResourceAccessor.new(crafter, "InputH1")
    acc.side, acc.pos = Vec3i.down, Vec3i.new(0,0,2)
    acc.inventory = input
    acc.is_input = true
    acc.channel = "Heat"

    local acc = ResourceAccessor.new(crafter, "InputH2")
    acc.side, acc.pos = Vec3i.down, Vec3i.new(-2,0,2)
    acc.inventory = input
    acc.is_input = true
    acc.channel = "Heat"
    acc.cover = StaticCover.find("HeatInput")

    local acc = ResourceAccessor.new(crafter, "InputH3")
    acc.side, acc.pos = Vec3i.down, Vec3i.new(-1,1,2)
    acc.inventory = input
    acc.is_input = true
    acc.channel = "Heat"
    acc.cover = StaticCover.find("HeatInput")

    local acc = ResourceAccessor.new(crafter, "InputH4")
    acc.side, acc.pos = Vec3i.down, Vec3i.new(-1,-1,2)
    acc.inventory = input
    acc.is_input = true
    acc.channel = "Heat"
    acc.cover = StaticCover.find("HeatInput")

    local acc = ResourceAccessor.new(crafter, "FluidInput")
    acc.side, acc.pos = Vec3i.back, Vec3i.new(-2,0,2)
    acc.is_input = true
    acc.channel = "Fluid"
    acc.cover = StaticCover.find("FluidInput")

    local acc = ResourceAccessor.new(crafter, "FluidOutput")
    acc.side, acc.pos = Vec3i.back, Vec3i.new(-2,0,0)
    acc.is_output = true
    acc.channel = "Fluid"
    acc.cover = StaticCover.find("FluidOutput")
end

return { logic_init = logic }