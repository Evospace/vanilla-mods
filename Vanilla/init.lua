local Vlib = require('@VanillaLib')

local vanilla_mod = {}

function vanilla_mod.init()
   local es = EventSystem.get()

   for _, proto in pairs(db:objects()) do
      local block = StaticBlock.cast(proto)
      if block ~= nil then
         block.actor_init = Vlib.CommonActorInit
         block.tooltip = Vlib.CommonActorTooltip
      end
   end

   require('@self/Blocks/all')()

   require('@self/panels').register()

   require('@self/Pois/ancient_shrine')()
   require('@self/Pois/ancient_village')()
   require('@self/Pois/ancient_crypt')()
   require('@self/Pois/ancient_rock_tomb')()

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
end

function vanilla_mod.post_init()
   require('@self/panels').fill_defaults()
end

db:mod(vanilla_mod)
