local logic = function(self)
    local rack = ItemRackBlockLogic.cast(self)
    rack.capacity = 2048 * (rack.static_block.level + 1)

    local acc = BaseInventoryAccessor.new(rack, "InputAccessor")
    acc.side, acc.pos = Vec3i.front, Vec3i.zero
    acc.input = rack.storage_access
end

return function(name, tier, level)
    return { logic_init = logic }
end
