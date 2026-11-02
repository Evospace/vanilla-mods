local logic = function(self)
    local accumulator = KineticAccumulatorBlockLogic.cast(self)

    local acc = ResourceAccessor.new(accumulator, "Kinetic")
    acc.side, acc.pos = Vec3i.front, Vec3i.zero
    acc.channel = "Kinetic"
    acc.cover = StaticCover.get("KineticInput")
    accumulator:add_wire(acc)

    accumulator.side_cover = StaticCover.get("FlywheelPort")
    accumulator.drain = 4
    accumulator.capacity = 2560000 * 2 ^ accumulator.static_block.level
    accumulator.conductor_channel = 4000
    accumulator.channel = "Kinetic"
end

return function(name, tier, level)
    return { logic_init = logic }
end
