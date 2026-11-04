local Temperate = require('./biomes')

local SIZE = 14
local PLATFORM_MIN, PLATFORM_MAX = 1, 12
local DAIS_MIN, DAIS_MAX = 4, 9

local function cell(x, y, z)
   return Vec3i.new(x, y, z)
end

local function weighted(ctx, options)
   local total = 0
   for _, option in ipairs(options) do
      total = total + option[2]
   end
   local roll = ctx:random(total)
   for _, option in ipairs(options) do
      roll = roll - option[2]
      if roll < 0 then
         return option[1]
      end
   end
end

local function generate(ctx, kit)
   ctx:level(Vec2i.new(PLATFORM_MIN, PLATFORM_MIN), Vec2i.new(PLATFORM_MAX - PLATFORM_MIN + 1, PLATFORM_MAX - PLATFORM_MIN + 1), 0)

   local occupied = {}
   local supported = {}
   local function occupy(x, y, sx, sy)
      for i = x, x + sx - 1 do
         for j = y, y + sy - 1 do
            occupied[i * 100 + j] = true
         end
      end
      for i = x - 1, x + sx do
         for j = y - 1, y + sy do
            supported[i * 100 + j] = true
         end
      end
   end
   local function free(x, y, sx, sy)
      for i = x, x + sx - 1 do
         for j = y, y + sy - 1 do
            if occupied[i * 100 + j] then
               return false
            end
         end
      end
      return true
   end
   local function prop(name, x, y, z, sx, sy, yaw)
      local p = kit[name]
      if p then
         ctx:add_prop(cell(x, y, z), Vec2i.new(sx, sy), yaw, p)
      end
      occupy(x, y, sx, sy)
   end

   local pillar_spots = {
      { 2, 2 }, { 2, 5 }, { 2, 8 }, { 2, 11 },
      { 11, 2 }, { 11, 5 }, { 11, 8 }, { 11, 11 },
   }
   local pillars = {}
   for i, spot in ipairs(pillar_spots) do
      local kind = weighted(ctx, { { "AncientPillar", 50 }, { "AncientPillarBroken", 30 }, { "AncientPillarStump", 15 }, { false, 5 } })
      pillars[i] = kind
      if kind then
         prop(kind, spot[1], spot[2], 1, 1, 1, ctx:random(4))
         if kind ~= "AncientPillarStump" and ctx:fraction() < 0.4 then
            prop("AncientVinePillar", spot[1], spot[2], 1, 1, 1, ctx:random(4))
         end
      end
   end
   for _, side in ipairs({ 0, 4 }) do
      for k = 1, 3, 2 do
         local a, b = pillars[side + k], pillars[side + k + 1]
         if a == "AncientPillar" and b == "AncientPillar" and ctx:fraction() < 0.8 then
            local x = pillar_spots[side + k][1]
            local y = pillar_spots[side + k][2]
            prop("AncientLintel", x, y + 1, 5, 1, 2, 1)
         end
      end
   end

   for x = 3, 9, 2 do
      local kind = ctx:fraction() < 0.4 and "AncientWall" or "AncientWallBroken"
      if ctx:fraction() < 0.85 then
         local yaw = ctx:random(2) * 2
         prop(kind, x, 11, 1, 2, 1, yaw)
         if kind == "AncientWall" and ctx:fraction() < 0.5 then
            prop("AncientVineDrape", x + ctx:random(2), 11, 1, 1, 1, yaw)
         end
      end
   end

   prop("AncientGate", 6, 1, 1, 2, 1, 0)
   for x = 6, 7 do
      prop("AncientStairs", x, 0, 0, 1, 1, 1)
   end

   prop("AncientAltar", 6, 6, 2, 2, 2, ctx:random(4))
   prop("AncientStele", 6, 9, 2, 2, 1, 2)

   for i, kind in ipairs(pillars) do
      if kind ~= "AncientPillar" and ctx:fraction() < 0.6 then
         local spot = pillar_spots[i]
         local x = spot[1] < 7 and spot[1] + 1 or spot[1] - 2
         if free(x, spot[2], 2, 1) then
            prop("AncientPillarFallen", x, spot[2], 1, 2, 1, x > spot[1] and 0 or 2)
         end
      end
   end
   for _ = 1, 6 do
      local large = ctx:fraction() < 0.3
      local s = large and 2 or 1
      local x = ctx:random(SIZE - s + 1)
      local y = ctx:random(SIZE - s + 1)
      local onPlatform = x >= PLATFORM_MIN and y >= PLATFORM_MIN and x + s - 1 <= PLATFORM_MAX and y + s - 1 <= PLATFORM_MAX
      local offPlatform = x + s - 1 < PLATFORM_MIN or y + s - 1 < PLATFORM_MIN or x > PLATFORM_MAX or y > PLATFORM_MAX
      local onDais = x + s - 1 >= DAIS_MIN and y + s - 1 >= DAIS_MIN and x <= DAIS_MAX and y <= DAIS_MAX
      if (onPlatform or offPlatform) and not onDais and free(x, y, s, s) then
         prop(large and "AncientRubbleLarge" or "AncientRubble", x, y, onPlatform and 1 or 0, s, s, ctx:random(4))
      end
   end

   for _ = 1, 4 do
      local x = PLATFORM_MIN + 1 + ctx:random(PLATFORM_MAX - PLATFORM_MIN - 1)
      local y = PLATFORM_MIN + 1 + ctx:random(PLATFORM_MAX - PLATFORM_MIN - 1)
      local onDais = x >= DAIS_MIN and x <= DAIS_MAX and y >= DAIS_MIN and y <= DAIS_MAX
      if not onDais and free(x, y, 1, 1) then
         prop(ctx:fraction() < 0.5 and "AncientCrackFern" or "AncientCrackWeed", x, y, 1, 1, 1, ctx:random(4))
      end
   end

   for x = PLATFORM_MIN, PLATFORM_MAX do
      for y = PLATFORM_MIN, PLATFORM_MAX do
         local rim = x == PLATFORM_MIN or x == PLATFORM_MAX or y == PLATFORM_MIN or y == PLATFORM_MAX
         local block = rim and kit.rim or kit.floor
         local underDais = x >= DAIS_MIN and x <= DAIS_MAX and y >= DAIS_MIN and y <= DAIS_MAX
         if rim or underDais or supported[x * 100 + y] or ctx:fraction() >= 0.05 then
            ctx:set_cell(cell(x, y, 0), block)
         elseif ctx:fraction() < 0.6 then
            local plant = weighted(ctx, { { "AncientCrackSapling", 2 }, { "AncientCrackFern", 3 }, { "AncientCrackWeed", 3 } })
            ctx:add_prop(cell(x, y, 0), Vec2i.new(1, 1), ctx:random(4), kit[plant])
         end
      end
   end
   for x = DAIS_MIN, DAIS_MAX do
      for y = DAIS_MIN, DAIS_MAX do
         ctx:set_cell(cell(x, y, 1), kit.dais)
      end
   end
end

return function()
   local kit = {
      rim = StaticBlock.find("AncientMasonry"),
      floor = StaticBlock.find("AncientMasonry"),
      dais = StaticBlock.find("AncientMasonry"),
   }
   for _, name in ipairs({
      "AncientPillar", "AncientPillarBroken", "AncientPillarStump", "AncientPillarFallen", "AncientLintel",
      "AncientGate", "AncientStairs", "AncientWall", "AncientWallBroken", "AncientAltar", "AncientStele",
      "AncientRubble", "AncientRubbleLarge",
      "AncientCrackFern", "AncientCrackWeed", "AncientCrackSapling", "AncientVineDrape", "AncientVinePillar",
   }) do
      kit[name] = StaticProp.find(name)
   end

   local shrine = StaticPoi.reg("AncientShrine")
   shrine.size = Vec2i.new(SIZE, SIZE)
   shrine.rarity = 3
   shrine.min_distance = 192
   shrine.max_relief = 5
   shrine.max_cut = 3
   shrine.margin = 8
   shrine.clearance = 10
   shrine.biomes = Temperate()
   shrine.generate = function(ctx)
      generate(ctx, kit)
   end
end
