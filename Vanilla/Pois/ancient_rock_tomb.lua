local Rooms = require('./rooms')
local Vaults = require('./vaults')
local Temperate = require('./biomes')

local POOL = "AncientRockTomb"
local WIDTH = 32
local DEPTH = 48
local FOOT = 5
local COURT = 8
local RISE = 3
local F = RISE
local COVER = 2
local HUB = 5
local GATE = 5
local MIN_PIECES = 6
local TUNNEL, VAULT = Vaults.TUNNEL, Vaults.VAULT
local CRACKS = { "AncientCrackFern", "AncientCrackWeed" }

local function build(ctx, kit)
   local W, D = ctx.size.x, ctx.size.y
   local heights = {}
   for x = 0, W - 1 do
      for y = 0, D - 1 do
         heights[x * D + y] = ctx:ground(Vec2i.new(x, y))
      end
   end
   local function ground(x, y)
      return heights[x * D + y]
   end
   local function surface(x, y)
      return math.ceil(ground(x, y)) - 1
   end
   local function covered(x, y, sx, sy, height)
      for i = x, x + sx - 1 do
         for j = y, y + sy - 1 do
            if ground(i, j) < F + height + COVER then
               return false
            end
         end
      end
      return true
   end
   local function cell(x, y, z, block)
      ctx:set_cell(Vec3i.new(x, y, z), block)
   end
   local function prop(x, y, z, sx, sy, yaw, kind)
      ctx:add_prop(Vec3i.new(x, y, z), Vec2i.new(sx, sy), yaw, kit[kind])
   end
   local function column(x, y, top)
      for z = math.floor(math.min(ground(x, y), 0)) - 1, top do
         cell(x, y, z, kit.masonry)
      end
   end
   local function clear(x, y, from, to)
      for z = from, to do
         cell(x, y, z, nil)
      end
   end

   local cx = math.floor(W / 2) - 1
   local x0 = cx - 3
   local landing = FOOT + RISE

   local hub
   for y = landing + 2, D - HUB do
      if covered(cx - 2, y, HUB, HUB, VAULT) then
         hub = y
         break
      end
   end
   if not hub then
      hub = landing + 2
      ctx:refuse()
   end

   local portal = hub
   for y = hub - 1, landing + 1, -1 do
      if not covered(cx - 1, y, 4, 1, TUNNEL) then
         break
      end
      portal = y
   end
   local gate = portal - 1

   ctx:level(Vec2i.new(x0, 0), Vec2i.new(COURT, FOOT), -0.5)
   local pillars = { [cx - 2] = true, [cx + 3] = true }
   for x = x0, x0 + COURT - 1 do
      for y = 0, FOOT - 1 do
         if y == FOOT - 1 and pillars[x] or ctx:fraction() < 0.85 then
            cell(x, y, -1, kit.tiles)
         else
            prop(x, y, -1, 1, 1, ctx:random(4), CRACKS[1 + ctx:random(#CRACKS)])
         end
      end
   end
   for _, x in ipairs({ cx - 2, cx + 3 }) do
      local kind = Vaults.pick(ctx, { { "AncientPillar", 50 }, { "AncientPillarBroken", 30 }, { "AncientPillarStump", 20 } })
      prop(x, FOOT - 1, 0, 1, 1, ctx:random(4), kind)
      if kind == "AncientPillarBroken" and ctx:fraction() < 0.5 then
         prop(x == cx - 2 and x0 or x0 + COURT - 1, FOOT - 3, 0, 1, 2, 1 + ctx:random(2) * 2, "AncientPillarFallen")
      end
   end
   for _ = 1, 2 do
      local x = x0 + ctx:random(2) * (COURT - 2) + ctx:random(2)
      prop(x, ctx:random(FOOT - 3), 0, 1, 1, ctx:random(4), ctx:fraction() < 0.3 and "AncientRubbleLarge" or "AncientRubble")
   end

   for k = 1, RISE do
      local y = FOOT + k - 1
      for x = cx, cx + 1 do
         column(x, y, k - 2)
         prop(x, y, k - 1, 1, 1, 1, "AncientStairs")
         clear(x, y, k - 1, math.max(k + TUNNEL, surface(x, y)))
      end
      for _, x in ipairs({ cx - 1, cx + 2 }) do
         column(x, y, math.max(k, surface(x, y)))
      end
   end

   for y = landing, portal - 1 do
      local bay = y == gate
      local left, right = bay and cx - 1 or cx, bay and cx + 2 or cx + 1
      for x = left, right do
         column(x, y, F - 1)
         clear(x, y, F, math.max(F + (bay and GATE or TUNNEL), surface(x, y)))
      end
      for _, x in ipairs({ left - 1, right + 1 }) do
         column(x, y, math.max(F, surface(x, y)))
      end
      if not bay and ctx:fraction() < 0.25 then
         prop(cx + ctx:random(2), y, F, 1, 1, ctx:random(4), Vaults.MOSS[1 + ctx:random(#Vaults.MOSS)])
      end
   end
   prop(cx, gate, F, 2, 1, 0, "AncientGate")

   for y = portal, hub - 1 do
      for x = cx, cx + 1 do
         column(x, y, F - 1)
         clear(x, y, F, F + TUNNEL - 1)
         cell(x, y, F + TUNNEL, kit.masonry)
      end
      for _, x in ipairs({ cx - 1, cx + 2 }) do
         column(x, y, F + TUNNEL)
      end
      local roll = ctx:fraction()
      if roll < 0.12 then
         prop(cx + ctx:random(2), y, F, 1, 1, ctx:random(4), Vaults.MOSS[1 + ctx:random(#Vaults.MOSS)])
      elseif roll < 0.2 then
         prop(cx + ctx:random(2), y, F, 1, 1, ctx:random(2) * 2, "AncientVineHanging")
      end
   end
   if portal < hub then
      for x = cx - 1, cx + 2 do
         for z = F + TUNNEL + 1, surface(x, portal) do
            cell(x, portal, z, kit.masonry)
         end
      end
   end

   local placed = Rooms.assemble(ctx, POOL, "antechamber", {
      pieces = 24,
      depth = 10,
      start = { x = cx - 2, y = hub, r = 0, door = 1 },
      taken = { { x0, 0, COURT, hub } },
      fits = function(room, x, y, sx, sy)
         return covered(x, y, sx, sy, room.height)
      end,
   })
   if #placed < MIN_PIECES then
      ctx:refuse()
   end
end

return function()
   local kit = Vaults.kit()

   Rooms.define(POOL)
   Vaults.add(POOL, kit, F)

   local tomb = StaticPoi.reg("AncientRockTomb")
   tomb.size = Vec2i.new(WIDTH, DEPTH)
   tomb.rarity = 3
   tomb.attempts = 12
   tomb.min_distance = 320
   tomb.min_rise = 12
   tomb.foot = FOOT
   tomb.max_relief = 4
   tomb.max_cut = 4
   tomb.margin = 6
   tomb.clearance = 6
   tomb.biomes = Temperate()
   tomb.generate = function(ctx)
      build(ctx, kit)
   end
end
