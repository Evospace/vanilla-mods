require('Blocks/common')

local get_production = function(crafter)
    return math.pow(2.0, crafter.static_block.level) * 30
end

local logic = function(self)
    local crafter = AbstractCrafter.cast(self)
    crafter.recipes = RecipeDictionary.find("GeneratorRecipeDictionary")
    crafter.stable_supply = false
            
    local inv = ResourceInventory.new(crafter, "OutputInv")
    inv.item = StaticItem.find("Heat")
    inv.capacity = get_production(crafter)
    crafter.energy_output_inventory = inv
    
    local acc = ResourceAccessor.new(crafter, "Output")
    acc.side, acc.pos = Vec3i.up, Vec3i.zero
    acc.inventory = inv
    acc.is_output = true
    acc.channel = "Heat"
    acc.cover = StaticCover.find("HeatOutput")

    local inv = ResourceInventory.new(crafter, "InputInv")
    inv.item = StaticItem.find("Electricity")
    inv.capacity = get_production(crafter)
    crafter.energy_input_inventory = inv
    
    local acc = ResourceAccessor.new(crafter, "Input1")
    acc.side, acc.pos = Vec3i.back, Vec3i.zero
    acc.inventory = inv
    acc.is_input = true
    acc.channel = "Electricity"
    acc.cover = StaticCover.find("ElectricityInput")
end

return { logic_init = logic }