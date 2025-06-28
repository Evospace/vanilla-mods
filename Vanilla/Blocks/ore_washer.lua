local energy = 20

local logic = function(self)
    local crafter = AbstractCrafter.cast(self)
    crafter.recipes = RecipeDictionary.find("OreWasherRecipeDictionary")
    crafter.speed = Vlib.get_speed(crafter)
            
    local inv = ResourceInventory.new(crafter, "rii")
    inv.item = StaticItem.find("Kinetic")
    inv.capacity = Vlib.get_consumption(crafter, energy)
    crafter.energy_input_inventory = inv

    local acc = ResourceAccessor.new(crafter, "Input")
    acc.side, acc.pos = Vec3i.front, Vec3i.new(0,1,0)
    acc.inventory = inv
    acc.is_input = true
    acc.channel = "Kinetic"
    acc.cover = StaticCover.find("KineticInput")

    Vlib.add_single_slot_invs(crafter.crafter_input_container, crafter, "ii", 1)

    local inv = ResourceInventory.new(crafter, "rio")
    inv.item = StaticItem.find("Water")
    inv.capacity = 1000
    crafter.crafter_input_container:bind(inv)

    Vlib.add_single_slot_invs(crafter.crafter_output_container, crafter, "io", 2)

    local acc = ResourceAccessor.new(crafter, "Input2")
    acc.side, acc.pos = Vec3i.right, Vec3i.new(-2,0,1)
    acc.is_input = true
    acc.channel = "Fluid"
    acc.cover = StaticCover.find("FluidInput")
    acc.inventory = inv
end

return function(name, tier, level)
    LocData.set(name, Vlib.ToPower(energy, level))
    return { logic_init = logic }
end