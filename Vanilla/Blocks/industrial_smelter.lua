

local logic = function(self)
    local crafter = AbstractCrafter.cast(self)
    crafter.recipes = RecipeDictionary.find("IndustrialSmelterRecipeDictionary")
    crafter.speed = Vlib.get_speed(crafter)
        
    local input = ResourceInventory.new(crafter, "rii")
    input.item = StaticItem.find("Heat")
    input.capacity = Vlib.get_consumption(crafter, 1000)
    crafter.energy_input_inventory = input
    
    local acc = ResourceAccessor.new(crafter, "rai")
    acc.side, acc.pos = Vec3i.up, Vec3i.new(0,0,0)
    acc.inventory = input
    acc.is_input = true
    acc.channel = "Heat"
    acc.cover = StaticCover.find("HeatInput")

    local acc = ResourceAccessor.new(crafter, "rai_")
    acc.side, acc.pos = Vec3i.up, Vec3i.new(-2,0,0)
    acc.inventory = input
    acc.is_input = true
    acc.channel = "Heat"
    acc.cover = StaticCover.find("HeatInput")

    local acc = ResourceAccessor.new(crafter, "rai_w")
    acc.side, acc.pos = Vec3i.back, Vec3i.new(-2,0,2)
    acc.is_input = true
    acc.channel = "Fluid"
    acc.cover = StaticCover.find("FluidInput")

    local acc = ResourceAccessor.new(crafter, "rao")
    acc.side, acc.pos = Vec3i.back, Vec3i.new(-2,0,0)
    acc.is_output = true
    acc.channel = "Fluid"
    acc.cover = StaticCover.find("FluidOutput")
end

return { logic_init = logic }