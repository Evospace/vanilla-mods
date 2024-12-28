require('Blocks/common')

local logic = function(self)
    local crafter = AbstractCrafter.cast(self)
    crafter.recipes = RecipeDictionary.find("CompactGeneratorRecipeDictionary")
    crafter.speed = (crafter.static_block.level + 1)*100
        
    local inv = ResourceInventory.new(crafter, "InputInv")
    inv.item = StaticItem.find("Kinetic")
    inv.capacity = 20
    crafter.energy_input_inventory = inv

    local acc = ResourceAccessor.new(crafter, "Input2")
    acc.side, acc.pos = Vec3i.front, Vec3i.zero
    acc.inventory = inv
    acc.is_input = true
    acc.channel = "Kinetic"
    acc.cover = StaticCover.find("KineticInput")

    local inv = ResourceInventory.new(crafter, "OutputInv")
    inv.item = StaticItem.find("Electricity")
    inv.capacity = 20
    crafter.energy_output_inventory = inv

    local acc = ResourceAccessor.new(crafter, "Output")
    acc.side, acc.pos = Vec3i.back, Vec3i.zero
    acc.inventory = inv
    acc.is_output = true
    acc.channel = "Electricity"
    acc.cover = StaticCover.find("ElectricityOutput")
end

return { logic_init = logic }