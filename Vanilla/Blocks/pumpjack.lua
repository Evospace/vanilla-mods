local logic = function(self)
    local crafter = DrillingMachineBase.cast(self)
    crafter.production = 500
    crafter.map_register = true
    crafter.productivity = 20 * crafter.static_block.level

    local inv = ResourceInventory.new(crafter, "energy")
    crafter.energy = inv

    local acc = ResourceAccessor.new(crafter, "ria")
    acc.side, acc.pos = Vec3i.back, Vec3i.new(-4, 0, 0)
    acc.inventory = inv
    acc.is_input = true
    acc.channel = "Kinetic"
    acc.cover = StaticCover.get("KineticInput")

    local inv = ResourceInventory.new(crafter, "rii")
    inv.capacity = 10000
    inv.draggable = false
    crafter.inventory:bind(inv)
    crafter.inventory.draggable = false

    local acc = ResourceAccessor.new(crafter, "oa")
    acc.side, acc.pos = Vec3i.front, Vec3i.new(0, 0, 0)
    acc.inventory = inv
    acc.is_output = true
    acc.channel = "Fluid"
    acc.cover = StaticCover.get("FluidOutput")
end

return function(name, tier, level)
    return { logic_init = logic }
end