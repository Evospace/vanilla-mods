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
end

function VanillaMod.pre_init()
end

function VanillaMod.post_init()
end

db:mod(VanillaMod)
