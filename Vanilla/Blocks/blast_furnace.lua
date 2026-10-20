local Vlib = require('@VanillaLib/vlib')

local logic = function(self)
    local crafter = AbstractCrafter.cast(self)
    crafter.recipes = RecipeDictionary.get("BlastFurnaceRecipeDictionary")
    crafter.speed = Vlib.get_speed(crafter)
end

return function(name, tier, level)
    return { logic_init = logic }
end