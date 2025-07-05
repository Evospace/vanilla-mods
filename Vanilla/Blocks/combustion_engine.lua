local energy = Balance.industrial_boiler_per_tick / 2

local logic = function(self)
    local crafter = AbstractCrafter.cast(self)
    crafter.recipes = RecipeDictionary.find("CombustionEngineRecipeDictionary")
    crafter.speed = Vlib.get_speed(crafter)
    crafter.stable_supply = false
        
    local inv = ResourceInventory.new(crafter, "rio")
    inv.item = StaticItem.find("Kinetic")
    inv.capacity = Vlib.get_consumption(crafter, energy)
    crafter.energy_output_inventory = inv
    
    local acc = ResourceAccessor.new(crafter, "Output")
    acc.side, acc.pos = Vec3i.right, Vec3i.new(-1, 0, 0)
    acc.inventory = inv
    acc.is_output = true
    acc.channel = "Kinetic"
    acc.cover = StaticCover.find("KineticOutput")
    
    local inv = ResourceInventory.new(crafter, "rii")
    inv.capacity = 3000
    crafter.crafter_input_container:bind(inv)
    
    local acc = ResourceAccessor.new(crafter, "Input")
    acc.side, acc.pos = Vec3i.front, Vec3i.new(0, 0, 0)
    acc.inventory = inv
    acc.channel = "Fluid"
    acc.cover = StaticCover.find("FluidInput")
    acc.is_input = true
end

return function(name, tier, level)
    LocData.set(name, Vlib.ToPower(energy, level))
    return { logic_init = logic }
end