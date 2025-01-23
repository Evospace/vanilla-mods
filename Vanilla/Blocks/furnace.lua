require('Blocks/common')

local get_production = function(crafter)
    return math.pow(2.0, crafter.static_block.level) * 30
end

local get_speed = function(crafter)
    return math.pow(2.0, crafter.static_block.level) * 100
end

local logic = function(self)
    local crafter = AbstractCrafter.cast(self)
    crafter.recipes = RecipeDictionary.find("FurnaceRecipeDictionary")
    crafter.speed = get_speed(crafter)
            
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
end

return { logic_init = logic }