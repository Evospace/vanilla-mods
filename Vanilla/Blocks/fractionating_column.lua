local logic = function(self)
    local crafter = AutoCrafter.cast(self)
    crafter.recipes = RecipeDictionary.find("FractionatingColumnRecipeDictionary")
    crafter.speed = Vlib.get_speed(crafter)
    crafter.ignore_extra_slots = true

    local inv = ResourceInventory.new(crafter, "rii")
    inv.item = StaticItem.find("Electricity")
    inv.capacity = Vlib.get_consumption(crafter, 20)
    crafter.energy_input_inventory = inv
    
    local acc = ResourceAccessor.new(crafter, "rai")
    acc.side, acc.pos = Vec3i.back, Vec3i.back
    acc.inventory = inv
    acc.is_input = true
    acc.cover = StaticCover.find("ElectricityInput")
    acc.channel = "Electricity"

    local acc = ResourceAccessor.new(crafter, "rai_")
    acc.side, acc.pos = Vec3i.left, Vec3i.left
    acc.is_input = true
    acc.channel = "Fluid"
    acc.cover = StaticCover.find("FluidInput")

    local acc = ResourceAccessor.new(crafter, "rao")
    acc.side, acc.pos = Vec3i.front, Vec3i.front + Vec3i.up
    acc.is_output = true
    acc.channel = "Fluid"
    acc.cover = StaticCover.find("FluidOutput")
end

return { logic_init = logic }