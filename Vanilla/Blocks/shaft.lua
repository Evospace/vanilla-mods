local logic = function(self)
    local conductor = KineticConductorBlockLogic.cast(self)

    local sides = {
        Vec3i.back, Vec3i.front, Vec3i.right, Vec3i.left, Vec3i.down, Vec3i.up
    }

    for index, side in pairs(sides) do
        local acc = ResourceAccessor.new(conductor, "Kinetic"..index)
        acc.side, acc.pos = side, Vec3i.zero
        acc.channel = "Kinetic"
        conductor:add_wire(acc)
    end

    conductor.side_cover = StaticCover.get("ShaftArm")
    conductor.center_cover = StaticCover.get("GearboxHousing")
    conductor.straight_cover = StaticCover.get("ShaftStraightCoupled")
    conductor.straight_plain_cover = StaticCover.get("ShaftStraight")
    conductor.always_center = true
    conductor.drain = 2
    conductor.capacity = 200
    conductor.conductor_channel = 4000
    conductor.channel = "Kinetic"
end

return function(name, tier, level)
    return { logic_init = logic }
end
