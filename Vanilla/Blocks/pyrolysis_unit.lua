local energy = 50

local logic = function(self)
    local crafter = AbstractCrafter.cast(self)
    crafter.recipes = RecipeDictionary.find("PyrolysisUnitRecipeDictionary")
    crafter.recipes.start_tier = 3
    crafter.speed = Vlib.get_speed(crafter)
    --crafter.map_register = true

    local inv = ResourceInventory.new(crafter, "rii")
    inv.item = StaticItem.find("Heat")
    inv.capacity = Vlib.get_consumption(crafter, energy)
    crafter.energy_input_inventory = inv

    local acc = ResourceAccessor.new(crafter, "rao")
    acc.side, acc.pos = Vec3i.left, Vec3i.new(0,2,0)
    acc.is_output = true
    acc.channel = "Fluid"
    acc.cover = StaticCover.find("FluidOutput")

    local acc = ResourceAccessor.new(crafter, "rao_")
    acc.side, acc.pos = Vec3i.front, Vec3i.zero
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

return function(name, tier, level)
    LocData.set(name, Vlib.ToPower(energy, level))
    return { logic_init = logic }
end