local logic = function(self)
    local container = FluidContainerBlockLogic.cast(self)

    local t = container.static_block.tier

    for index, side in pairs(Vlib.sides) do
        local acc = ResourceAccessor.new(container, "Cont"..index)
        acc.side, acc.pos = side, Vec3i.zero
        acc.channel = "Fluid"
        container:add_wire(acc)
    end

    local tier = Vlib.tier_material[t + 1]

    container.capacity = 30*(t)*1000
    container.conductor_channel = 0
    container.channel = "Fluid"
    container.single_cover = StaticCover.get(tier.."ContainerSingle")
    container.bottom_cover = StaticCover.get(tier.."ContainerBottom")
    container.middle_cover = StaticCover.get(tier.."ContainerMiddle")
    container.top_cover = StaticCover.get(tier.."ContainerTop")
    container.connector_cover = StaticCover.get("FluidInput")
end

return function(name, tier, level)
    return { logic_init = logic }
end