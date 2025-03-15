require('Blocks/common')

local logic = function(self)
    local crafter = ComputerBlockLogic.cast(self)

    local energy = 20

    local inv = ResourceInventory.new(crafter, "rii")
    inv.item = StaticItem.find("LV")
    inv.capacity = VanillaConsumptionF(crafter, energy)
    inv.drain = math.floor(inv.capacity / 8)
    crafter.energy_inventory = inv

    local acc = ResourceAccessor.new(crafter, "rai")
    acc.side, acc.pos = Vec3i.back, Vec3i.zero
    acc.inventory = inv
    acc.is_input = true
    acc.channel = "LV"
    acc.cover = StaticCover.find("ElectricityInput")
    crafter.energy_input = acc
end

return { logic_init = logic }