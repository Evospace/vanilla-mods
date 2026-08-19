local logic = function(self)
    local booster = BoosterBlockLogic.cast(self)
    booster.boost = 50 * (booster.static_block.level + 1)
    booster.cost_ratio = 100

    local inv = ResourceInventory.new(booster, "rii")
    inv.item = StaticItem.get("Electricity")
    booster.energy_input_inventory = inv

    local acc = ResourceAccessor.new(booster, "rai")
    acc.side, acc.pos = Vec3i.left, Vec3i.zero
    acc.inventory = inv
    acc.is_input = true
    acc.channel = "Electricity"
    acc.cover = StaticCover.get("ElectricityInput")
end

return function(name, tier, level)
    return { logic_init = logic }
end
