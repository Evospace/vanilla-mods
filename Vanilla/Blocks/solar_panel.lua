local energy = 500

local function get_consumption(level, value)
    return math.pow(3.0, level) * value
end

local logic = function(self)
    local crafter = AbstractCrafter.cast(self)
    crafter.recipes = RecipeDictionary.find("GeneratorRecipeDictionary")
    crafter.speed = 100
    crafter.stable_supply = false

    local inv = ResourceInventory.new(crafter, "rio")
    inv.item = StaticItem.find("Electricity")
    inv.capacity = get_consumption(crafter.static_block.level, energy)
    crafter.energy_output_inventory = inv

    local acc = ResourceAccessor.new(crafter, "rao")
    acc.side, acc.pos = Vec3i.back, Vec3i.new(-1,0,0)
    acc.inventory = inv
    acc.is_output = true
    acc.channel = "Electricity"
    acc.cover = StaticCover.find("ElectricityOutput")
end

return function(name, tier, level)
    LocData.set(name, Loc.gui_number(get_consumption(level, energy) * 20))
    return { logic_init = logic }
end