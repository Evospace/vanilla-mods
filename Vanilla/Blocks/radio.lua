local logic = function(self)
    local crafter = AbstractCrafter.cast(self)
    crafter.recipes = RecipeDictionary.get("RadioRecipeDictionary")

    local inv = ResourceInventory.new(crafter, "rii")
    crafter.energy_input_inventory = inv

    local acc = ResourceAccessor.new(crafter, "rai")
    acc.side, acc.pos = Vec3i.back, Vec3i.zero
    acc.inventory = inv
    acc.is_input = true
    acc.channel = "Electricity"
    acc.cover = StaticCover.get("ElectricityInput")

    RadioReceiverBlockLogic.cast(self).ether = StaticRadioEther.get("Shortwave")
end

return function(name, tier, level)
    return { logic_init = logic }
end
