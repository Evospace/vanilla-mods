local Rooms = require('./rooms')

local Vaults = {}

Vaults.TUNNEL = 3
Vaults.VAULT = 4

local TUNNEL = Vaults.TUNNEL
local VAULT = Vaults.VAULT
local EARTH = {}

local STEPS = { { 1, 0 }, { 0, 1 }, { -1, 0 }, { 0, -1 } }
local MOSS = { "Moss", "Moss1", "Moss2" }
Vaults.MOSS = MOSS
local SHROOMS = { "Shroom", "Shroom1", "Shroom2", "Shroom3" }

local function key(x, y)
   return x * 100 + y
end

function Vaults.pick(p, options)
   local total = 0
   for _, option in ipairs(options) do
      total = total + option[2]
   end
   local roll = p:fraction() * total
   for _, option in ipairs(options) do
      roll = roll - option[2]
      if roll < 0 then
         return option[1]
      end
   end
   return options[#options][1]
end

function Vaults.kit()
   local kit = {
      masonry = StaticBlock.find("AncientMasonry"),
      masonry_cut = StaticBlock.find("AncientMasonryCut"),
      tiles = StaticBlock.find("StoneTiles"),
   }
   for _, name in ipairs({
      "AncientStairs", "AncientGate", "AncientAltar", "AncientStele",
      "AncientPillar", "AncientPillarBroken", "AncientPillarStump", "AncientPillarFallen",
      "AncientRubble", "AncientRubbleLarge", "AncientCrackFern", "AncientCrackWeed", "AncientVineHanging",
      "Moss", "Moss1", "Moss2", "Shroom", "Shroom1", "Shroom2", "Shroom3",
   }) do
      kit[name] = StaticProp.find(name)
   end
   return kit
end

function Vaults.add(POOL, kit, F)
   local function shell(p, kit, sx, sy, height, plan)
      for x = 0, sx - 1 do
         for y = 0, sy - 1 do
            local c = plan[key(x, y)]
            if c == nil then
               for z = F - 1, F + height do
                  p:set_cell(x, y, z, kit.masonry)
               end
            elseif c ~= EARTH then
               if c.floor then
                  p:set_cell(x, y, F - 1, c.floor)
               end
               local base = c.base or 0
               for z = F, F + height - 1 do
                  if z >= F + base and z < F + base + c.air then
                     p:set_cell(x, y, z, nil)
                  else
                     p:set_cell(x, y, z, kit.masonry)
                  end
               end
               if c.roof then
                  p:set_cell(x, y, F + height, kit.masonry)
               end
            end
         end
      end
   end

   local function link(p, kit, plan)
      for index, door in ipairs(p.room.doors) do
         for _, cell in ipairs(Rooms.opening(door)) do
            local k = key(cell[1], cell[2])
            if p:linked(index) then
               plan[k] = { air = TUNNEL, floor = kit.masonry, roof = true }
            else
               plan[k] = nil
            end
         end
      end
   end

   local function entries(p, taken)
      for index, door in ipairs(p.room.doors) do
         if p:linked(index) then
            local s = STEPS[door[3] + 1]
            for _, cell in ipairs(Rooms.opening(door)) do
               taken[key(cell[1] - s[1], cell[2] - s[2])] = true
            end
         end
      end
   end

   local function put(p, kit, taken, name, x, y, z, sx, sy, yaw)
      for i = x, x + sx - 1 do
         for j = y, y + sy - 1 do
            if taken[key(i, j)] then
               return false
            end
         end
      end
      for i = x, x + sx - 1 do
         for j = y, y + sy - 1 do
            taken[key(i, j)] = true
         end
      end
      p:add_prop(x, y, z, sx, sy, yaw, kit[name])
      return true
   end

   local function litter(p, kit, taken, x0, y0, x1, y1, count, names)
      for _ = 1, count do
         local x = x0 + p:random(x1 - x0 + 1)
         local y = y0 + p:random(y1 - y0 + 1)
         put(p, kit, taken, names[1 + p:random(#names)], x, y, F, 1, 1, p:random(4))
      end
   end

   local function chamber(p, kit, sx, sy, height, floor, holes)
      local plan = {}
      for x = 1, sx - 2 do
         for y = 1, sy - 2 do
            plan[key(x, y)] = {
               air = height,
               floor = p:fraction() >= holes and floor or false,
               roof = p:fraction() >= holes * 0.5,
            }
         end
      end
      link(p, kit, plan)
      return plan
   end

   local function debris(p, kit, taken, plan, sx, sy)
      for x = 1, sx - 2 do
         for y = 1, sy - 2 do
            local c = plan[key(x, y)]
            if c and c ~= EARTH and not c.roof then
               put(p, kit, taken, "AncientRubble", x, y, F + (c.base or 0), 1, 1, p:random(4))
            end
         end
      end
   end

   local function corridor(p, kit, cells)
      local plan = {}
      for _, c in ipairs(cells) do
         plan[key(c[1], c[2])] = { air = TUNNEL, floor = p:fraction() >= 0.05 and kit.masonry or false, roof = p:fraction() >= 0.03 }
      end
      link(p, kit, plan)
      shell(p, kit, p.room.size[1], p.room.size[2], TUNNEL, plan)
      return plan
   end

   local function tunnels(kit)
      Rooms.add(POOL, {
         name = "tunnel", kind = "path", size = { 7, 4 }, weight = 8, height = TUNNEL,
         doors = { { 0, 2, 2, "tunnel" }, { 6, 1, 0, "tunnel" }, { 3, 0, 3, "room", true }, { 4, 3, 1, "room", true } },
         build = function(p)
            local cells = {}
            for x = 0, 6 do
               table.insert(cells, { x, 1 })
               table.insert(cells, { x, 2 })
            end
            corridor(p, kit, cells)
            local taken = {}
            entries(p, taken)
            for index, inner in ipairs({ 1, 5 }) do
               if not p:linked(index) and p:fraction() < 0.5 then
                  put(p, kit, taken, p:fraction() < 0.3 and "AncientRubbleLarge" or "AncientRubble", inner, 1 + p:random(2), F, 1, 1, p:random(4))
               end
            end
            for x = 1, 5 do
               local roll = p:fraction()
               local y = 1 + p:random(2)
               if roll < 0.08 then
                  put(p, kit, taken, MOSS[1 + p:random(#MOSS)], x, y, F, 1, 1, p:random(4))
               elseif roll < 0.12 then
                  put(p, kit, taken, SHROOMS[1 + p:random(#SHROOMS)], x, y, F, 1, 1, p:random(4))
               elseif roll < 0.17 then
                  p:add_prop(x, y, F, 1, 1, p:random(2) * 2 + 1, kit.AncientVineHanging)
               end
            end
         end,
      })
      Rooms.add(POOL, {
         name = "bend", kind = "path", size = { 4, 4 }, weight = 3, height = TUNNEL,
         doors = { { 0, 2, 2, "tunnel" }, { 2, 3, 1, "tunnel" } },
         build = function(p)
            corridor(p, kit, { { 0, 1 }, { 0, 2 }, { 1, 1 }, { 1, 2 }, { 2, 1 }, { 2, 2 }, { 1, 3 }, { 2, 3 } })
         end,
      })
      Rooms.add(POOL, {
         name = "fork", kind = "path", size = { 4, 4 }, weight = 2, height = TUNNEL,
         doors = { { 0, 2, 2, "tunnel" }, { 3, 1, 0, "tunnel" }, { 2, 3, 1, "tunnel" } },
         build = function(p)
            corridor(p, kit, { { 0, 1 }, { 0, 2 }, { 1, 1 }, { 1, 2 }, { 2, 1 }, { 2, 2 }, { 3, 1 }, { 3, 2 }, { 1, 3 }, { 2, 3 } })
         end,
      })
   end

   local function chambers(kit)
      Rooms.add(POOL, {
         name = "antechamber", kind = "building", buried = true, size = { 5, 5 }, weight = 0, height = VAULT,
         doors = { { 2, 0, 3, "stairs" }, { 4, 2, 0, "tunnel", true }, { 2, 4, 1, "tunnel", true }, { 0, 2, 2, "tunnel", true } },
         build = function(p)
            local plan = chamber(p, kit, 5, 5, VAULT, kit.tiles, 0.05)
            local taken = {}
            entries(p, taken)
            plan[key(2, 2)].floor, plan[key(2, 2)].roof = kit.tiles, true
            put(p, kit, taken, p:fraction() < 0.7 and "AncientPillar" or "AncientPillarBroken", 2, 2, F, 1, 1, p:random(4))
            for _, corner in ipairs({ { 1, 1 }, { 3, 1 }, { 1, 3 }, { 3, 3 } }) do
               if p:fraction() < 0.35 then
                  put(p, kit, taken, "AncientRubble", corner[1], corner[2], F, 1, 1, p:random(4))
               end
            end
            debris(p, kit, taken, plan, 5, 5)
            litter(p, kit, taken, 1, 1, 3, 3, 2, MOSS)
            shell(p, kit, 5, 5, VAULT, plan)
         end,
      })

      Rooms.add(POOL, {
         name = "crypt", kind = "building", buried = true, size = { 5, 7 }, gap = 2, weight = 5, max = 4, height = TUNNEL,
         doors = { { 2, 0, 3, "room" } },
         build = function(p)
            local plan = chamber(p, kit, 5, 7, TUNNEL, kit.masonry, 0.08)
            local taken = {}
            entries(p, taken)
            local x = 1 + p:random(2)
            plan[key(x, 3)].floor, plan[key(x + 1, 3)].floor = kit.masonry, kit.masonry
            plan[key(x, 4)].floor, plan[key(x + 1, 4)].floor = kit.masonry, kit.masonry
            put(p, kit, taken, "AncientAltar", x, 3, F, 2, 2, p:random(4))
            put(p, kit, taken, "AncientStele", x, 5, F, 2, 1, 2)
            debris(p, kit, taken, plan, 5, 7)
            litter(p, kit, taken, 1, 1, 3, 5, 2, MOSS)
            litter(p, kit, taken, 1, 1, 3, 5, 1, SHROOMS)
            shell(p, kit, 5, 7, TUNNEL, plan)
         end,
      })

      Rooms.add(POOL, {
         name = "hall", kind = "building", buried = true, size = { 7, 9 }, gap = 2, weight = 3, max = 2, height = VAULT,
         doors = { { 3, 0, 3, "room" }, { 0, 6, 2, "tunnel", true }, { 6, 6, 0, "tunnel", true }, { 3, 8, 1, "tunnel", true } },
         build = function(p)
            local plan = chamber(p, kit, 7, 9, VAULT, kit.tiles, 0.06)
            local taken = {}
            entries(p, taken)
            for _, y in ipairs({ 2, 4, 6 }) do
               for _, x in ipairs({ 2, 4 }) do
                  local kind = Vaults.pick(p, { { "AncientPillar", 55 }, { "AncientPillarBroken", 25 }, { "AncientPillarStump", 15 }, { false, 5 } })
                  if kind then
                     plan[key(x, y)].floor, plan[key(x, y)].roof = kit.tiles, true
                     put(p, kit, taken, kind, x, y, F, 1, 1, p:random(4))
                     if kind == "AncientPillarBroken" and p:fraction() < 0.5 then
                        put(p, kit, taken, "AncientPillarFallen", x == 2 and 1 or 5, y, F, 1, 2, 1 + p:random(2) * 2)
                     end
                  end
               end
            end
            debris(p, kit, taken, plan, 7, 9)
            litter(p, kit, taken, 1, 1, 5, 7, 4, MOSS)
            litter(p, kit, taken, 1, 1, 5, 7, 2, SHROOMS)
            shell(p, kit, 7, 9, VAULT, plan)
         end,
      })

      Rooms.add(POOL, {
         name = "cavein", kind = "building", buried = true, size = { 6, 6 }, gap = 2, weight = 3, max = 3, height = TUNNEL,
         doors = { { 2, 0, 3, "room" } },
         build = function(p)
            local plan = chamber(p, kit, 6, 6, TUNNEL, kit.masonry, 0.1)
            local taken = {}
            entries(p, taken)
            local cx, cy = p:fraction() < 0.5 and 0 or 5, 5
            for x = 0, 5 do
               for y = 0, 5 do
                  local d = math.max(math.abs(x - cx), math.abs(y - cy))
                  local edge = x == 0 or y == 0 or x == 5 or y == 5
                  if d <= 1 or edge and d <= 2 and p:fraction() < 0.6 then
                     plan[key(x, y)] = EARTH
                     taken[key(x, y)] = true
                  elseif d <= 2 and not edge then
                     plan[key(x, y)].roof = false
                  end
               end
            end
            put(p, kit, taken, "AncientRubbleLarge", 2, 3, F, 2, 2, p:random(4))
            debris(p, kit, taken, plan, 6, 6)
            litter(p, kit, taken, 1, 2, 4, 4, 3, { "AncientRubble", "AncientRubble", "AncientPillarStump" })
            litter(p, kit, taken, 1, 1, 4, 4, 2, MOSS)
            shell(p, kit, 6, 6, TUNNEL, plan)
         end,
      })

      Rooms.add(POOL, {
         name = "sanctum", kind = "building", buried = true, size = { 10, 9 }, gap = 2, weight = 8, max = 1, min_step = 3, height = VAULT,
         doors = { { 4, 0, 3, "room" } },
         build = function(p)
            local plan = chamber(p, kit, 10, 9, VAULT, kit.tiles, 0.04)
            local taken = {}
            entries(p, taken)
            for x = 3, 6 do
               for y = 4, 7 do
                  local c = plan[key(x, y)]
                  c.base, c.air, c.floor, c.roof = 1, VAULT - 1, kit.masonry, true
               end
            end
            for x = 4, 5 do
               plan[key(x, 3)].floor = kit.masonry
               put(p, kit, taken, "AncientStairs", x, 3, F, 1, 1, 1)
            end
            put(p, kit, taken, "AncientAltar", 4, 5, F + 1, 2, 2, p:random(4))
            put(p, kit, taken, "AncientStele", 4, 7, F + 1, 2, 1, 2)
            for _, spot in ipairs({ { 2, 2 }, { 7, 2 }, { 2, 6 }, { 7, 6 } }) do
               local kind = Vaults.pick(p, { { "AncientPillar", 60 }, { "AncientPillarBroken", 30 }, { "AncientPillarStump", 10 } })
               plan[key(spot[1], spot[2])].floor, plan[key(spot[1], spot[2])].roof = kit.tiles, true
               put(p, kit, taken, kind, spot[1], spot[2], F, 1, 1, p:random(4))
            end
            if p:fraction() < 0.7 then
               for x = 4, 5 do
                  plan[key(x, 4)].roof = false
                  for z = F + VAULT, math.floor(p:ground(x, 4)) + 1 do
                     p:set_cell(x, 4, z, nil)
                  end
                  put(p, kit, taken, p:fraction() < 0.5 and "AncientCrackFern" or "AncientCrackWeed", x, 4, F + 1, 1, 1, p:random(4))
               end
            end
            for x = 3, 6 do
               for y = 4, 7 do
                  taken[key(x, y)] = true
               end
            end
            debris(p, kit, taken, plan, 10, 9)
            litter(p, kit, taken, 1, 1, 8, 7, 5, MOSS)
            litter(p, kit, taken, 1, 1, 8, 7, 3, SHROOMS)
            shell(p, kit, 10, 9, VAULT, plan)
         end,
      })
   end

   tunnels(kit)
   chambers(kit)
end

return Vaults
