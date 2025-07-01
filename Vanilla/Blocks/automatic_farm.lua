local logic = function(self)
    local crafter = DrillingMachineBase.cast(self)

    local inv = crafter.energy
    inv.item = StaticItem.find("Water")

    local acc = ResourceAccessor.new(crafter, "rai")
    acc.side, acc.pos = Vec3i.front, Vec3i.zero
    acc.is_input = true
    acc.inventory = inv
    acc.channel = "Fluid"

    local invs = Vlib.add_single_slot_invs(crafter.inventory, crafter, "ii", 1)
    invs[1].capacity = 100

    local acc = SolidAccessor.new(crafter, "oa")
    acc.side, acc.pos = Vec3i.back, Vec3i.new(0, -1, 0)
    acc.output = invs[1]
    acc.auto_output = true
    acc.cover = StaticCover.find("ItemOutput")
end

return function(name, tier, level)
    LocData.set(name, Vlib.ToPower(level, 1))
    return { logic_init = logic }
end