local logic = function(self)
    local crafter = AbstractCrafter.cast(self)
    crafter.recipes = RecipeDictionary.find("BlastFurnaceRecipeDictionary")
    crafter.speed = Vlib.get_speed(crafter)

    Vlib.add_single_slot_invs(crafter.crafter_input_container, crafter, "ii", 2)
    Vlib.add_single_slot_invs(crafter.crafter_output_container, crafter, "io", 1)
end

return { logic_init = logic }