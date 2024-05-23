local VanillaMod = {}

function dump(o)
    if type(o) == 'table' then
       local s = '('
       for k,v in pairs(o) do
          s = s .. k ..' = ' .. dump(v) .. ','
       end
       return s .. ')'
    elseif type(o) == 'userdata' then
        return tostring(o)
    else
       return tostring(o)
    end
 end

function VanillaMod.init()
    local es = EventSystem.get_instance()
    es:sub(defines.events.on_player_spawn, function(context)
        print("this is a spawn!")
        print(dump(context))
    end)
    es:sub(defines.events.on_player_mined_item, function(context)
        print("this is a mine!")
        print(dump(context))
    end)
    es:sub(defines.events.on_built_block, function(context)
        --dim:set_block_cell(context.pos + Vec3i.new(0,0,1), StaticBlock.find("BasicPlatform"))
        print("this is a build!")
        print(dump(context))
    end)
end

function VanillaMod.pre_init()
end

function VanillaMod.post_init()
end

db:mod(VanillaMod)
