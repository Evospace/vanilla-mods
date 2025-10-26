local energy = 160

local logic = function(self)
    local cover = DesignableCoverBlockLogic.cast(self)
    cover.cover_set = StaticCoverSet.find("Stairs")
    print(123123123)
end

return function(name, tier, level)
    return { logic_init = logic }
end