local energy = 20

local logic = function(self)
    local crafter = AbstractCrafter.cast(self)
    crafter.recipes = RecipeDictionary.find("GeneratorRecipeDictionary")
    crafter.speed = 100
    crafter.stable_supply = false
    --crafter.map_register = true
        
    local inv = ResourceInventory.new(crafter, "rii")
    inv.item = StaticItem.find("Kinetic")
    inv.capacity = Vlib.get_consumption(crafter, energy)
    crafter.energy_input_inventory = inv
    
    local acc = ResourceAccessor.new(crafter, "rai")
    acc.side, acc.pos = Vec3i.left, Vec3i.zero
    acc.inventory = inv
    acc.is_input = true
    acc.channel = "Kinetic"
    acc.cover = StaticCover.find("KineticInput")
    
    local inv = ResourceInventory.new(crafter, "rio")
    inv.item = StaticItem.find("Heat")
    inv.capacity = Vlib.get_consumption(crafter, energy)
    crafter.energy_output_inventory = inv
    
    local acc = ResourceAccessor.new(crafter, "rao")
    acc.side, acc.pos = Vec3i.right, Vec3i.zero
    acc.inventory = inv
    acc.is_output = true
    acc.channel = "Heat"
    acc.cover = StaticCover.find("HeatOutput")
end

return function(name, tier, level)
    LocData.set(name, Vlib.ToPower(energy, level))
    return { logic_init = logic }
end