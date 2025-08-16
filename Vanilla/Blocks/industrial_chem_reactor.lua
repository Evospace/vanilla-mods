local energy = 100

local logic = function(self)
    local crafter = AbstractCrafter.cast(self)
    crafter.recipes = RecipeDictionary.find("IndustrialChemReactorRecipeDictionary")
    crafter.speed = Vlib.get_speed(crafter)
    --crafter.map_register = true
        
    local inv = ResourceInventory.new(crafter, "rii")
    inv.item = StaticItem.find("Electricity")
    inv.capacity = Vlib.get_consumption(crafter, energy)
    crafter.energy_input_inventory = inv

    local acc = ResourceAccessor.new(crafter, "rai")
    acc.side, acc.pos = Vec3i.left, Vec3i.new(-1,1,1)
    acc.is_input = true
    acc.channel = "Fluid"
    acc.cover = StaticCover.find("FluidInput1")

    local acc = ResourceAccessor.new(crafter, "rai_")
    acc.side, acc.pos = Vec3i.left, Vec3i.new(0,1,0)
    acc.is_input = true
    acc.channel = "Fluid"
    acc.cover = StaticCover.find("FluidInput2")

    local acc = ResourceAccessor.new(crafter, "rai_1")
    acc.side, acc.pos = Vec3i.front, Vec3i.zero
    acc.inventory = inv
    acc.is_input = true
    acc.channel = "Electricity"
    acc.cover = StaticCover.find("ElectricityInput")

    local acc = ResourceAccessor.new(crafter, "rao")
    acc.side, acc.pos = Vec3i.back, Vec3i.new(-1,1,0)
    acc.is_output = true
    acc.channel = "Fluid"
    acc.cover = StaticCover.find("FluidOutput")
end

return function(name, tier, level)
    LocData.set(name, Vlib.ToPower(energy, level))
    return { logic_init = logic }
end