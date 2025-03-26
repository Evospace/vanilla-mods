

local logic = function(self)
    local crafter = AbstractCrafter.cast(self)
    crafter.recipes = RecipeDictionary.find("AtmosphericCondenserRecipeDictionary")
    crafter.speed = Vlib.get_speed(crafter)
    
    local acc = ResourceAccessor.new(crafter, "rao")
    acc.side, acc.pos = Vec3i.front, Vec3i.zero
    acc.channel = "Fluid"
    acc.is_output = true
    acc.cover = StaticCover.find("FluidOutput")
end

return { logic_init = logic }