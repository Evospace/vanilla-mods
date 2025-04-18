local logic = function(self)
    local conductor = DataConductorBlockLogic.cast(self)

    local t = conductor.static_block.tier

    for index, side in pairs(Vlib.sides) do
        local acc = ResourceAccessor.new(conductor, "Pipe"..index)
        acc.side, acc.pos = side, Vec3i.zero
        acc.channel = "Data"
        conductor:add_wire(acc)
    end

    conductor.side_cover = StaticCover.find(Vlib.tier_material[t+1].."PipeSide")
    conductor.center_cover = StaticCover.find(Vlib.tier_material[t+1].."PipeCenter")
    conductor.resistance = 0
    conductor.conductor_channel = 6000
    conductor.channel = "Data"
end

return { logic_init = logic }