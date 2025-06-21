require('balance')

local vanilla_mod = {}

function vanilla_mod.pre_init()
end

function vanilla_mod.init()
   local es = EventSystem.get_instance()

   -- es:sub(defines.events.on_player_at_sector, function(context) 
   --    --local pos = context.pos * cs.sector_size + Vec3i.new(0,0,23)
   --    --print("On sector "..tostring(pos)) 
   --    --local block = StaticBlock.find("CopperMacerator")
   --    --dim:spawn_block_identity(pos, block)
   --    local grid_pos = LargeSectors.world_block_to_grid(pos)
   --    if not regions:has_region(grid_pos) then
   --       local region = regions:get_region(grid_pos)

   --       local ms = MapStructure.new()
   --       ms.structure = ss
   --       ms.position = Vec2i.zero()

   --       region:add_structure(ms)
   --    end
   -- end)

   -- local oreProps = StaticPropList.find("OreProps")

   -- local resources = {}
   -- for _, value in ipairs(oreProps.data[1].props) do
   --    -- assuming value is a string like "RubyCluster"
   --    local base = value.name:gsub("Cluster$", "") -- remove "Cluster" from the end
   --    table.insert(resources, {base, 1})
   --    print("Ore "..base.." preparation")
   -- end

   -- for _, value in ipairs(resources) do
   --    local ed = ExtractionData.new()
   --    ed.item = StaticItem.find(value[1].."Ore")
   --    ed.speed = 100
   --    ed.prop = StaticProp.find(value[1].."Cluster")
   --    regions:add_resource(ed)
   -- end

   for _, proto in pairs(db:objects()) do
      local block = StaticBlock.cast(proto)
      if block ~= nil then
         block.lua = { actor_init = Vlib.CommonActorInit, tooltip = Vlib.CommonActorTooltip }
      end
   end

   require('Blocks/all')

   local ss = StaticStructure.new("StartPlatform")
   --ss.generate = function(_) print("11111111111") end TODO: lua ref leak
   ss.size = Vec2i.new(10, 10)

   -- local oreGeneratorCounter = 1
   -- for _, ore in ipairs(resources) do
   --    local ore_name = ore[1]
   --    local ore = StaticProp.find(ore_name.."Cluster")
   --    if ore then 
   --       print("Registering "..ore_name.."Cluster".." on_entity_spawn subscription")
   --    else
   --       print(ore_name.."Cluster not found, skipping")
   --    end
   --    ore.on_spawn = function(prop, pos)
   --       --print(dump(ore))
   --       --print(dump(context.prop))
   --       if prop == ore then
   --          local spos = RegionMap.world_block_to_grid(pos)
   --          local position = Vec2i.new(pos.x, pos.y)
   --          local old_reg = regions:find_source(pos)
   --          if old_reg ~= nil and old_reg.position == position then
   --             Vlib.verbose("same "..tostring(ore.item))
   --             return
   --          else
   --             Vlib.verbose("new "..tostring(ore.item))
   --          end
   --          local region = regions:get_region(spos)
   --          local sd = SourceData.new_simple()
   --          oreGeneratorCounter = oreGeneratorCounter + 1
   --          sd.item = StaticItem.find(ore_name.."Ore")
   --          sd.position = position
   --          region:add_source(sd)
   --       end
   --    end
   -- end
end

function vanilla_mod.post_init()
end

db:mod(vanilla_mod)
