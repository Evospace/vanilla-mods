
local logic = function(self)
    local crafter = AbstractCrafter.cast(self)
    crafter.recipes = RecipeDictionary.get("CombustionEngineRecipeDictionary")
    crafter.speed = Vlib.get_speed(crafter)
    -- crafter.stable_supply = false
        
    local inv = ResourceInventory.new(crafter, "rio")
    crafter.energy_output_inventory = inv
    
    local acc = ResourceAccessor.new(crafter, "Output")
    acc.side, acc.pos = Vec3i.right, Vec3i.new(-1, 0, 0)
    acc.inventory = inv
    acc.is_output = true
    acc.channel = "Kinetic"
    acc.cover = StaticCover.get("KineticOutput")
    
    local inv = ResourceInventory.new(crafter, "rii")
    inv.capacity = 3000
    crafter.crafter_input_container:bind(inv)
    
    local acc = ResourceAccessor.new(crafter, "Input")
    acc.side, acc.pos = Vec3i.front, Vec3i.new(0, 0, 0)
    acc.inventory = inv
    acc.channel = "Fluid"
    acc.cover = StaticCover.get("FluidInput")
    acc.is_input = true
end

return function(name, tier, level)
    return { logic_init = logic }
end