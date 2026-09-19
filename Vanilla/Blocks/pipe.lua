local logic = function(self)
    local conductor = ConductorBlockLogic.cast(self)

    local t = conductor.static_block.tier

    for index, side in pairs(Vlib.sides) do
        local acc = ResourceAccessor.new(conductor, "Pipe"..index)
        acc.side, acc.pos = side, Vec3i.zero
        acc.channel = "Fluid"
        conductor:add_wire(acc)
    end

    local tier = Vlib.tier_material[t+1]

    conductor.capacity = 100
    conductor.side_cover = StaticCover.get(tier.."PipeArm")
    conductor.center_cover = StaticCover.get(tier.."PipeCenter")
    conductor.straight_cover = StaticCover.get(tier.."PipeStraightSingleFlange")
    conductor.straight_plain_cover = StaticCover.get(tier.."PipeStraightNoFlanges")
    conductor.elbow_cover = StaticCover.get(tier.."PipeElbow")
    conductor.dead_end_cover = StaticCover.get(tier.."PipeDeadEnd")
    conductor.isolated_cover = StaticCover.get(tier.."PipeIsolated")
    conductor.conductor_channel = 2000 + conductor.static_block.tier
    conductor.channel = "Fluid"
end

return function(name, tier, level)
    return { logic_init = logic }
end