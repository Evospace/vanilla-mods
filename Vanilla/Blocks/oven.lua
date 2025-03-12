require('Blocks/common')

local logic = function(self)
    local crafter = AbstractCrafter.cast(self)
    crafter.recipes = RecipeDictionary.find("OvenRecipeDictionary")
    crafter.speed = VanillaSpeedF(crafter)

    Vlib.add_single_slot_invs(crafter.crafter_input_container, crafter, "ii", 1)
    Vlib.add_single_slot_invs(crafter.crafter_output_container, crafter, "io", 1)

    local inv = ResourceInventory.new(crafter, "rii")
    inv.item = StaticItem.find("Heat")
    inv.capacity = VanillaConsumptionF(crafter, 100)
    crafter.energy_input_inventory = inv

    local acc = ResourceAccessor.new(crafter, "rai")
    acc.side, acc.pos = Vec3i.down, Vec3i.new(-1,1,1)
    acc.inventory = inv
    acc.is_input = true
    acc.channel = "Heat"
    acc.cover = StaticCover.find("HeatInput")

    local inv = ResourceInventory.new(crafter, "rio")
    crafter.crafter_output_container:bind(inv)
    inv.capacity = 32000 + 16000 * crafter.static_block.level

    local acc = ResourceAccessor.new(crafter, "rao")
    acc.side, acc.pos = Vec3i.back, Vec3i.new(-2,1,0)
    acc.inventory = inv
    acc.is_output = true
    acc.channel = "Fluid"
    acc.cover = StaticCover.find("FluidOutput")
end

return { logic_init = logic }