
local logic = function(self)
    local crafter = AbstractCrafter.cast(self)
    crafter.recipes = RecipeDictionary.get("HandRecipeDictionary")
    crafter.speed = Vlib.get_speed(crafter)

    local inv = ResourceInventory.new(crafter, "rii")
    inv.item = StaticItem.get("Electricity")
    crafter.energy_input_inventory = inv
    
    local acc = ResourceAccessor.new(crafter, "rai")
    acc.side, acc.pos = Vec3i.front, Vec3i.zero
    acc.inventory = inv
    acc.is_input = true
    acc.channel = "Electricity"
    acc.cover = StaticCover.get("ElectricityInput")
end

return function(name, tier, level)
    return { logic_init = logic }
end