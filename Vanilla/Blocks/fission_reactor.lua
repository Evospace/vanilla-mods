local energy = Balance.industrial_boiler_per_tick

local logic = function(self)
    local crafter = AbstractCrafter.cast(self)
    crafter.recipes = RecipeDictionary.find("FissionReactorRecipeDictionary")
    crafter.speed = 100
    crafter.load_independent = true
    --crafter.map_register = true
    
    local inv = ResourceInventory.new(crafter, "rio")
    inv.item = StaticItem.find("Heat")
    inv.capacity = Vlib.get_consumption(crafter, energy)
    crafter.energy_output_inventory = inv

    local outputs = {
        {Vec3i.left, Vec3i.new(0, 1, 0)},
        {Vec3i.front, Vec3i.new(0, 1, 0)},
        {Vec3i.front, Vec3i.new(0, -2, 0)},
        {Vec3i.right, Vec3i.new(0, -2, 0)},
        {Vec3i.left, Vec3i.new(-3, 1, 0)},
        {Vec3i.back, Vec3i.new(-3, 1, 0)},
        {Vec3i.back, Vec3i.new(-3, -2, 0)},
        {Vec3i.right, Vec3i.new(-3, -2, 0)}
    }

    for index, value in ipairs(outputs) do
        local acc = ResourceAccessor.new(crafter, "rao"..index)
        acc.side, acc.pos = value[1], value[2]
        acc.inventory = inv
        acc.is_output = true
        acc.channel = "Heat"
        acc.cover = StaticCover.find("HeatOutput")
    end
end

return function(name, tier, level)
    LocData.set(name, Vlib.ToPower(energy, level))
    return { logic_init = logic }
end