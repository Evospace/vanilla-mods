local energy = 20

local logic = function(self)
    local crafter = AbstractCrafter.cast(self)
    crafter.recipes = RecipeDictionary.find("FermenterRecipeDictionary")
    crafter.speed = Vlib.get_speed(crafter)

    local inv = ResourceInventory.new(crafter, "rii")
    inv.item = StaticItem.find("Electricity")
    inv.capacity = Vlib.get_consumption(crafter, energy)
    crafter.energy_input_inventory = inv
    
    local acc = ResourceAccessor.new(crafter, "rai")
    acc.side, acc.pos = Vec3i.back, Vec3i.zero
    acc.inventory = inv
    acc.is_input = true
    acc.cover = StaticCover.find("ElectricityInput")
    acc.channel = "Electricity"

    local acc = ResourceAccessor.new(crafter, "rai_")
    acc.side, acc.pos = Vec3i.left, Vec3i.zero
    acc.is_input = true
    acc.channel = "Fluid"
    acc.cover = StaticCover.find("FluidInput")

    local acc = ResourceAccessor.new(crafter, "rao")
    acc.side, acc.pos = Vec3i.front, Vec3i.zero
    acc.is_output = true
    acc.channel = "Fluid"
    acc.cover = StaticCover.find("FluidOutput1")

    local acc = ResourceAccessor.new(crafter, "rao_1")
    acc.side, acc.pos = Vec3i.right, Vec3i.zero
    acc.is_output = true
    acc.channel = "Fluid"
    acc.cover = StaticCover.find("FluidOutput2")
end

return function(name, tier, level)
    LocData.set(name, Vlib.ToPower(energy, level))
    return { logic_init = logic }
end