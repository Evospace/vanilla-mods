local logic = function(self)
    local crafter = AbstractCrafter.cast(self)
    crafter.recipes = RecipeDictionary.find("BlastFurnaceRecipeDictionary")
    crafter.speed = Vlib.get_speed(crafter)
    -- crafter.map_register = true

    Vlib.add_single_slot_invs(crafter.crafter_input_container, crafter, "ii", 2)
    Vlib.add_single_slot_invs(crafter.crafter_output_container, crafter, "io", 1)
end

return function(name, tier, level)
    LocData.set(name, Vlib.ToPower(level, 1))
    return { logic_init = logic }
end