require('balance')

local vanilla_mod = {}

function vanilla_mod.pre_init()
end

function vanilla_mod.init()
   local es = EventSystem.get_instance()

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

   local ss = StaticStructure.reg("StartPlatform")

   -- @param context table
   ss.generate = function(context)
      local block = StaticBlock.find("BasicPlatform")
      local gen_zero = context.pos * Vec2i.new(cs.sector_size.x, cs.sector_size.y)
      local z_start = 2
      local platform_size = 11
      for i=0, platform_size - 1 do
         for j=0, platform_size - 1 do

            dim:set_cell(Vec3i.new(i + gen_zero.x, j + gen_zero.y, z_start), block)
            for k=0, 20 do
               dim:set_cell(Vec3i.new(i + gen_zero.x, j + gen_zero.y, z_start + 1 + k), nil)
            end

            for k=0, 10 do
               dim:set_cell(Vec3i.new(gen_zero.x, gen_zero.y, z_start - 1 - k), block)
               dim:set_cell(Vec3i.new(gen_zero.x + platform_size - 1, gen_zero.y, z_start - 1 - k), block)
               dim:set_cell(Vec3i.new(gen_zero.x, gen_zero.y + platform_size - 1, z_start - 1 - k), block)
               dim:set_cell(Vec3i.new(gen_zero.x + platform_size - 1, gen_zero.y + platform_size - 1, z_start - 1 - k), block)
            end
         end
      end

      local block = StaticBlock.find("CopperSpawner")
      dim:spawn_block_identity(Vec3i.new(gen_zero.x, gen_zero.y, z_start + 1), block)
   end
   ss.size = Vec2i.new(10, 10)

   es:sub(defines.events.on_region_spawn, function(region) 
      print("On region spawn "..tostring(region.pos))

      if region.pos.x == 0 and region.pos.y == 0 then
         local ms = MapStructure.new()
         ms.structure = ss
         ms.offset = Vec2i.zero

         region:add_structure(ms)
         print("Spawn platform at "..tostring(region.pos))
      end
   end)

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
