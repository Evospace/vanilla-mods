local Rooms = require('./rooms')

local POOL = "AncientVillage"
local SIZE = 40

local function ruin(p, sx, sy, kit, missing)
   local r = { p = p, sx = sx, sy = sy, kit = kit, taken = {}, holes = {}, heights = {} }
   for x = 0, sx - 1 do
      for y = 0, sy - 1 do
         local edge = x == 0 or y == 0 or x == sx - 1 or y == sy - 1
         if edge or p:fraction() >= missing then
            p:set_cell(x, y, -1, kit.masonry)
         else
            r.holes[x * 100 + y] = true
         end
      end
   end
   return r
end

local function walls(r, doors, height)
   for x = 0, r.sx - 1 do
      for y = 0, r.sy - 1 do
         local edge = x == 0 or y == 0 or x == r.sx - 1 or y == r.sy - 1
         if edge and not doors[x * 100 + y] then
            local h = height(x, y)
            r.heights[x * 100 + y] = h
            for z = 0, h - 1 do
               r.p:set_cell(x, y, z, r.kit.masonry)
            end
         end
      end
   end
end

local function corner(x, y, sx, sy)
   return (x == 0 or x == sx - 1) and (y == 0 or y == sy - 1)
end

local function place(r, x, y, z, sx, sy, yaw, name)
   for i = x, x + sx - 1 do
      for j = y, y + sy - 1 do
         r.taken[i * 100 + j] = true
         if r.holes[i * 100 + j] then
            r.holes[i * 100 + j] = nil
            r.p:set_cell(i, j, -1, r.kit.masonry)
         end
      end
   end
   r.p:add_prop(x, y, z, sx, sy, yaw, r.kit[name])
end

