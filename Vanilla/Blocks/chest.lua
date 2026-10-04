local logic = function(self)
    local chest = ChestBlockLogic.cast(self)

    local t = chest.static_block.tier

    chest.capacity = 20 + t * 5
end

return function(name, tier, level)
    return { logic_init = logic }
end