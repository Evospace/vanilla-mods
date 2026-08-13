
local logic = function(self)
    local crafter = AbstractCrafter.cast(self)
    crafter.recipes = RecipeDictionary.get("FluidFurnaceRecipeDictionary")
    crafter.speed = Vlib.get_speed(crafter)
    crafter.stable_supply = false
    --crafter.map_register = true
            
    local inv = ResourceInventory.new(crafter, "rio")
    inv.item = StaticItem.get("Heat")
    crafter.energy_output_inventory = inv
    
    local acc = ResourceAccessor.new(crafter, "rao")
    acc.side, acc.pos = Vec3i.up, Vec3i.zero
    acc.inventory = inv
    acc.is_output = true
    acc.channel = "Heat"
    acc.cover = StaticCover.get("HeatOutput")

    local inv = ResourceInventory.new(crafter, "rii")
    inv.capacity = 2000
    crafter.crafter_input_container:bind(inv)
    
    local acc = ResourceAccessor.new(crafter, "rai")
    acc.side, acc.pos = Vec3i.back, Vec3i.zero
    acc.inventory = inv
    acc.channel = "Fluid"
    acc.cover = StaticCover.get("FluidInput")
    acc.is_input = true
end

return function(name, tier, level)
    return { logic_init = logic }
end