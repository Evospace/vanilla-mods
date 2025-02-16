require('Blocks/common')

local logic = function(self)
    local crafter = AbstractCrafter.cast(self)
    crafter.recipes = RecipeDictionary.find("BlastFurnaceRecipeDictionary")
    crafter.speed = VanillaSpeedF(crafter)
end

return { logic_init = logic }