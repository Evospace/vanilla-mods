local logic = function(self)
    local conductor = ElectricityContainerBlockLogic.cast(self)

    local sides = {
        Vec3i.back, Vec3i.front, Vec3i.right, Vec3i.left, Vec3i.down, Vec3i.up
    }

    local level = conductor.static_block.level

    for index, side in pairs(sides) do
        local acc = ResourceAccessor.new(conductor, "WireElectricity"..index)
        acc.side, acc.pos = side, Vec3i.zero
        acc.channel = "Electricity"
        conductor:add_wire(acc)
    end

    local tier = Vlib.tier_material[conductor.static_block.tier + 1]

    conductor.capacity = 256000 * (level + 1)
    conductor.conductor_channel = 1000
    conductor.channel = "Electricity"
    conductor.single_cover = StaticCover.get(tier.."BatteryBoxSingle")
    conductor.bottom_cover = StaticCover.get(tier.."BatteryBoxBottom")
    conductor.middle_cover = StaticCover.get(tier.."BatteryBoxMiddle")
    conductor.top_cover = StaticCover.get(tier.."BatteryBoxTop")
    conductor.connector_cover = StaticCover.get("ElectricityInput")
end

return function(name, tier, level)
    return { logic_init = logic }
end