local logic = function(self)
    local crafter = DrillingMachineBase.cast(self)
    crafter.production = 200
    crafter.map_register = true

    crafter.energy_per_tick = 60 * crafter.static_block.level
    crafter.productivity = 20 * crafter.static_block.level

    local inv = crafter.energy
    
    local acc = ResourceAccessor.new(crafter, "ria")
    acc.side, acc.pos = Vec3i.back, Vec3i.new(-4, 0, 0)
    acc.inventory = inv
    acc.is_input = true
    acc.channel = "Kinetic"
    acc.cover = StaticCover.find("KineticInput")

    local inv = ResourceInventory.new(crafter, "rii")
    inv.capacity = 10000
    inv.item = StaticItem.find("RawOil")
    crafter.inventory:bind(inv)

    local acc = ResourceAccessor.new(crafter, "oa")
    acc.side, acc.pos = Vec3i.front, Vec3i.new(0, 0, 0)
    acc.inventory = inv
    acc.is_output = true
    acc.channel = "Fluid"
    acc.cover = StaticCover.find("FluidOutput")
end

return function(name, tier, level)
    LocData.set(name, Vlib.ToPower(level, 1))
    return { logic_init = logic }
end