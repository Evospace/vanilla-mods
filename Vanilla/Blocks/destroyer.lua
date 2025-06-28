local logic = function(self)
    -- local crafter = AbstractCrafter.cast(self)
    -- crafter.recipes = RecipeDictionary.find("DestroyerRecipeDictionary")
    -- crafter.speed = (crafter.static_block.level + 1)*100
            
    -- local inv = ResourceInventory.new(crafter, "rii")
    -- inv.capacity = 20
    -- crafter.energy_input_inventory = inv
    
    -- local acc = ResourceAccessor.new(crafter, "FluidInput")
    -- acc.side, acc.pos = Vec3i.back, Vec3i.zero
    -- acc.channel = "Fluid"
    -- acc.is_input = true
    -- acc.cover = StaticCover.find("FluidInput")
    -- acc.inventory = inv
end

return function(name, tier, level)
    LocData.set(name, Vlib.ToPower(level, 1))
    return { logic_init = logic }
end