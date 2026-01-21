local logic = function(self)
    local conductor = ConductorBlockLogic.cast(self)

    local sides = {
        Vec3i.back, Vec3i.front, Vec3i.right, Vec3i.left, Vec3i.down, Vec3i.up
    }

    local level = conductor.static_block.level

    for index, side in pairs(sides) do
        local acc = ResourceAccessor.new(conductor, "Heat"..index)
        acc.side, acc.pos = side, Vec3i.zero
        acc.channel = "Heat"
        conductor:add_wire(acc)
    end

    conductor.capacity = 32000
    conductor.conductor_channel = 3000
    conductor.channel = "Heat"
end

return function(name, tier, level)
    LocData.set(name, Vlib.ToPower(level, 1))
    return { logic_init = logic }
end