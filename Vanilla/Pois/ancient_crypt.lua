local Rooms = require('./rooms')
local Vaults = require('./vaults')
local Temperate = require('./biomes')

local POOL = "AncientCrypt"
local SIZE = 40
local DEPTH = 10
local F = -DEPTH
local TUNNEL = Vaults.TUNNEL

local function descent(kit)
   local length = DEPTH + 5
   Rooms.add(POOL, {
      name = "descent", kind = "building", buried = true, size = { 6, length }, weight = 100, max = 1,
      doors = { { 3, length - 1, 1, "stairs" } },
      build = function(p)
         p:level_rect(0, 0, 6, length, -0.5)

         for x = 0, 5 do
            for y = 0, 2 do
               local gate = y == 2 and x >= 1 and x <= 4
               if gate or (x == 0 or x == 5) and y == 1 or p:fraction() < 0.85 then
                  p:set_cell(x, y, -1, gate and kit.masonry or kit.tiles)
               else
                  p:add_prop(x, y, -1, 1, 1, p:random(4), p:fraction() < 0.5 and kit.AncientCrackFern or kit.AncientCrackWeed)
               end
            end
         end
         for _, x in ipairs({ 0, 5 }) do
            local kind = Vaults.pick(p, { { "AncientPillarBroken", 60 }, { "AncientPillarStump", 40 } })
            p:add_prop(x, 1, 0, 1, 1, p:random(4), kit[kind])
         end
         p:add_prop(2, 2, 0, 2, 1, 0, kit.AncientGate)

         for k = 1, DEPTH do
            local y = k + 2
            local covered = k >= 6
            local top = covered and -k + 3 or -1
            for x = 2, 3 do
               p:set_cell(x, y, -k - 1, kit.masonry)
               for z = -k, top do
                  p:set_cell(x, y, z, nil)
               end
               p:add_prop(x, y, -k, 1, 1, 3, kit.AncientStairs)
               if covered then
                  p:set_cell(x, y, -k + 4, kit.masonry)
               end
            end
            local wall = covered and -k + 4 or -1
            for _, x in ipairs({ 1, 4 }) do
               for z = -k - 1, wall do
                  p:set_cell(x, y, z, kit.masonry)
               end
            end
            if k == 6 then
               for x = 1, 4 do
                  p:set_cell(x, y, -1, kit.masonry)
                  if p:fraction() < 0.7 then
                     p:set_cell(x, y, 0, kit.masonry)
                  end
               end
            end
         end
         for y = 2, 7 do
            for _, x in ipairs({ 1, 4 }) do
               for z = 0, p:random(3) - 1 do
                  p:set_cell(x, y, z, kit.masonry)
               end
            end
         end

         local landing = DEPTH + 3
         local last = length - 1
         for x = 1, 4 do
            local inside = x == 2 or x == 3
            p:set_cell(x, landing, F - 1, kit.masonry)
            for z = F, F + TUNNEL - 1 do
               if inside then
                  p:set_cell(x, landing, z, nil)
               else
                  p:set_cell(x, landing, z, kit.masonry)
               end
            end
            p:set_cell(x, landing, F + TUNNEL, kit.masonry)

            local door = (x == 2 or x == 3) and p:linked(1)
            p:set_cell(x, last, F - 1, kit.masonry)
            for z = F, F + TUNNEL - 1 do
               if door then
                  p:set_cell(x, last, z, nil)
               else
                  p:set_cell(x, last, z, kit.masonry)
               end
            end
            p:set_cell(x, last, F + TUNNEL, kit.masonry)
         end
         if p:fraction() < 0.4 then
            p:add_prop(3, landing, F, 1, 1, p:random(4), kit.AncientRubble)
         end
         if p:fraction() < 0.6 then
            p:add_prop(2, landing, F, 1, 1, p:random(4), kit[Vaults.MOSS[1 + p:random(#Vaults.MOSS)]])
         end
      end,
   })
end

return function()
   local kit = Vaults.kit()

   Rooms.define(POOL)
   descent(kit)
   Vaults.add(POOL, kit, F)

   local crypt = StaticPoi.reg("AncientCrypt")
   crypt.size = Vec2i.new(SIZE, SIZE)
   crypt.rarity = 5
   crypt.min_distance = 320
   crypt.max_relief = 4
   crypt.max_cut = 3
   crypt.margin = 8
   crypt.clearance = 6
   crypt.biomes = Temperate()
   crypt.generate = function(ctx)
      Rooms.assemble(ctx, POOL, "antechamber", { pieces = 28, depth = 12 })
   end
end
