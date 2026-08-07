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
--       label       = ..., description = { ... }, image = "Textures/ore.png",
--       unlocks     = { "SmeltCopper" },
--       objectives  = { qb.collect_item({ "ChalcopyriteOre", "MalachiteOre" }, 20) },
--   })
--   qb.build()   -- registers everything; call once at the end of your mod init()
--
-- Objective factories:
--   qb.collect_item({names}, count)  -- mine any of the named items (OR-group)
--   qb.research(name)                -- finish the named research
--   qb.build_block({names}, count)   -- build any of the named blocks (OR-group)
--   qb.build_stack({top}, {bottom})  -- build one of the top blocks standing on a bottom one
--   qb.count(id, count, label)       -- generic manual counter (advance from your own code)

local qb = {}

-- ---------------------------------------------------------------------------
-- internal state
-- ---------------------------------------------------------------------------

local chapter_defs = {}   -- chapters declared since the last qb.build()
local quest_defs = {}      -- quests declared since the last qb.build()
local quest_by_name = {}   -- lower-cased name -> quest definition (runtime registry, every mod's)
local activated_handler_id = nil

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
      if spec.event ~= nil then
         by_event[spec.event] = by_event[spec.event] or {}
         table.insert(by_event[spec.event], spec)
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
         description_parts = def.description or {},
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
      }
      if def.chapter ~= nil then
         local chapter = StaticChapter.find(def.chapter)
         if chapter == nil then
            print_err("questbook: quest '" .. def.name .. "' references unknown chapter '" .. def.chapter .. "'")
         else
            row.chapter = chapter
         end
      end
      if def.image ~= nil then
         row.image = def.image
      end
      db:from_table(row)

      if def.context ~= nil then
         local q = StaticQuest.find(def.name)
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
         StaticQuest.find(def.name).required_quests = refs
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
         StaticChapter.find(def.name).required_quests = refs
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

   print_info("questbook: registered " .. tostring(#chapters) .. " chapters, " .. tostring(#quests) .. " quests")
end

return qb
