local VanillaMod = {}

function VanillaMod.init()
    for index, proto in pairs(db:objects()) do
        local block = StaticBlock.cast(proto)
        if block ~= nil and block.logic ~= nil then
            if block.logic:is_child_of(AbstractCrafter.get_class()) then
            end
        end
    end

    
end

function VanillaMod.pre_init()
end

function VanillaMod.post_init()
end

db:mod(VanillaMod)
