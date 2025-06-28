local logic = function(self)
    local container = FluidContainerBlockLogic.cast(self)

    local t = container.static_block.tier

    for index, side in pairs(Vlib.sides) do
        local acc = ResourceAccessor.new(container, "Cont"..index)
        acc.side, acc.pos = side, Vec3i.zero
        acc.channel = "Fluid"
        container:add_wire(acc)
    end

    container.capacity = 30*(t)*1000
    container.conductor_channel = 0
    container.channel = "Fluid"
end

return function(name, tier, level)
    LocData.set(name, Vlib.ToPower(level, 1))
    return { logic_init = logic }
end