require('Blocks/common')

local logic = function(self)
    local crafter = AbstractCrafter.cast(self)
    crafter.recipes = RecipeDictionary.find("AutomaticFarmRecipeDictionary")
    crafter.speed = VanillaSpeedF(crafter)
            
    local acc = ResourceAccessor.new(crafter, "Input")
    acc.side, acc.pos = Vec3i.front, Vec3i.zero
    acc.is_input = true
    acc.channel = "Fluid"
end

return { logic_init = logic }