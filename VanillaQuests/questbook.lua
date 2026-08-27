-- Declarative questbook: a mod declares chapters, quests and objectives, and the objectives track
-- the event bus themselves.
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
-- A quest takes all of its objectives; `any = true` makes them alternatives instead.
-- An objective label may carry `{count}`, the amount the objective asks for.
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

-- Polled objectives: the quest defs carrying one, the scheduler handle, and the counter each
-- objective started from.
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

-- An FName reaches Lua in whatever case registered it first, so names are matched folded.
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
-- Each returns a spec table:
--   { kind, id, event, required, show_progress, label,
--     match  = function(ctx) -> bool,        -- does this event advance us?
--     amount = function(ctx) -> number }     -- how much to advance by
--
-- Instead of `event` an objective may carry
--   poll = function() -> number|nil          -- the counter now, nil if unreadable
-- read on an interval and advanced by how much it moved, or by its reading outright with
-- `poll_absolute`.
-- ---------------------------------------------------------------------------

function qb.collect_item(names, count, opts)
   opts = opts or {}
   local list = to_list(names)
   local set = to_set(list)
   return {
      kind = "collect_item",
      id = opts.id or ("collect_" .. names_label(list):gsub("[^%w]", "_")),
      event = defines.events.on_player_mined_item,
      required = count or 1,
      show_progress = true,
      label = opts.label,
      match = function(ctx) return ctx.item ~= nil and set[ctx.item.name:lower()] == true end,
      amount = function(ctx) return ctx.count or 1 end,
   }
end

-- Items as produced, not as held: machine and hand crafts both count, and spending them after
-- still closes the objective. Polled off the surface counter rather than driven by an event.
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

-- One block standing directly on another, in either build order.
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

-- A run of blocks wired one into the next. A step names the block, the accessor the previous step
-- feeds (`inp`) and the one feeding the next (`out`); an end left out tries every side. The walk
-- follows accessors, not cells, and runs outwards from any placed block of the run.
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

   -- Both ends have to agree on what crosses them. `want_output` is the direction of the walk.
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

   -- A scanned side can face several blocks that fit, so every neighbour is tried.
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

-- Home is sector 0,0; the player has to leave it and come back.
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

-- Completion as the research tree holds it rather than as the moment it happened:
-- a research finished before its quest was ever unlocked closes the objective all
-- the same, and so does a world that starts with the whole tree complete.
function qb.research(name, opts)
   opts = opts or {}
   return {
      kind = "research",
      id = opts.id or ("research_" .. tostring(name)),
      required = 1,
      show_progress = false,
      label = opts.label,
      poll_absolute = true,
      poll = function()
         local res = StaticResearch.find(name)
         if res == nil then
            return nil
         end
         return res.completed and 1 or 0
      end,
   }
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

-- `any = true`: one objective closes the quest.
local function objectives_done(quest, def)
   if #def.objectives == 0 then
      return false
   end
   for _, spec in ipairs(def.objectives) do
      local obj = quest:find_objective_by_id(spec.id)
      local done = obj ~= nil and obj.completed
      if def.any then
         if done then
            return true
         end
      elseif not done then
         return false
      end
   end
   return not def.any
end

-- The `events` table the engine subscribes to while the quest is Active: one handler per event.
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
         if objectives_done(quest, def) then
            quest:complete()
         end
      end
   end
   return events
end

-- Advance every polled objective of every active quest by how much
-- its counter moved.
--
-- An objective anchors on its first poll, not on activation: a save restores progress after
-- activating the quest.
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
                  local newcur
                  if spec.poll_absolute then
                     newcur = now
                  else
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
                     newcur = anchor.base + gained
                  end
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

         if advanced and objectives_done(quest, def) then
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
   if objectives_done(q, def) then
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

-- Every mod shares one instance of this module, so build() registers the batch declared since the
-- last call and empties the lists. `quest_by_name` keeps every mod's quests for the handler.
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
         any_objective = (def.any == true),
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

   -- 4) (re)build objectives whenever a quest becomes Active, so they survive a reload
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

   -- 5) drive the polled objectives; the scheduler is emptied when a session ends
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
