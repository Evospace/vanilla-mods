local logic = function(self)
    local fence = DesignableFenceBlockLogic.cast(self)
    if fence ~= nil then
        -- Fence block - set CoverSet and covers from Lua
        fence.cover_set = StaticCoverSet.find(fence.static_block.name)
        if fence.cover_set and fence.cover_set.covers and #fence.cover_set.covers > 0 then
            fence.half_cover = fence.cover_set.covers[1]
        end
        fence.center_cover = StaticCover.find("FenceCenter")
        return
    end
    
    local cover = DesignableCoverBlockLogic.cast(self)
    if cover ~= nil then
        cover.cover_set = StaticCoverSet.find(cover.static_block.name)
    end
end

return function(name, tier, level)
    return { logic_init = logic }
end