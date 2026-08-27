
local logic = function(self)
    local crafter = AbstractCrafter.cast(self)
    crafter.recipes = RecipeDictionary.get("IndustrialSmelterRecipeDictionary")
    crafter.speed = Vlib.get_speed(crafter)
    --crafter.map_register = true
        
    local input = ResourceInventory.new(crafter, "rii")
    crafter.energy_input_inventory = input
    
    local acc = ResourceAccessor.new(crafter, "rai")
    acc.side, acc.pos = Vec3i.up, Vec3i.new(0,0,0)
    acc.inventory = input
    acc.is_input = true
    acc.channel = "Heat"
    acc.cover = StaticCover.get("HeatInput")

    local acc = ResourceAccessor.new(crafter, "rai_")
    acc.side, acc.pos = Vec3i.up, Vec3i.new(-2,0,0)
    acc.inventory = input
    acc.is_input = true
    acc.channel = "Heat"
    acc.cover = StaticCover.get("HeatInput")

    local acc = ResourceAccessor.new(crafter, "rai_w")
    acc.side, acc.pos = Vec3i.back, Vec3i.new(-2,0,2)
    acc.is_input = true
    acc.channel = "Fluid"
    acc.cover = StaticCover.get("FluidInput")

    local acc = ResourceAccessor.new(crafter, "rao")
    acc.side, acc.pos = Vec3i.back, Vec3i.new(-2,0,0)
    acc.is_output = true
    acc.channel = "Fluid"
    acc.cover = StaticCover.get("FluidOutput")
end

return function(name, tier, level)
    return { logic_init = logic }
end