local logic = function(self)
    local conductor = ConductorBlockLogic.cast(self)

    local t = conductor.static_block.tier

    for index, side in pairs(Vlib.sides) do
        local acc = ResourceAccessor.new(conductor, "Pipe"..index)
        acc.side, acc.pos = side, Vec3i.zero
        acc.channel = "Fluid"
        conductor:add_wire(acc)
    end

    conductor.side_cover = StaticCover.find(Vlib.tier_material[t+1].."PipeSide")
    conductor.center_cover = StaticCover.find(Vlib.tier_material[t+1].."PipeCenter")
    conductor.conductor_channel = 2000 + conductor.static_block.tier
    conductor.channel = "Fluid"
end

return function(name, tier, level)
    LocData.set(name, Vlib.ToPower(level, 1))
    return { logic_init = logic }
end