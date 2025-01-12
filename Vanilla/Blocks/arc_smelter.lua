require('Blocks/common')

local get_capacity = function(crafter)
    return math.pow(2.0, crafter.static_block.level) * 100
end

local get_speed = function(crafter)
    return math.pow(2.0, crafter.static_block.level) * 100
end

local logic = function(self)
    local crafter = AbstractCrafter.cast(self)
    crafter.recipes = RecipeDictionary.find("ArcSmelterRecipeDictionary")
    crafter.speed = get_speed(crafter)
            
    local inv = ResourceInventory.new(crafter, "InputInv")
    inv.item = StaticItem.find("Electricity")
    inv.capacity = get_capacity(crafter)
    crafter.energy_input_inventory = inv
    
    local acc = ResourceAccessor.new(crafter, "Input1")
    acc.side, acc.pos = Vec3i.back, Vec3i.new( -1, 1, 0 )
    acc.inventory = inv
    acc.is_input = true
    acc.channel = "Electricity"
    acc.cover = StaticCover.find("ElectricityInput")
end

return { logic_init = logic }