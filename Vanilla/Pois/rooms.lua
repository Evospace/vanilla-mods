local Rooms = {}

local STEPS = { { 1, 0 }, { 0, 1 }, { -1, 0 }, { 0, -1 } }

local pools = {}

local function rotate(x, y, sx, sy, r)
   if r == 1 then
      return sy - 1 - y, x
   elseif r == 2 then
      return sx - 1 - x, sy - 1 - y
   elseif r == 3 then
      return y, sx - 1 - x
   end
   return x, y
end

local function key(x, y)
   return x * 4096 + y
end

local Piece = {}
Piece.__index = Piece

function Piece:at(x, y)
   local tx, ty = rotate(x, y, self.room.size[1], self.room.size[2], self.r)
   return self.x + tx, self.y + ty
end

function Piece:set_cell(x, y, z, block)
   local tx, ty = self:at(x, y)
   self.ctx:set_cell(Vec3i.new(tx, ty, self.level + z), block)
end

function Piece:add_prop(x, y, z, sx, sy, yaw, prop)
   local ax, ay = self:at(x, y)
   local bx, by = self:at(x + sx - 1, y + sy - 1)
   self.ctx:add_prop(Vec3i.new(math.min(ax, bx), math.min(ay, by), self.level + z), Vec2i.new(math.abs(bx - ax) + 1, math.abs(by - ay) + 1), (yaw + self.r) % 4, prop)
end

function Piece:path(x, y, floor, stair)
   local tx, ty = self:at(x, y)
   self.ctx:path(Vec2i.new(tx, ty), floor, stair)
end

function Piece:level_rect(x, y, sx, sy, z)
   local ax, ay = self:at(x, y)
   local bx, by = self:at(x + sx - 1, y + sy - 1)
   self.ctx:level(Vec2i.new(math.min(ax, bx), math.min(ay, by)), Vec2i.new(math.abs(bx - ax) + 1, math.abs(by - ay) + 1), self.level + z)
end

function Piece:ground(x, y)
   local tx, ty = self:at(x, y)
   return self.ctx:ground(Vec2i.new(tx, ty)) - self.level
end

function Piece:linked(index)
   return self.links[index] == true
end

function Piece:random(count)
   return self.ctx:random(count)
end

function Piece:fraction()
   return self.ctx:fraction()
end

function Rooms.define(name)
   pools[name] = { rooms = {} }
end

function Rooms.add(name, room)
   table.insert(pools[name].rooms, room)
end

function Rooms.assemble(ctx, name, startName, limits)
   local rooms = pools[name].rooms
   local width, depth = ctx.size.x, ctx.size.y
   local occupied = {}
   local placed = {}
   local counts = {}
   local open = {}

   local function fits(room, x, y, sx, sy, parent)
      if x < 0 or y < 0 or x + sx > width or y + sy > depth then
         return false
      end
      local gap = room.gap or 0
      for i = x - gap, x + sx - 1 + gap do
         for j = y - gap, y + sy - 1 + gap do
            local other = occupied[key(i, j)]
            if other then
               local inside = i >= x and j >= y and i < x + sx and j < y + sy
               if inside or other.room.kind ~= "path" then
                  return false
               end
            end
         end
      end
      if room.kind == "path" then
         for i = x, x + sx - 1 do
            for j = y, y + sy - 1 do
               for _, step in ipairs(STEPS) do
                  local other = occupied[key(i + step[1], j + step[2])]
                  if other and other ~= parent and other.room.kind == "path" then
                     return false
                  end
               end
            end
         end
      end
      return true
   end

   local function place(room, x, y, r, sx, sy, step, used)
      local piece = setmetatable({ ctx = ctx, room = room, x = x, y = y, r = r, sx = sx, sy = sy, level = 0, links = {} }, Piece)
      table.insert(placed, piece)
      counts[room.name] = (counts[room.name] or 0) + 1
      for i = x, x + sx - 1 do
         for j = y, y + sy - 1 do
            occupied[key(i, j)] = piece
         end
      end
      if used ~= 0 then
         piece.links[used] = true
      end
      for index, door in ipairs(room.doors) do
         if index ~= used then
            local dx, dy = rotate(door[1], door[2], room.size[1], room.size[2], r)
            table.insert(open, { x = x + dx, y = y + dy, dir = (door[3] + r) % 4, tag = door[4], step = step, piece = piece, index = index })
         end
      end
   end

   local function attach(room, door)
      local need = (door.dir + 2) % 4
      local tx, ty = door.x + STEPS[door.dir + 1][1], door.y + STEPS[door.dir + 1][2]
      for index, own in ipairs(room.doors) do
         if own[4] == door.tag and not own[5] then
            local r = (need - own[3]) % 4
            local sx, sy = room.size[1], room.size[2]
            if r % 2 == 1 then
               sx, sy = sy, sx
            end
            local dx, dy = rotate(own[1], own[2], room.size[1], room.size[2], r)
            local x, y = tx - dx, ty - dy
            if fits(room, x, y, sx, sy, door.piece) then
               place(room, x, y, r, sx, sy, door.step + 1, index)
               door.piece.links[door.index] = true
               return true
            end
         end
      end
      return false
   end

   for _, room in ipairs(rooms) do
      if room.name == startName then
         local r = ctx:random(4)
         local sx, sy = room.size[1], room.size[2]
         if r % 2 == 1 then
            sx, sy = sy, sx
         end
         place(room, math.floor((width - sx) / 2), math.floor((depth - sy) / 2), r, sx, sy, 0, 0)
      end
   end

   local head = 1
   while head <= #open and #placed < limits.pieces do
      local door = open[head]
      head = head + 1
      if door.step < limits.depth then
         local candidates = {}
         local total = 0
         for _, room in ipairs(rooms) do
            local weight = room.weight or 0
            if weight > 0 and (counts[room.name] or 0) < (room.max or math.huge) and door.step + 1 >= (room.min_step or 0) then
               for _, own in ipairs(room.doors) do
                  if own[4] == door.tag and not own[5] then
                     table.insert(candidates, room)
                     total = total + weight
                     break
                  end
               end
            end
         end
         while #candidates > 0 do
            local roll = ctx:fraction() * total
            local pick = #candidates
            for i, room in ipairs(candidates) do
               roll = roll - room.weight
               if roll < 0 then
                  pick = i
                  break
               end
            end
            local room = table.remove(candidates, pick)
            total = total - room.weight
            if (counts[room.name] or 0) < (room.max or math.huge) and attach(room, door) then
               break
            end
         end
      end
   end

   for _, piece in ipairs(placed) do
      if piece.room.kind ~= "path" and not piece.room.buried then
         local heights = {}
         for i = piece.x, piece.x + piece.sx - 1 do
            for j = piece.y, piece.y + piece.sy - 1 do
               table.insert(heights, ctx:ground(Vec2i.new(i, j)))
            end
         end
         table.sort(heights)
         piece.level = math.floor(heights[math.floor((#heights + 1) / 2)] + 0.5)
         ctx:level(Vec2i.new(piece.x, piece.y), Vec2i.new(piece.sx, piece.sy), piece.level - 0.5)
      end
   end
   for _, piece in ipairs(placed) do
      piece.room.build(piece)
   end
   return placed
end

return Rooms
