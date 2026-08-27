
local logic = function(self)
    local crafter = AbstractCrafter.cast(self)
    crafter.recipes = RecipeDictionary.get("BoilerRecipeDictionary")
    crafter.speed = 100
    crafter.stable_supply = false
    -- crafter.map_register = true

    local inv = ResourceInventory.new(crafter, "rii_")
    inv.item = StaticItem.get("Water")
    inv.capacity = 1000
    crafter.crafter_input_container:bind(inv)

    local acc = ResourceAccessor.new(crafter, "rai")
    acc.side, acc.pos = Vec3i.back, Vec3i.zero
    acc.is_input = true
    acc.channel = "Fluid"
    acc.inventory = inv
    acc.cover = StaticCover.get("FluidInput")

    local inv = ResourceInventory.new(crafter, "rii")
    crafter.energy_input_inventory = inv

    local acc = ResourceAccessor.new(crafter, "rai_")
    acc.side, acc.pos = Vec3i.down, Vec3i.zero
    acc.inventory = inv
    acc.is_input = true
    acc.channel = "Heat"
    acc.cover = StaticCover.get("HeatInput")

    local inv = ResourceInventory.new(crafter, "rio")
    crafter.energy_output_inventory = inv

    local acc = ResourceAccessor.new(crafter, "rao")
    acc.side, acc.pos = Vec3i.up, Vec3i.zero
    acc.inventory = inv
    acc.is_output = true
    acc.channel = "Fluid"
    acc.cover = StaticCover.get("FluidOutput")
end

return function(name, tier, level)
    return { logic_init = logic }
end