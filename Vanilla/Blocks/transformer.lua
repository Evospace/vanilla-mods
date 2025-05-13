local logic = function(self)
    local crafter = Transformer.cast(self)
    crafter.capacity = 400
    if crafter.static_block.tier > 1 then
        crafter.capacity = 4000
    end
end

return { logic_init = logic }