local function scatter(r, names, count)
   for _ = 1, count do
      local x = 1 + r.p:random(r.sx - 2)
      local y = 1 + r.p:random(r.sy - 2)
      if not r.taken[x * 100 + y] and not r.holes[x * 100 + y] then
         place(r, x, y, 0, 1, 1, r.p:random(4), names[1 + r.p:random(#names)])
      end
   end
end

local function overgrow(r)
   local p = r.p
   for x = 1, r.sx - 2 do
      for y = 1, r.sy - 2 do
         local k = x * 100 + y
         if not r.taken[k] then
            local wall, yaw
            if y == 1 then
               wall, yaw = r.heights[x * 100], 3
            elseif y == r.sy - 2 then
               wall, yaw = r.heights[x * 100 + r.sy - 1], 1
            elseif x == 1 then
               wall, yaw = r.heights[y], 2
            elseif x == r.sx - 2 then
               wall, yaw = r.heights[(r.sx - 1) * 100 + y], 0
            end
            local roll = p:fraction()
            if wall and wall >= 2 and roll < 0.25 then
               r.taken[k] = true
               p:add_prop(x, y, 0, 1, 1, yaw, r.kit.AncientVineHanging)
            elseif r.holes[k] and roll < 0.5 then
               r.taken[k] = true
               p:add_prop(x, y, -1, 1, 1, p:random(4), r.kit.AncientCrackSapling)
            elseif not r.holes[k] and roll < 0.12 then
               r.taken[k] = true
               p:add_prop(x, y, 0, 1, 1, p:random(4), p:fraction() < 0.5 and r.kit.AncientCrackFern or r.kit.AncientCrackWeed)
            end
         end
      end
   end
   for x = 0, r.sx - 1 do
      for y = 0, r.sy - 1 do
         local h = r.heights[x * 100 + y]
         if h and h > 0 and p:fraction() < 0.1 then
            p:add_prop(x, y, h, 1, 1, p:random(4), r.kit.AncientCrackWeed)
         end
      end
   end
   if p:fraction() < 0.4 then
      local x = 1 + p:random(r.sx - 3)
      local y = 1 + p:random(r.sy - 2)
      local a, b = x * 100 + y, (x + 1) * 100 + y
      if not r.taken[a] and not r.taken[b] and not r.holes[a] and not r.holes[b] then
         place(r, x, y, 0, 2, 1, p:random(2) * 2, "AncientVineCreeper")
      end
   end
end

local function pillar(r, x, y, z, kind)
   place(r, x, y, z, 1, 1, r.p:random(4), kind)
   if kind ~= "AncientPillarStump" and r.p:fraction() < 0.4 then
      r.p:add_prop(x, y, z, 1, 1, r.p:random(4), r.kit.AncientVinePillar)
   end
end

local function street(kit)
   Rooms.add(POOL, {
      name = "street", kind = "path", size = { 5, 1 }, weight = 10,
      doors = { { 0, 0, 2, "street" }, { 4, 0, 0, "street" }, { 1, 0, 1, "house", true }, { 3, 0, 3, "house", true }, { 3, 0, 1, "house", true }, { 1, 0, 3, "house", true } },
      build = function(p)
         for x = 0, 4 do
            p:path(x, 0, kit.tiles, kit.AncientStairs)
         end
      end,
   })
   Rooms.add(POOL, {
      name = "bend", kind = "path", size = { 1, 1 }, weight = 3,
      doors = { { 0, 0, 2, "street" }, { 0, 0, 1, "street" } },
      build = function(p)
         p:path(0, 0, kit.tiles, kit.AncientStairs)
      end,
   })
   Rooms.add(POOL, {
      name = "fork", kind = "path", size = { 1, 1 }, weight = 2,
      doors = { { 0, 0, 2, "street" }, { 0, 0, 0, "street" }, { 0, 0, 1, "street" } },
      build = function(p)
         p:path(0, 0, kit.tiles, kit.AncientStairs)
      end,
   })
end

local function plaza(kit)
   Rooms.add(POOL, {
      name = "plaza", kind = "building", size = { 7, 7 }, weight = 0,
      doors = { { 3, 0, 3, "street" }, { 6, 3, 0, "street" }, { 3, 6, 1, "street" }, { 0, 3, 2, "street" } },
      build = function(p)
         for x = 0, 6 do
            for y = 0, 6 do
               if x ~= 3 or y ~= 3 then
                  p:set_cell(x, y, -1, kit.masonry)
               end
            end
         end
         for x = 2, 4 do
            for y = 2, 4 do
               if x ~= 3 or y ~= 3 then
                  p:set_cell(x, y, 0, kit.masonry)
               end
            end
         end
         for z = -4, -1 do
            p:set_cell(3, 3, z, nil)
         end
         for _, c in ipairs({ { 0, 0 }, { 6, 0 }, { 0, 6 }, { 6, 6 } }) do
            local kind = p:fraction() < 0.5 and "AncientPillarStump" or "AncientPillarBroken"
            p:add_prop(c[1], c[2], 0, 1, 1, p:random(4), kit[kind])
         end
         for _ = 1, 3 do
            local x, y = p:random(7), p:random(7)
            local well = x >= 2 and x <= 4 and y >= 2 and y <= 4
            if not well and not corner(x, y, 7, 7) then
               p:add_prop(x, y, 0, 1, 1, p:random(4), p:fraction() < 0.5 and kit.AncientCrackFern or kit.AncientCrackWeed)
            end
         end
      end,
   })
end

local function ruins(kit)
   Rooms.add(POOL, {
      name = "hut", kind = "building", size = { 5, 5 }, gap = 2, weight = 6, max = 6,
      doors = { { 2, 0, 3, "house" } },
      build = function(p)
         local r = ruin(p, 5, 5, kit, 0.15)
         walls(r, { [200] = true }, function(x, y)
            return corner(x, y, 5, 5) and 3 or 1 + p:random(3)
         end)
         scatter(r, { "AncientRubble" }, 1 + p:random(2))
         overgrow(r)
      end,
   })

   Rooms.add(POOL, {
      name = "longhouse", kind = "building", size = { 5, 8 }, gap = 2, weight = 4, max = 3,
      doors = { { 2, 0, 3, "house" } },
      build = function(p)
         local r = ruin(p, 5, 8, kit, 0.25)
         walls(r, { [200] = true }, function(x, y)
            if corner(x, y, 5, 8) then
               return 2
            end
            return p:random(3)
         end)
         for _, y in ipairs({ 2, 5 }) do
            for _, x in ipairs({ 1, 3 }) do
               if p:fraction() < 0.75 then
                  pillar(r, x, y, 0, p:fraction() < 0.5 and "AncientPillarStump" or "AncientPillarBroken")
               end
            end
         end
         if p:fraction() < 0.5 and not r.taken[1 * 100 + 4] and not r.taken[2 * 100 + 4] then
            place(r, 1, 4, 0, 2, 1, p:random(2) * 2, "AncientPillarFallen")
         end
         scatter(r, { "AncientRubble" }, 2)
         overgrow(r)
      end,
   })

   Rooms.add(POOL, {
      name = "collapsed", kind = "building", size = { 6, 6 }, gap = 2, weight = 4, max = 4,
      doors = { { 2, 0, 3, "house" } },
      build = function(p)
         local r = ruin(p, 6, 6, kit, 0.4)
         local standing = p:random(4)
         walls(r, { [200] = true, [300] = true }, function(x, y)
            local side = (y == 0 and 0) or (x == 5 and 1) or (y == 5 and 2) or 3
            if side == standing then
               return 1 + p:random(2)
            end
            return p:fraction() < 0.5 and 1 or 0
         end)
         place(r, 2, 2, 0, 2, 2, p:random(4), "AncientRubbleLarge")
         scatter(r, { "AncientRubble", "AncientRubble", "AncientPillarStump" }, 3)
         overgrow(r)
      end,
   })

   Rooms.add(POOL, {
      name = "tower", kind = "building", size = { 5, 5 }, gap = 2, weight = 2, max = 2,
      doors = { { 2, 0, 3, "house" } },
      build = function(p)
         local r = ruin(p, 5, 5, kit, 0)
         local top = 4 + p:random(2)
         walls(r, { [200] = true }, function(x, y)
            if corner(x, y, 5, 5) then
               return top
            end
            return top - 1 - p:random(3)
         end)
         place(r, 2, 2, 0, 1, 1, p:random(4), "AncientPillarStump")
         scatter(r, { "AncientRubble" }, 2)
         overgrow(r)
      end,
   })

   Rooms.add(POOL, {
      name = "hall", kind = "building", size = { 8, 8 }, gap = 2, weight = 2, max = 1,
      doors = { { 3, 0, 3, "house" } },
      build = function(p)
         local r = ruin(p, 8, 8, kit, 0.05)
         walls(r, { [300] = true, [400] = true }, function(x, y)
            if y == 7 then
               return 2 + p:random(2)
            end
            return 1
         end)
         for _, y in ipairs({ 1, 3, 5 }) do
            for _, x in ipairs({ 0, 7 }) do
               pillar(r, x, y, 1, p:fraction() < 0.6 and "AncientPillar" or "AncientPillarBroken")
            end
         end
         place(r, 3, 4, 0, 2, 2, 1, "AncientAltar")
         place(r, 3, 6, 0, 2, 1, 2, "AncientStele")
         scatter(r, { "AncientRubble" }, 3)
         overgrow(r)
      end,
   })

   Rooms.add(POOL, {
      name = "courtyard", kind = "building", size = { 7, 6 }, gap = 2, weight = 3, max = 2,
      doors = { { 3, 0, 3, "house" } },
      build = function(p)
         local r = ruin(p, 7, 6, kit, 0.5)
         walls(r, { [300] = true }, function()
            return p:fraction() < 0.8 and 1 or 0
         end)
         place(r, 2, 3, 0, 2, 1, p:random(2) * 2, "AncientStele")
         scatter(r, { "AncientRubble" }, 2)
         overgrow(r)
      end,
   })
end

return function()
   local kit = {
      masonry = StaticBlock.find("AncientMasonry"),
      tiles = StaticBlock.find("StoneTiles"),
   }
   for _, name in ipairs({
      "AncientStairs", "AncientRubble", "AncientRubbleLarge", "AncientPillar", "AncientPillarBroken",
      "AncientPillarStump", "AncientPillarFallen", "AncientAltar", "AncientStele",
      "AncientCrackFern", "AncientCrackWeed", "AncientCrackSapling", "AncientVineHanging", "AncientVineCreeper", "AncientVinePillar",
   }) do
      kit[name] = StaticProp.find(name)
   end

   Rooms.define(POOL)
   plaza(kit)
   street(kit)
   ruins(kit)

   local village = StaticPoi.reg("AncientVillage")
   village.size = Vec2i.new(SIZE, SIZE)
   village.rarity = 4
   village.min_distance = 256
   village.max_relief = 6
   village.max_cut = 3
   village.margin = 8
   village.clearance = 6
   village.generate = function(ctx)
      Rooms.assemble(ctx, POOL, "plaza", { pieces = 40, depth = 8 })
   end
end
