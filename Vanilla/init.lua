require('balance')

local vanilla_mod = {}

function vanilla_mod.pre_init()
   Vlib = require('vlib')
end

function vanilla_mod.init()
   local es = EventSystem.get()

   for _, proto in pairs(db:objects()) do
      local block = StaticBlock.cast(proto)
      if block ~= nil then
         block.lua = { actor_init = Vlib.CommonActorInit, tooltip = Vlib.CommonActorTooltip }
      end
   end

   require('Blocks/all')

   require('panels').register()

   local ss = StaticStructure.reg("StartPlatform")

   ss.generate = function(context)
      local block = StaticBlock.find("BasicPlatform")
      local gen_zero = context.pos * Vec2i.new(cs.sector_size.x, cs.sector_size.y)
      local z_start = 2
      local platform_size = 11
      for i=0, platform_size - 1 do
         for j=0, platform_size - 1 do

            context:set_cell(Vec3i.new(i + gen_zero.x, j + gen_zero.y, z_start), block)
            for k=0, 20 do
               context:set_cell(Vec3i.new(i + gen_zero.x, j + gen_zero.y, z_start + 1 + k), nil)
               context:clear_props(Vec3i.new(i + gen_zero.x, j + gen_zero.y, z_start + k))
            end

            for k=0, 10 do
               context:set_cell(Vec3i.new(gen_zero.x, gen_zero.y, z_start - 1 - k), block)
               context:set_cell(Vec3i.new(gen_zero.x + platform_size - 1, gen_zero.y, z_start - 1 - k), block)
               context:set_cell(Vec3i.new(gen_zero.x, gen_zero.y + platform_size - 1, z_start - 1 - k), block)
               context:set_cell(Vec3i.new(gen_zero.x + platform_size - 1, gen_zero.y + platform_size - 1, z_start - 1 - k), block)
            end
         end
      end

      local block = StaticBlock.find("CopperSpawner")
      context:spawn_block(Vec3i.new(gen_zero.x, gen_zero.y, z_start + 1), block)

      local pad_center = math.floor(platform_size / 2)
      local pad_radius = 2
      for i = -pad_radius, pad_radius do
         for j = -pad_radius, pad_radius do
            context:set_cell(Vec3i.new(gen_zero.x + pad_center + i, gen_zero.y + pad_center + j, z_start), nil)
         end
      end

      local pad = StaticBlock.find("LandingPad")
      context:spawn_block(Vec3i.new(gen_zero.x + pad_center, gen_zero.y + pad_center, z_start), pad)
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

   es:sub(defines.events.on_surface_day_phase, function(ctx)
      if music == nil then
         return
      end
      local key
      if ctx.anchor == "dawn" then
         key = "default"
      elseif ctx.anchor == "sunset" then
         key = "cosmos"
      else
         return
      end
      if music:set_playlist(key) then
         music:play_random_crossfade(10.0)
      end
   end)

   math.randomseed(123)
   local rand = math.random

   local BLOCK_PLAT    = StaticBlock.find("TerracottaBricks")
   local BLOCK_WALL    = StaticBlock.find("WoodenPlanks")
   local BLOCK_COL_BASE= StaticBlock.find("BasicPlatform")
   local BLOCK_COL_SEG = StaticBlock.find("BasicPlatform")
   local BLOCK_COL_CAP = StaticBlock.find("BasicPlatform")

   local function generate_platform(ctx, pos)
   local size = rand(4, 7)
   local h    = dim:sample_height(pos.x, pos.y)
   local z    = math.floor(h)
   for i = 0, size-1 do
      for j = 0, size-1 do
         local p = Vec3i.new(pos.x + i, pos.y + j, z)
         for k = 0, 2 do
            ctx:set_cell(p - Vec3i.new(0, 0, k), BLOCK_PLAT)
         end

         for k = 1, 4 do
            ctx:set_cell(p + Vec3i.new(0, 0, k), BLOCK_WALL)
         end
         for k = 4, 6 do
            ctx:set_cell(p + Vec3i.new(0, 0, k), nil)
            ctx:clear_props(p + Vec3i.new(0, 0, k))
         end
      end
   end
   end

   local RuinsGen = StaticStructure.reg("RuinsGenerator")
      RuinsGen.size = Vec2i.new(10, 10)

      RuinsGen.generate = function(ctx)
      local gen_zero = ctx.pos * Vec2i.new(cs.sector_size.x, cs.sector_size.y)

      local count = rand(3, 6)

      for _ = 1, count do
         local offset = Vec2i.new(rand(0, 50), rand(0, 50))
         local pos = gen_zero + offset

         generate_platform(ctx, pos)
      end
   end

end

function vanilla_mod.post_init()
   require('panels').fill_defaults()
end

db:mod(vanilla_mod)
