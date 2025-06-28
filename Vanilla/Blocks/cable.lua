local logic = function(self)
    local conductor = ConductorBlockLogic.cast(self)

    for index, side in pairs(Vlib.sides) do
        local acc = ResourceAccessor.new(conductor, "Wire"..index)
        acc.side, acc.pos = side, Vec3i.zero
        acc.channel = "Electricity"
        conductor:add_wire(acc)
    end

    conductor.side_cover = StaticCover.find("CableSide")
    conductor.center_cover = StaticCover.find("CableCenter")
    conductor.conductor_channel = 1000
    conductor.channel = "Electricity"
end

return function(name, tier, level)
    LocData.set(name, Vlib.ToPower(level, 1))
    return { logic_init = logic }
end