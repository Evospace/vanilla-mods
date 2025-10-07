local logic = function(self)
    local crafter = DrillingMachineBase.cast(self)
    crafter.map_register = true

    crafter.energy_per_tick = 60 * (crafter.static_block.level + 1)
    crafter.productivity = 15 * crafter.static_block.level

    local inv = crafter.energy
    inv.capacity = crafter.energy_per_tick
    
    local acc = ResourceAccessor.new(crafter, "ria")
    acc.side, acc.pos = Vec3i.back, Vec3i.new(-2, 0, 0)
    acc.inventory = inv
    acc.is_input = true
    acc.channel = "Kinetic"
    acc.cover = StaticCover.find("KineticInput")

    local invs = Vlib.add_single_slot_invs(crafter.inventory, crafter, "ii", 1)
    invs[1].capacity = 100

    local acc = SolidAccessor.new(crafter, "oa")
    acc.side, acc.pos = Vec3i.front, Vec3i.new(0, -1, 0)
    acc.output = invs[1]
    acc.auto_output = true
    acc.cover = StaticCover.find("ItemOutput")
end

return function(name, tier, level)
    LocData.set(name, Vlib.ToPower(level, 1))
    return { logic_init = logic }
end