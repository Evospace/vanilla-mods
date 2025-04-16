local logic = function(self)
    local conductor = ConductorBlockLogic.cast(self)

    local channelMap = {
        1000, 1000, 1001, 1001, 1001, 1001, 1002, 1002, 1002
    }

    local resistanceMap = {
        100, 80, 200, 75, 50, 0, 100, 50, 0
    }

    local tierMap = {
        "LV", "LV", "MV", "MV", "MV", "MV", "HV", "HV", "HV"
    }

    local voltageMap = {
        1000, 1000, 10000, 10000, 10000, 10000, 100000, 100000, 100000
    }

    local t = conductor.static_block.tier + 1

    for index, side in pairs(Vlib.sides) do
        local acc = ResourceAccessor.new(conductor, "Wire"..tierMap[t]..index)
        acc.side, acc.pos = side, Vec3i.zero
        acc.channel = tierMap[t]
        conductor:add_wire(acc)
    end

    conductor.side_cover = StaticCover.find(Vlib.cable_array[t])
    conductor.center_cover = StaticCover.find("CableCenter"..tierMap[t])
    conductor.resistance = resistanceMap[t]
    conductor.conductor_channel = channelMap[t]
    conductor.channel = tierMap[t]
    conductor.voltage = voltageMap[t]
end

return { logic_init = logic }