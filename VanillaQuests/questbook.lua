-- questbook.lua
--
-- Declarative questbook framework for Evospace.
--
-- The engine (C++) provides the primitives:
--   * StaticChapter / StaticQuest / QuestObjective prototypes,
--   * QuestSubsystem (Locked -> Active -> Completed state, prerequisite unlocks,
--     save/load, per-quest event subscription groups),
--   * the event bus (EventSystem) with gameplay events.
--
-- This module lets a mod *declare* chapters, quests and objectives, and wires the
-- engine primitives together so objectives auto-track game events. All questbook
-- content/logic therefore lives in Lua (./Content/Mods).
--
-- Usage:
--   local qb = require('questbook')
--   qb.chapter("CopperProduction", { label = ..., description = { ... } })
--   qb.quest("GatherCopperOre", {
--       chapter     = "CopperProduction",
--       label       = ..., description = { ... },
--       unlocks     = { "SmeltCopper" },
--       objectives  = { qb.collect_item({ "ChalcopyriteOre", "MalachiteOre" }, 20) },
--   })
--   qb.build()   -- registers everything; call once at the end of your mod init()
--
-- Objective factories:
--   qb.collect_item({names}, count)  -- mine any of the named items (OR-group)
--   qb.craft_item({names}, count)    -- smelt/assemble any of them in a machine
--   qb.research(name)                -- finish the named research
--   qb.build_block({names}, count)   -- build any of the named blocks (OR-group)
--   qb.build_stack({top}, {bottom})  -- build one of the top blocks standing on a bottom one
--   qb.build_chain({steps})          -- build a run of blocks actually wired one into the next
--   qb.open_gui({names})             -- open one of the named windows
--   qb.close_all_gui()               -- close the last window left open
--   qb.return_home()                 -- leave the home sector and walk back into it
--   qb.count(id, count, label)       -- generic manual counter (advance from your own code)

local qb = {}

-- ---------------------------------------------------------------------------
-- internal state
-- ---------------------------------------------------------------------------

