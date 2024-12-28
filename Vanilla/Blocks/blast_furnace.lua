require('Blocks/common')

local logic = function(self)
    local crafter = AbstractCrafter.cast(self)
    crafter.recipes = RecipeDictionary.find("BlastFurnaceRecipeDictionary")
    crafter.speed = (crafter.static_block.level + 1)*100
end

return { logic_init = logic }