local logic = function(self)
    local crafter = AbstractCrafter.cast(self)
    crafter.recipes = RecipeDictionary.find("HandRecipeDictionary")
    crafter.speed = Vlib.get_speed(crafter)

    local inv = ResourceInventory.new(crafter, "rii")
    inv.item = StaticItem.find("LV")
    inv.capacity = Vlib.get_consumption(crafter, 20)
    crafter.energy_input_inventory = inv
    
    local acc = ResourceAccessor.new(crafter, "rai")
    acc.side, acc.pos = Vec3i.front, Vec3i.zero
    acc.inventory = inv
    acc.is_input = true
    acc.channel = "LV"
    acc.cover = StaticCover.find("ElectricityInput")
end

return { logic_init = logic }