local chapter_defs = {}   -- chapters declared since the last qb.build()
local quest_defs = {}      -- quests declared since the last qb.build()
local quest_by_name = {}   -- lower-cased name -> quest definition (runtime registry, every mod's)
local activated_handler_id = nil
local spawned_handler_id = nil

-- Polled objectives: the quest defs carrying at least one, the scheduler handle
-- the poll runs on, and per quest the counter reading each objective started
-- from. See the poll driver below.
local poll_defs = {}
local poll_handle = nil
local poll_anchors = {}
local poll_interval_ticks = 30

local function to_list(names)
   if type(names) == "string" then
      return { names }
   end
   local list = {}
   for _, n in ipairs(names or {}) do
      list[#list + 1] = n
   end
   return list
end

-- A prototype name reaches Lua as the display form of an FName, and outside the
-- editor that form is whatever registered the name first: the Log item comes back
-- as "log" in a packaged build. Every name matched against an event is therefore
-- folded to lower case, on both sides of the comparison.
local function to_set(names)
   local set = {}
   for _, n in ipairs(to_list(names)) do
      set[n:lower()] = true
   end
   return set
end

-- An objective's `event` is one event id, several of them, or none at all for a
-- purely manual counter.
local function to_event_list(event)
   if event == nil then
      return {}
   end
   if type(event) == "table" then
      return event
   end
   return { event }
end

local function names_label(list)
   local parts = {}
   for _, n in ipairs(list) do
      parts[#parts + 1] = n
   end
   return table.concat(parts, " / ")
end

-- ---------------------------------------------------------------------------
-- objective factories
--
-- Each returns a plain spec table consumed by the framework:
--   { kind, id, event, required, show_progress, label,
--     match  = function(ctx) -> bool,        -- does this event advance us?
--     amount = function(ctx) -> number }     -- how much to advance by
-- `event` may be nil for purely manual objectives (kind == "count").
--
-- An objective whose source is a counter the engine already keeps carries
--   poll = function() -> number|nil          -- the counter now, nil if unreadable
-- instead of an event: the framework reads it on an interval and advances by
-- how much the counter moved since the objective started watching it.
-- ---------------------------------------------------------------------------

-- `opts.weights` gives an item a rate other than one unit per item, which is how
-- an OR-group whose members are not worth the same is written: 20 coal or 40
-- logs is count 40 with coal weighted 2, and any mix in between counts.
function qb.collect_item(names, count, opts)
   opts = opts or {}
   local list = to_list(names)
   local set = to_set(list)
   local weights = {}
   for name, weight in pairs(opts.weights or {}) do
      weights[name:lower()] = weight
   end
   return {
      kind = "collect_item",
      id = opts.id or ("collect_" .. names_label(list):gsub("[^%w]", "_")),
      event = defines.events.on_player_mined_item,
      required = count or 1,
      show_progress = true,
      label = opts.label,
      match = function(ctx) return ctx.item ~= nil and set[ctx.item.name:lower()] == true end,
      amount = function(ctx) return (ctx.count or 1) * (weights[ctx.item.name:lower()] or 1) end,
   }
end

-- Items as they are produced rather than as they sit in an inventory: a player
-- who smelts the required amount and then spends it still closes the objective.
-- A machine craft and a hand craft both count, so the objective does not care
-- whether the recipe was run in a block or in the player's own crafter.
--
-- Production is a counter the surface already keeps, so this objective reads it
-- rather than answering an event: a craft is the hottest thing the simulation
-- does, and every machine on the map would otherwise call into lua for output
-- no quest asked about.
function qb.craft_item(names, count, opts)
   opts = opts or {}
   local list = to_list(names)
   local items = nil
   return {
      kind = "craft_item",
      id = opts.id or ("craft_" .. names_label(list):gsub("[^%w]", "_")),
      required = count or 1,
      show_progress = true,
      label = opts.label,
      poll = function()
         if dim == nil then
            return nil
         end
         if items == nil then
            items = {}
            for _, name in ipairs(list) do
               local item = StaticItem.find(name)
               if item == nil then
                  print_err("questbook: craft_item references unknown item '" .. name .. "'")
               else
                  items[#items + 1] = item
               end
            end
         end
         local total = 0
         for _, item in ipairs(items) do
            total = total + dim:get_produced(item)
         end
         return total
      end,
   }
end

function qb.build_block(names, count, opts)
   opts = opts or {}
   local list = to_list(names)
   local set = to_set(list)
   return {
      kind = "build_block",
      id = opts.id or ("build_" .. names_label(list):gsub("[^%w]", "_")),
      event = defines.events.on_built_block,
      required = count or 1,
      show_progress = (count or 1) > 1,
      label = opts.label,
      match = function(ctx) return ctx.block ~= nil and set[ctx.block.name:lower()] == true end,
      amount = function(ctx) return 1 end,
   }
end

-- One block standing directly on another, in either build order: the objective
-- answers the top block being placed over a bottom one and the bottom block
-- being placed under a top one, so a player who builds the stack upside down is
-- not left with a quest that cannot close.
function qb.build_stack(top_names, bottom_names, opts)
   opts = opts or {}
   local top_list = to_list(top_names)
   local top = to_set(top_list)
   local bottom = to_set(bottom_names)
   return {
      kind = "build_stack",
      id = opts.id or ("stack_" .. names_label(top_list):gsub("[^%w]", "_")),
      event = defines.events.on_built_block,
      required = 1,
      show_progress = false,
      label = opts.label,
      match = function(ctx)
         if ctx.block == nil or ctx.position == nil then
            return false
         end
         if top[ctx.block.name:lower()] then
            local under = dim:get_cell(ctx.position + Vec3i.down)
            return under ~= nil and bottom[under.name:lower()] == true
         end
         if bottom[ctx.block.name:lower()] then
            local over = dim:get_cell(ctx.position + Vec3i.up)
            return over ~= nil and top[over.name:lower()] == true
         end
         return false
      end,
      amount = function(ctx) return 1 end,
   }
end

-- A run of blocks wired one into the next. Every step names the block and its two
-- ends: `inp` is the accessor the previous step feeds, `out` the accessor feeding
-- the next one, and an end left out means every side of that block is tried. The
-- objective answers any block of the run being placed and walks outwards from it in
-- both directions, so the run may be assembled in any order.
--
-- The walk follows accessors, not cells: it repeats the test the simulation makes
-- before moving a resource across a side, so a run that reads as built here is a
-- run that really carries what it carries end to end whatever the blocks' rotations.
-- Item sides count as well as resource ones, which is what a machine emptying itself
-- into the chest beside it is.
function qb.build_chain(steps, opts)
   opts = opts or {}
   local blocks = {}
   for i, step in ipairs(steps) do
      blocks[i] = to_set(step.block)
   end

   -- A step names the accessor at each of its ends, or leaves it out and every side of the block is
   -- tried: a chest carries one input accessor per side, and which one meets the run is up to where
   -- the player stood the chest.
   local function sides(block, acc_name)
      if acc_name == nil then
         return block:accessors()
      end
      local side = block:find_accessor(acc_name)
      return side ~= nil and { side } or {}
   end

   -- Both ends have to agree on what crosses them: resource against resource on one channel, items
   -- against items. `want_output` is which way the step is walking -- into this block on the way
   -- back to the start, out of it on the way to the end.
   local function links(near, far, want_output)
      local rn, rf = ResourceAccessor.cast(near), ResourceAccessor.cast(far)
      if rn ~= nil and rf ~= nil then
         if rn.channel ~= rf.channel then
            return false
         end
         if want_output then
            return rn.is_input and rf.is_output
         end
         return rn.is_output and rf.is_input
      end
      local inn, inf = BaseInventoryAccessor.cast(near), BaseInventoryAccessor.cast(far)
      if inn ~= nil and inf ~= nil then
         if want_output then
            return inn.input ~= nil and inf.output ~= nil
         end
         return inn.output ~= nil and inf.input ~= nil
      end
      return false
   end

   local function across(block, acc_name, want_output)
      local found = {}
      for _, side in ipairs(sides(block, acc_name)) do
         local facing = side:neighbor()
         if facing ~= nil and links(side, facing, want_output) and facing.owner ~= nil then
            found[#found + 1] = facing.owner
         end
      end
      return found
   end

   local function is_step(index, block)
      return block ~= nil and block.static_block ~= nil
         and blocks[index][block.static_block.name:lower()] == true
   end

   -- A side scanned rather than named can face more than one block that fits, so each end of the
   -- walk tries every neighbour it found instead of following the first one.
   local function fed_back_to_start(index, block)
      if index <= 1 then
         return true
      end
      for _, prev in ipairs(across(block, steps[index].inp, true)) do
         if is_step(index - 1, prev) and fed_back_to_start(index - 1, prev) then
            return true
         end
      end
      return false
   end

   local function feeds_on_to_end(index, block)
      if index >= #steps then
         return true
      end
      for _, next_block in ipairs(across(block, steps[index].out, false)) do
         if is_step(index + 1, next_block) and feeds_on_to_end(index + 1, next_block) then
            return true
         end
      end
      return false
   end

   local function built_chain(index, block)
      return fed_back_to_start(index, block) and feeds_on_to_end(index, block)
   end

   local last = to_list(steps[#steps].block)
   return {
      kind = "build_chain",
      id = opts.id or ("chain_" .. names_label(last):gsub("[^%w]", "_")),
      event = defines.events.on_built_block,
      required = 1,
      show_progress = false,
      label = opts.label,
      match = function(ctx)
         if ctx.block == nil or ctx.position == nil then
            return false
         end
         local built = ctx.block.name:lower()
         local block = nil
         for i = 1, #steps do
            if blocks[i][built] then
               block = block or dim:get_block(ctx.position)
               if block ~= nil and built_chain(i, block) then
                  return true
               end
            end
         end
         return false
      end,
      amount = function(ctx) return 1 end,
   }
end

-- Window names as the engine emits them: "inventory", "recipes", "map", "research",
-- "questbook", "pause", "spawn", "saves".
function qb.open_gui(names, opts)
   opts = opts or {}
   local list = to_list(names)
   local set = to_set(list)
   return {
      kind = "open_gui",
      id = opts.id or ("open_" .. names_label(list):gsub("[^%w]", "_")),
      event = defines.events.on_gui_opened,
      required = 1,
      show_progress = false,
      label = opts.label,
      match = function(ctx) return ctx.gui ~= nil and set[ctx.gui:lower()] == true end,
      amount = function(ctx) return 1 end,
   }
end

-- The player is back in the world with nothing over it.
function qb.close_all_gui(opts)
   opts = opts or {}
   return {
      kind = "close_all_gui",
      id = opts.id or "close_all_gui",
      event = defines.events.on_gui_closed,
      required = 1,
      show_progress = false,
      label = opts.label,
      match = function(ctx) return ctx.any_open == false end,
      amount = function(ctx) return 1 end,
   }
end

-- Back at the base. The spawn is the fixed point every world starts the player
-- at, so home is sector 0,0; the player has to leave it and come back.
function qb.return_home(opts)
   opts = opts or {}
   local left = false
   return {
      kind = "return_home",
      id = opts.id or "return_home",
      event = defines.events.on_player_at_sector,
      required = 1,
      show_progress = false,
      label = opts.label,
      match = function(ctx)
         if ctx.pos == nil then
            return false
         end
         if ctx.pos.x ~= 0 or ctx.pos.y ~= 0 then
            left = true
            return false
         end
         return left
      end,
      amount = function(ctx) return 1 end,
   }
end

function qb.research(name, opts)
   opts = opts or {}
   return {
      kind = "research",
      id = opts.id or ("research_" .. tostring(name)),
      event = defines.events.on_research_finished,
      required = 1,
      show_progress = false,
      label = opts.label,
      match = function(ctx) return ctx.research ~= nil and ctx.research.name:lower() == name:lower() end,
      amount = function(ctx) return 1 end,
   }
end

-- ---------------------------------------------------------------------------
-- ghost plans
--
-- A plan is a drawing the quest puts down: one ghost per cell, each standing for
-- the block that belongs there, and the player builds into it. `cells` carry an
-- offset from the plan's anchor, the block, and the rotation the block is placed
-- at.
--
-- The anchor is searched for the same way every time -- outward from the spawn
-- point, first spot that fits -- so the plan is found again after a reload with
-- nothing stored: a spot fits when every one of its cells is either free with
-- solid ground under it, or already holds a ghost or the block it stands for.
-- While the columns around the spawn are unloaded nothing fits, and the plan
-- waits until the player is back at the base.
-- ---------------------------------------------------------------------------

local plan_search_radius = 12
local plan_search_depth = { 0, -1, -2, 1 }

-- Rings outward from the anchor, so the plan lands as close to the spawn as the
-- space allows, and always in the same order.
local function search_offsets(radius)
   local offsets = { { 0, 0 } }
   for r = 1, radius do
      for i = -r, r do
         offsets[#offsets + 1] = { i, -r }
         offsets[#offsets + 1] = { i, r }
      end
      for j = -r + 1, r - 1 do
         offsets[#offsets + 1] = { -r, j }
         offsets[#offsets + 1] = { r, j }
      end
   end
   return offsets
end

function qb.plan(cells, opts)
   opts = opts or {}
   local anchor = nil
   local offsets = search_offsets(opts.radius or plan_search_radius)

   local function at(base, cell)
      return base + Vec3i.new(cell.at[1], cell.at[2], cell.at[3] or 0)
   end

   local function standing(cell, base)
      local block = dim:get_cell(at(base, cell))
      return block ~= nil and block.name:lower() or nil
   end

   local function fits(cell, base)
      local block = standing(cell, base)
      if block ~= nil then
         return block == "ghost" or block == cell.block:lower()
      end
      return dim:get_cell(at(base, cell) + Vec3i.down) ~= nil
   end

   local function find_anchor()
      local spawn = dim ~= nil and dim:spawn_point() or nil
      if spawn == nil then
         return nil
      end
      for _, dz in ipairs(plan_search_depth) do
         for _, off in ipairs(offsets) do
            local base = spawn + Vec3i.new(off[1], off[2], dz)
            local ok = true
            for _, cell in ipairs(cells) do
               if not fits(cell, base) then
                  ok = false
                  break
               end
            end
            if ok then
               return base
            end
         end
      end
      return nil
   end

   local function base()
      if anchor == nil then
         anchor = find_anchor()
      end
      return anchor
   end

   local plan = {}

   -- Ghosts go only into cells that are still empty, so a plan put down again --
   -- after a reload, or after the quest opened while the base was out of reach --
   -- adds nothing to what the player has already built.
   function plan.place()
      local found = base()
      if found == nil then
         return false
      end
      for _, cell in ipairs(cells) do
         local pos = at(found, cell)
         if dim:get_cell(pos) == nil then
            dim:spawn_ghost(pos, cell.rot, StaticBlock.get(cell.block))
         end
      end
      return true
   end

   function plan.objective(o)
      o = o or {}
      return {
         kind = "plan_built",
         id = o.id or ("plan_" .. tostring(cells[1].block)),
         required = #cells,
         show_progress = true,
         label = o.label,
         poll = function()
            if not plan.place() then
               return nil
            end
            local built = 0
            for _, cell in ipairs(cells) do
               if standing(cell, anchor) == cell.block:lower() then
                  built = built + 1
               end
            end
            return built
         end,
      }
   end

   return plan
end

-- Generic counter with no automatic event source. Advance it yourself from
-- gameplay code via qb.advance(quest_name, objective_id, amount).
function qb.count(id, count, label)
   return {
      kind = "count",
      id = id,
      event = nil,
      required = count or 1,
      show_progress = true,
      label = label,
      match = function() return false end,
      amount = function() return 0 end,
   }
end

-- ---------------------------------------------------------------------------
-- declaration
-- ---------------------------------------------------------------------------

function qb.chapter(name, def)
   def = def or {}
   def.name = name
   chapter_defs[#chapter_defs + 1] = def
   return def
end

function qb.quest(name, def)
   def = def or {}
   def.name = name
   def.objectives = def.objectives or {}
   quest_defs[#quest_defs + 1] = def
   quest_by_name[name:lower()] = def
   return def
end

-- ---------------------------------------------------------------------------
-- runtime: objective creation + progress tracking
-- ---------------------------------------------------------------------------

local function build_objectives(quest, def)
   quest:clear_objectives()
   poll_anchors[def.name] = nil
   for _, spec in ipairs(def.objectives) do
      local obj = quest:create_objective(spec.id)
      if obj ~= nil then
         if spec.label ~= nil then
            obj.label = spec.label
         end
         obj.show_progress = spec.show_progress
         obj.required = spec.required
         obj.current = 0
         obj.completed = (spec.required <= 0)
      end
   end
end

local function all_objectives_done(quest, def)
   if #def.objectives == 0 then
      return false
   end
   for _, spec in ipairs(def.objectives) do
      local obj = quest:find_objective_by_id(spec.id)
      if obj == nil or not obj.completed then
         return false
      end
   end
   return true
end

-- Build the per-quest `events` table the engine subscribes to while the quest is
-- Active. Objectives are grouped by their source event; one handler per event
-- advances every matching objective and completes the quest when all are done.
local function build_events_table(def)
   local by_event = {}
   for _, spec in ipairs(def.objectives) do
      for _, event in ipairs(to_event_list(spec.event)) do
         by_event[event] = by_event[event] or {}
         table.insert(by_event[event], spec)
      end
   end

   local events = {}
   for event, specs in pairs(by_event) do
      events[event] = function(ctx, quest)
         for _, spec in ipairs(specs) do
            if spec.match(ctx) then
               local obj = quest:find_objective_by_id(spec.id)
               if obj ~= nil and not obj.completed then
                  local inc = spec.amount(ctx) or 0
                  local newcur = obj.current + inc
                  if newcur > spec.required then
                     newcur = spec.required
                  end
                  obj:set_progress(newcur, spec.required, spec.show_progress)
               end
            end
         end
         if all_objectives_done(quest, def) then
            quest:complete()
         end
      end
   end
   return events
end

-- Read every polled objective of every active quest and advance it by how much
-- its counter moved.
--
-- An objective anchors itself the first time it is read: the counter it starts
-- from and the progress it starts at. That is taken on the first poll rather
-- than when the quest activates, because a save restores an objective's
-- progress after activating its quest -- by the first simulation tick the
-- restored value is in place, and the objective goes on counting from it.
local function poll_tick()
   for _, def in ipairs(poll_defs) do
      local quest = StaticQuest.find(def.name)
      -- Objectives only exist while the quest is Active, so a nil lookup also
      -- covers the Locked/Completed cases.
      if quest ~= nil then
         local anchors = poll_anchors[def.name]
         local advanced = false

         for _, spec in ipairs(def.objectives) do
            local obj = nil
            if spec.poll ~= nil then
               obj = quest:find_objective_by_id(spec.id)
            end
            if obj ~= nil and not obj.completed then
               local now = spec.poll()
               if now ~= nil then
                  if anchors == nil then
                     anchors = {}
                     poll_anchors[def.name] = anchors
                  end
                  if anchors[spec.id] == nil then
                     anchors[spec.id] = { base = obj.current, from = now }
                  end

                  local anchor = anchors[spec.id]
                  local gained = now - anchor.from
                  if gained < 0 then
                     gained = 0
                  end
                  local newcur = anchor.base + gained
                  if newcur > spec.required then
                     newcur = spec.required
                  end
                  if newcur ~= obj.current then
                     obj:set_progress(newcur, spec.required, spec.show_progress)
                     advanced = true
                  end
               end
            end
         end

         if advanced and all_objectives_done(quest, def) then
            quest:complete()
         end
      end
   end
end

-- Manually advance a "count" objective from gameplay code.
function qb.advance(quest_name, objective_id, amount)
   local q = StaticQuest.find(quest_name)
   local def = quest_by_name[quest_name:lower()]
   if q == nil or def == nil then
      return
   end
   -- Objectives only exist while the quest is Active, so a nil lookup also covers
   -- the Locked/Completed cases.
   local obj = q:find_objective_by_id(objective_id)
   if obj == nil or obj.completed then
      return
   end
   local newcur = obj.current + (amount or 1)
   if newcur > obj.required then
      newcur = obj.required
   end
   obj:set_progress(newcur, obj.required, obj.show_progress)
   if all_objectives_done(q, def) then
      q:complete()
   end
end

-- ---------------------------------------------------------------------------
-- registration (call qb.build() once at the end of your mod init)
-- ---------------------------------------------------------------------------

local function resolve_relations(defs)
   -- accumulate required-quest names per quest
   local required = {}
   for _, def in ipairs(defs) do
      required[def.name] = {}
      if def.requires ~= nil then
         for _, r in ipairs(def.requires) do
            table.insert(required[def.name], r)
         end
      end
   end
   -- "A unlocks {B,C}" means B and C require A
   for _, def in ipairs(defs) do
      if def.unlocks ~= nil then
         for _, target in ipairs(def.unlocks) do
            if required[target] == nil then
               print_err("questbook: quest '" .. def.name .. "' unlocks unknown quest '" .. target .. "'")
            else
               table.insert(required[target], def.name)
            end
         end
      end
   end
   return required
end

-- Every mod calling require('questbook') shares one instance of this module: the
-- module cache is keyed by resolved path for the whole lua state. So build()
-- registers the batch declared since the last call and hands the lists back
-- empty rather than latching -- a second mod's build() must not re-register the
-- first mod's chapters, and must not be a no-op. `quest_by_name` is the runtime
-- registry the on_quest_activated handler reads and keeps every mod's quests.
function qb.build()
   local chapters = chapter_defs
   local quests = quest_defs
   chapter_defs = {}
   quest_defs = {}

   -- 1) chapters
   for _, def in ipairs(chapters) do
      db:from_table({
         class = "StaticChapter",
         name = def.name,
         label = def.label,
      })
   end

   -- 2) quests (objectives are created later, on activation)
   for _, def in ipairs(quests) do
      local row = {
         class = "StaticQuest",
         name = def.name,
         label = def.label,
         description_parts = def.description or {},
         auto_unlock = (def.auto_unlock ~= false),
         events = build_events_table(def),
         on_unlock = def.on_unlock,
      }
      if def.chapter ~= nil then
         local chapter = StaticChapter.find(def.chapter)
         if chapter == nil then
            print_err("questbook: quest '" .. def.name .. "' references unknown chapter '" .. def.chapter .. "'")
         else
            row.chapter = chapter
         end
      end
      db:from_table(row)

      for _, spec in ipairs(def.objectives) do
         if spec.poll ~= nil then
            poll_defs[#poll_defs + 1] = def
            break
         end
      end

      if def.context ~= nil then
         local q = StaticQuest.get(def.name)
         for _, item_name in ipairs(def.context) do
            local item = StaticItem.find(item_name)
            if item ~= nil then
               q:add_context(item)
            end
         end
      end
   end

   -- 3) relations: required_quests (quest graph) + chapter gating
   local required = resolve_relations(quests)
   for _, def in ipairs(quests) do
      local names = required[def.name]
      if names ~= nil and #names > 0 then
         local refs = {}
         for _, n in ipairs(names) do
            local r = StaticQuest.find(n)
            if r ~= nil then
               table.insert(refs, r)
            end
         end
         StaticQuest.get(def.name).required_quests = refs
      end
   end
   for _, def in ipairs(chapters) do
      if def.requires ~= nil and #def.requires > 0 then
         local refs = {}
         for _, n in ipairs(def.requires) do
            local r = StaticQuest.find(n)
            if r ~= nil then
               table.insert(refs, r)
            end
         end
         StaticChapter.get(def.name).required_quests = refs
      end
   end

   -- 4) (re)build objectives whenever a quest becomes Active (fresh unlock or
   --    when a save loads a quest as Active), so objectives survive reload.
   if activated_handler_id == nil then
      local es = EventSystem.get()
      activated_handler_id = es:sub(defines.events.on_quest_activated, function(ctx)
         local quest = ctx.quest
         if quest == nil then
            return
         end
         local def = quest_by_name[quest.name:lower()]
         if def == nil then
            return
         end
         build_objectives(quest, def)
      end)
   end

   -- 5) drive the polled objectives. The scheduler is emptied when a session
   --    ends, so the poll is re-armed for each world the player enters, and the
   --    anchors of the previous world go with it.
   if spawned_handler_id == nil then
      local es = EventSystem.get()
      spawned_handler_id = es:sub(defines.events.on_player_spawn, function()
         if poll_handle ~= nil then
            sim.cancel(poll_handle)
         end
         poll_anchors = {}
         poll_handle = sim.every(poll_interval_ticks, poll_tick)
      end)
   end

   print_info("questbook: registered " .. tostring(#chapters) .. " chapters, " .. tostring(#quests) .. " quests")
end

return qb
