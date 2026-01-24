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
               dim:clear_props(Vec3i.new(i + gen_zero.x, j + gen_zero.y, z_start + k))
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
      print_info("On region spawn "..tostring(region.pos))

      if region.pos.x == 0 and region.pos.y == 0 then
         local ms = MapStructure.new()
         ms.structure = ss
         ms.offset = Vec2i.zero

         region:add_structure(ms)
         print_info("Spawn platform at "..tostring(region.pos))
      end
   end)

   -- local gen = BiomeWorldGenerator.reg("TEST")

   -- local hg1 = HeightGenerator.reg("TEST_BiomeHeight_Rugged")
   -- local n1 = NoiseGenerator.reg("TEST_BiomeNoise_Rugged")
   -- n1:set_frequency(0.002)
   -- n1:set_fractal_octaves(5)
   -- n1.min = -10
   -- n1.max = 30
   -- hg1:add_noise(n1)

   -- local hg2 = HeightGenerator.reg("TEST_BiomeHeight_Flat")
   -- local n2 = NoiseGenerator.reg("TEST_BiomeNoise_Flat")
   -- n2:set_frequency(0.0005)
   -- n2:set_fractal_octaves(2)
   -- n2.min = -2
   -- n2.max = 5
   -- hg2:add_noise(n2)

   -- local b1 = Biome.reg("TEST_Biome_Rugged")
   -- b1.height = hg1

   -- local b2 = Biome.reg("TEST_Biome_Flat")
   -- b2.height = hg2

   -- local gf = GlobalBiomeFamily.reg("TEST_GlobalBiomeFamily")
   -- gf.sub_biomes = { b1, b2 }

   -- gen.global_biome = gf

   -- ------------

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

   math.randomseed(123)
   local rand = math.random

   ---------------------------------------------------------------------------

   -- Блоки, которые будем использовать
   local BLOCK_PLAT    = StaticBlock.find("TerracottaBricks")       -- плоская платформа
   local BLOCK_WALL    = StaticBlock.find("WoodenPlanks")          -- кусок стены
   local BLOCK_COL_BASE= StaticBlock.find("BasicPlatform")          -- основание колонны
   local BLOCK_COL_SEG = StaticBlock.find("BasicPlatform")      -- сегмент колонны
   local BLOCK_COL_CAP = StaticBlock.find("BasicPlatform")          -- вершина колонны

   ---------------------------------------------------------------------------

   -- === Вспомогательные функции ===

   -- Создаём квадратную платформу
   local function generate_platform(pos)
   local size = rand(4, 7)           -- размер платформы (4-7)
   local h    = dim:sample_height(pos.x, pos.y)
   local z    = math.floor(h)  -- высота платформы по рельефу
   for i = 0, size-1 do
      for j = 0, size-1 do
         local p = Vec3i.new(pos.x + i, pos.y + j, z)
         for k = 0, 2 do
            dim:set_cell(p - Vec3i.new(0, 0, k), BLOCK_PLAT)
         end

         for k = 1, 4 do
            dim:set_cell(p + Vec3i.new(0, 0, k), BLOCK_WALL)
         end
         -- создаём свободный воздух над платформой
         for k = 4, 6 do
            dim:set_cell(p + Vec3i.new(0, 0, k), nil)
            dim:clear_props(p + Vec3i.new(0, 0, k))
         end
      end
   end
   end

   ---------------------------------------------------------------------------

   -- === Основная структура генерации ===

   local RuinsGen = StaticStructure.reg("RuinsGenerator")
      RuinsGen.size = Vec2i.new(10, 10)   -- размер области, в которой генерируются элементы

      RuinsGen.generate = function(ctx)
      local gen_zero = ctx.pos * Vec2i.new(cs.sector_size.x, cs.sector_size.y)

      -- Сколько элементов генерируем
      local count = rand(3, 6)

      for _ = 1, count do
         -- Случайная позиция внутри сектора
         local offset = Vec2i.new(rand(0, 50), rand(0, 50))
         local pos = gen_zero + offset

         generate_platform(pos)
      end
   end

   ---------------------------------------------------------------------------

   -- === Подписка на событие появления региона ===

   -- es:sub(defines.events.on_region_spawn, function(region)
   --    for a = 0, 10 do
   --       local ms = MapStructure.new()
   --       ms.structure = RuinsGen
   --       ms.offset = Vec2i.new(rand(0, 100), rand(0, 100))
   --       region:add_structure(ms)
   --    end
   -- end)
end

function vanilla_mod.post_init()
end

db:mod(vanilla_mod)
