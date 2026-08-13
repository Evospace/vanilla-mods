local logic = function(self)
    local conductor = ConductorBlockLogic.cast(self)

    local t = conductor.static_block.tier

    for index, side in pairs(Vlib.sides) do
        local acc = ResourceAccessor.new(conductor, "Data"..index)
        acc.side, acc.pos = side, Vec3i.zero
        acc.channel = "Data"
        conductor:add_wire(acc)
    end

    conductor.side_cover = StaticCover.get("DataSide")
    conductor.center_cover = StaticCover.get("DataCenter")
    conductor.channel = "Data"
end

return function(name, tier, level)
    return { logic_init = logic }
end