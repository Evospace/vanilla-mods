local poles = {
    PowerPole = {
        reach = 10,
        points = { Vec3.new(0, -35, 335), Vec3.new(0, 35, 335) },
    },
    PowerTower = {
        reach = 32,
        points = { Vec3.new(50, -40, 830), Vec3.new(50, 140, 830) },
    },
}

return function(name, tier, level)
    local spec = poles[name]

    local logic = function(self)
        local pole = PowerPoleBlockLogic.cast(self)

        local acc = ResourceAccessor.new(pole, "Wire")
        acc.side, acc.pos = Vec3i.back, Vec3i.zero
        acc.channel = "Electricity"
        acc.cover = StaticCover.get("ElectricityInput")
        pole:add_wire(acc)

        pole.conductor_channel = 1000
        pole.channel = "Electricity"
        pole.reach = spec.reach
        pole.wire_cover = StaticCover.get("PowerWire")
        pole.head_cover = StaticCover.get(name .. "Head")
        for _, point in ipairs(spec.points) do
            pole:add_wire_point(point)
        end
    end

    return { logic_init = logic }
end
