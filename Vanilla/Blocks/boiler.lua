require('Blocks/common')

local get_production = function(crafter)
    return math.pow(2.0, crafter.static_block.level) * 60
end

local logic = function(self)
    local crafter = AbstractCrafter.cast(self)
    crafter.recipes = RecipeDictionary.find("BoilerRecipeDictionary")
    crafter.speed = 100
        
    local inv = ResourceInventory.new(crafter, "rii")
    inv.item = StaticItem.find("Heat")
    inv.capacity = get_production(crafter)
    crafter.energy_input_inventory = inv

    local acc = ResourceAccessor.new(crafter, "WaterInputAccessor")
    acc.side, acc.pos = Vec3i.back, Vec3i.zero
    acc.is_input = true
    acc.channel = "Fluid"
    acc.cover = StaticCover.find("FluidInput")

    local acc = ResourceAccessor.new(crafter, "HeatInputAccessor")
    acc.side, acc.pos = Vec3i.down, Vec3i.zero
    acc.inventory = inv
    acc.is_input = true
    acc.channel = "Heat"
    acc.cover = StaticCover.find("HeatInput")

    local inv = ResourceInventory.new(crafter, "rio")
    inv.item = StaticItem.find("Steam")
    inv.capacity = get_production(crafter)
    crafter.energy_output_inventory = inv

    local acc = ResourceAccessor.new(crafter, "Output")
    acc.side, acc.pos = Vec3i.up, Vec3i.zero
    acc.inventory = inv
    acc.is_output = true
    acc.channel = "Fluid"
    acc.cover = StaticCover.find("FluidOutput")
end

return { logic_init = logic }