local logic = function(self)
    local pad = PortalProjectBlockLogic.cast(self)
    pad.stages = RecipeDictionary.get("RocketPadStageRecipeDictionary")

    local inputs = {
        { "pfi_front", Vec3i.front, Vec3i.new(0, 0, 0) },
        { "pfi_back", Vec3i.back, Vec3i.new(-7, -1, 0) },
        { "pfi_left", Vec3i.left, Vec3i.new(-3, 3, 0) },
        { "pfi_right", Vec3i.right, Vec3i.new(-4, -4, 0) },
    }
    for _, input in ipairs(inputs) do
        local acc = ResourceAccessor.new(pad, input[1])
        acc.side, acc.pos = input[2], input[3]
        acc.is_input = true
        acc.channel = "Fluid"
        acc.cover = StaticCover.get("FluidInput")
    end
end

return function(name, tier, level)
    return { logic_init = logic }
end
