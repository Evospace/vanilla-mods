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

    es:sub(defines.events.on_player_at_sector, function(context) print("On sector "..tostring(context.pos * cs.sector_size)) end)

    local resources = {
      
      {"CopperOre", 1.0},
      {"CoalOre", 1.5},

      {"IronOre", 0.5},
      {"AluminiumOre", 0.25},
      {"UraniumOre", 0.125},
      {"MineralWater", 1.0},
      {"RawOil", 0.5},
    }

    for key, value in ipairs(resources) do
      local ed = ExtractionData.new()
      ed.item = StaticItem.find(value[1])
      ed.speed = value[2]
      deposits:add_resource(ed)
    end
end

function VanillaMod.pre_init()
end

function VanillaMod.post_init()
end

db:mod(VanillaMod)
