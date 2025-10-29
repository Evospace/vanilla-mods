local logic = function(self)
    local cover = DesignableCoverBlockLogic.cast(self)
    cover.cover_set = StaticCoverSet.find(cover.static_block.name)
end

return function(name, tier, level)
    return { logic_init = logic }
end