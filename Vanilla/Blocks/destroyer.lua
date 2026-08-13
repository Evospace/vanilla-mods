local logic = function(self)
    -- local crafter = AbstractCrafter.cast(self)
    -- crafter.recipes = RecipeDictionary.get("DestroyerRecipeDictionary")
    -- crafter.speed = (crafter.static_block.level + 1)*100
            
    -- local inv = ResourceInventory.new(crafter, "rii")
    -- inv.capacity = 20
    -- crafter.energy_input_inventory = inv
    
    -- local acc = ResourceAccessor.new(crafter, "FluidInput")
    -- acc.side, acc.pos = Vec3i.back, Vec3i.zero
    -- acc.channel = "Fluid"
    -- acc.is_input = true
    -- acc.cover = StaticCover.get("FluidInput")
    -- acc.inventory = inv
end

return function(name, tier, level)
    return { logic_init = logic }
end