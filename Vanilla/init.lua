require 'controls'
require 'graphics'
require 'game_settings'

local vanilla_mod = {}

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


function vanilla_mod.pre_init()
   register_controls()
   register_graphics()
   register_game_settings();
end

function vanilla_mod.init()
   local es = EventSystem.get_instance()

   es:sub(defines.events.on_player_at_sector, function(context) 
      --local pos = context.pos * cs.sector_size + Vec3i.new(0,0,23)
      --print("On sector "..tostring(pos)) 
      --local block = StaticBlock.find("CopperMacerator")
      --dim:spawn_block_identity(pos, block)
      local grid_pos = LargeSectors.world_block_to_grid(pos)
      if not regions:has_region(grid_pos) then
         local region = regions:get_region(grid_pos)

         local ms = MapStructure.new()
         ms.structure = ss
         ms.offset = Vec2i.zero()

         region:add_structure(ms)
      end
   end)

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
      regions:add_resource(ed)
   end

   local ss = StaticStructure.reg("StartPlatform")
   ss.generate = function(context) print("11111111111") end
   ss.size = Vec2i.new(10, 10);
   db:reg(ss)
end

function vanilla_mod.post_init()
end

db:mod(vanilla_mod)
