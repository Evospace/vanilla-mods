require('Blocks/common')

local logic = function(self)
    local crafter = AbstractCrafter.cast(self)
    crafter.recipes = RecipeDictionary.find("GeneratorRecipeDictionary")
    crafter.speed = 100
    crafter.stable_supply = false

    local energy = 20
        
    local inv = ResourceInventory.new(crafter, "rii")
    inv.item = StaticItem.find("Kinetic")
    inv.capacity = VanillaConsumptionF(crafter, energy)
    crafter.energy_input_inventory = inv

    local acc = ResourceAccessor.new(crafter, "Input2")
    acc.side, acc.pos = Vec3i.front, Vec3i.zero
    acc.inventory = inv
    acc.is_input = true
    acc.channel = "Kinetic"
    acc.cover = StaticCover.find("KineticInput")

    local inv = ResourceInventory.new(crafter, "rio")
    inv.item = StaticItem.find("LV")
    inv.capacity = VanillaConsumptionF(crafter, energy)
    crafter.energy_output_inventory = inv

    local acc = ResourceAccessor.new(crafter, "Output")
    acc.side, acc.pos = Vec3i.back, Vec3i.zero
    acc.inventory = inv
    acc.is_output = true
    acc.channel = "LV"
    acc.cover = StaticCover.find("ElectricityOutput")
end

return { logic_init = logic }