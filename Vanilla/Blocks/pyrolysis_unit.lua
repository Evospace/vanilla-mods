
local logic = function(self)
    local crafter = AbstractCrafter.cast(self)
    crafter.recipes = RecipeDictionary.get("PyrolysisUnitRecipeDictionary")
    crafter.speed = Vlib.get_speed(crafter)
    --crafter.map_register = true

    local inv = ResourceInventory.new(crafter, "rii")
    crafter.energy_input_inventory = inv

    local acc = ResourceAccessor.new(crafter, "rao")
    acc.side, acc.pos = Vec3i.left, Vec3i.new(0,2,0)
    acc.is_output = true
    acc.channel = "Fluid"
    acc.cover = StaticCover.get("FluidOutput")

    local acc = ResourceAccessor.new(crafter, "rao_")
    acc.side, acc.pos = Vec3i.front, Vec3i.zero
    acc.is_input = true
    acc.channel = "Fluid"
    acc.cover = StaticCover.get("FluidInput")
    
    local acc = ResourceAccessor.new(crafter, "Input")
    acc.side, acc.pos = Vec3i.down, Vec3i.zero
    acc.inventory = inv
    acc.cover = StaticCover.get("HeatInput")
    acc.channel = "Heat"
    acc.is_input = true
end

return function(name, tier, level)
    return { logic_init = logic }
end