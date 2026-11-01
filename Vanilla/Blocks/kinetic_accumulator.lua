local logic = function(self)
    local accumulator = KineticAccumulatorBlockLogic.cast(self)

    local sides = {
        Vec3i.back, Vec3i.front, Vec3i.right, Vec3i.left, Vec3i.down, Vec3i.up
    }

    local inside = function(pos)
        return pos.x >= -1 and pos.x <= 0 and pos.y >= 0 and pos.y <= 1 and pos.z >= 0 and pos.z <= 1
    end

    local index = 0
    for x = -1, 0 do
        for y = 0, 1 do
            for z = 0, 1 do
                local cell = Vec3i.new(x, y, z)
                for _, side in ipairs(sides) do
                    if not inside(cell + side) then
                        index = index + 1
                        local acc = ResourceAccessor.new(accumulator, "Kinetic"..index)
                        acc.side, acc.pos = side, cell
                        acc.channel = "Kinetic"
                        accumulator:add_wire(acc)
                    end
                end
            end
        end
    end

    accumulator.side_cover = StaticCover.get("FlywheelPort")
    accumulator.drain = 2
    accumulator.capacity = 256000 * 2 ^ accumulator.static_block.level
    accumulator.conductor_channel = 4000
    accumulator.channel = "Kinetic"
end

return function(name, tier, level)
    return { logic_init = logic }
end
