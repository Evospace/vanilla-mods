require('Blocks/common')

local logic = function(self)
    local crafter = AbstractCrafter.cast(self)
    crafter.recipes = RecipeDictionary.find("GeneratorRecipeDictionary")
    crafter.speed = 100
    crafter.stable_supply = false

    local energy = 240
        
    local inv = ResourceInventory.new(crafter, "rio")
    inv.item = StaticItem.find("MV")
    inv.capacity = VanillaConsumptionF(crafter, energy)
    crafter.energy_output_inventory = inv
    
    local acc = ResourceAccessor.new(crafter, "Output")
    acc.side, acc.pos = Vec3i.front, Vec3i.zero
    acc.inventory = inv
    acc.channel = "MV"
    acc.cover = StaticCover.find("MVOutput")
    acc.is_output = true
    
    local inv = ResourceInventory.new(crafter, "rii")
    inv.item = StaticItem.find("Kinetic")
    inv.capacity = VanillaConsumptionF(crafter, energy)
    crafter.energy_input_inventory = inv
    
    local acc = ResourceAccessor.new(crafter, "Input")
    acc.side, acc.pos = Vec3i.back, Vec3i.new(-1, 1, 0)
    acc.inventory = inv
    acc.channel = "Kinetic"
    acc.cover = StaticCover.find("KineticInput")
    acc.is_input = true
end

return { logic_init = logic }