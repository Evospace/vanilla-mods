local energy = Balance.industrial_boiler_per_tick * 4 * 2

local logic = function(self)
    local crafter = AbstractCrafter.cast(self)
    crafter.recipes = RecipeDictionary.find("PortalRecipeDictionary")
    crafter.speed = Vlib.get_speed(crafter)
    crafter.map_register = true
        
    local inv = ResourceInventory.new(crafter, "rii")
    inv.item = StaticItem.find("Electricity")
    inv.capacity = Vlib.get_consumption(crafter, energy)
    crafter.energy_input_inventory = inv
    
    local acc = ResourceAccessor.new(crafter, "rai")
    acc.side, acc.pos = Vec3i.front, Vec3i.new(0,1,1)
    acc.inventory = inv
    acc.is_input = true
    acc.channel = "Electricity"
    acc.cover = StaticCover.find("ElectricityInput")

    local acc = ResourceAccessor.new(crafter, "rai_")
    acc.side, acc.pos = Vec3i.left, Vec3i.new(0,1,1)
    acc.inventory = inv
    acc.is_input = true
    acc.channel = "Electricity"
    acc.cover = StaticCover.find("ElectricityInput")

    local acc = ResourceAccessor.new(crafter, "rai_1")
    acc.side, acc.pos = Vec3i.front, Vec3i.new(0,-5,1)
    acc.inventory = inv
    acc.is_input = true
    acc.channel = "Electricity"
    acc.cover = StaticCover.find("ElectricityInput")

    local acc = ResourceAccessor.new(crafter, "rai_1")
    acc.side, acc.pos = Vec3i.right, Vec3i.new(0,-5,1)
    acc.inventory = inv
    acc.is_input = true
    acc.channel = "Electricity"
    acc.cover = StaticCover.find("ElectricityInput")
end

return function(name, tier, level)
    LocData.set(name, Vlib.ToPower(energy, level))
    return { logic_init = logic }
end