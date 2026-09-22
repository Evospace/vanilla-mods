local inputs = {
    { "fia", Vec3i.front },
    { "bia", Vec3i.back },
    { "ria", Vec3i.right },
}

local logic = function(self)
    local storage = DeepStorageBlockLogic.cast(self)
    storage.capacity = 8192 * 2 * 4 ^ storage.static_block.level

    for _, input in ipairs(inputs) do
        local acc = BaseInventoryAccessor.new(storage, input[1])
        acc.side, acc.pos = input[2], Vec3i.zero
        acc.input = storage.storage_access
    end

    local energy = ResourceInventory.new(storage, "Energy")
    storage.energy = energy

    local acc = ResourceAccessor.new(storage, "lei")
    acc.side, acc.pos = Vec3i.left, Vec3i.zero
    acc.inventory = energy
    acc.is_input = true
    acc.channel = "Electricity"
    acc.cover = StaticCover.get("ElectricityInput")
end

return function(name, tier, level)
    return { logic_init = logic }
end
