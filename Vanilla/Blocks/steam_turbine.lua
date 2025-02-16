require('Blocks/common')

local get_production = function(crafter)
    return math.pow(2.0, crafter.static_block.level) * 240
end

local logic = function(self)
    local crafter = AbstractCrafter.cast(self)
    crafter.recipes = RecipeDictionary.find("GeneratorRecipeDictionary")
    crafter.speed = 100
    crafter.stable_supply = false
        
    local inv = ResourceInventory.new(crafter, "OutputInv")
    inv.item = StaticItem.find("Kinetic")
    inv.capacity = get_production(crafter)
    crafter.energy_output_inventory = inv
    
    local acc = ResourceAccessor.new(crafter, "Output")
    acc.side, acc.pos = Vec3i.front, Vec3i.zero
    acc.inventory = inv
    acc.channel = "Kinetic"
    acc.cover = StaticCover.find("KineticOutput")
    acc.is_output = true
    
    local inv = ResourceInventory.new(crafter, "InputInv")
    inv.item = StaticItem.find("Steam")
    inv.capacity = get_production(crafter)
    crafter.energy_input_inventory = inv
    
    local acc = ResourceAccessor.new(crafter, "Input")
    acc.side, acc.pos = Vec3i.up, Vec3i.new(0, 0, 1)
    acc.inventory = inv
    acc.channel = "Fluid"
    acc.cover = StaticCover.find("FluidInput")
    acc.is_input = true
end

return { logic_init = logic }