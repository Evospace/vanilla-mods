local logic = function(self)
    local conductor = ConductorBlockLogic.cast(self)

    local sides = {
        Vec3i.back, Vec3i.front, Vec3i.right, Vec3i.left, Vec3i.down, Vec3i.up
    }

    local t = conductor.static_block.tier

    for index, side in pairs(sides) do
        local acc = ResourceAccessor.new(conductor, "WireElectricity"..index)
        acc.side, acc.pos = side, Vec3i.zero
        acc.channel = "Electricity"
        conductor:add_wire(acc)
    end

    conductor.conductor_channel = 1000
    conductor.channel = "Electricity"
end

return { logic_init = logic }