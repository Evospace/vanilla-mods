local qb = {}

local chapter_defs = {}
local quest_defs = {}
local quest_by_name = {}
local activated_handler_id = nil
local spawned_handler_id = nil

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

local function to_set(names)
   local set = {}
   for _, n in ipairs(to_list(names)) do
      set[n:lower()] = true
   end
   return set
end

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

function qb.craft_item(names, count, opts)
   opts = opts or {}
   local list = to_list(names)
   local set = to_set(list)
   return {
      kind = "craft_item",
      id = opts.id or ("craft_" .. names_label(list):gsub("[^%w]", "_")),
      event = defines.events.on_player_crafted,
      required = count or 1,
      show_progress = true,
      label = opts.label,
      match = function(ctx) return ctx.item ~= nil and set[ctx.item.name:lower()] == true end,
      amount = function(ctx) return ctx.count or 1 end,
   }
end

local function surface_count(kind, prefix, read, names, count, opts)
   opts = opts or {}
   local list = to_list(names)
   local items = nil
   return {
      kind = kind,
      id = opts.id or (prefix .. names_label(list):gsub("[^%w]", "_")),
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
                  print_err("questbook: " .. kind .. " references unknown item '" .. name .. "'")
               else
                  items[#items + 1] = item
               end
            end
         end
         local total = 0
         for _, item in ipairs(items) do
            total = total + read(item)
         end
         return total
      end,
   }
end

function qb.produce_item(names, count, opts)
   return surface_count("produce_item", "produce_", function(item) return dim:get_produced(item) end, names, count, opts)
end

function qb.consume_item(names, count, opts)
   return surface_count("consume_item", "consume_", function(item) return dim:get_consumed(item) end, names, count, opts)
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

local function make_chain(name, steps)
   local blocks = {}
   for i, step in ipairs(steps) do
      blocks[i] = to_set(step.block)
   end

   local function sides(block, acc_name)
      if acc_name == nil then
         return block:accessors()
      end
      local side = block:find_accessor(acc_name)
      return side ~= nil and { side } or {}
   end

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

   local function path_back(index, block)
      if index <= 1 then
         return {}
      end
      for _, prev in ipairs(across(block, steps[index].inp, true)) do
         if is_step(index - 1, prev) then
            local path = path_back(index - 1, prev)
            if path ~= nil then
               path[#path + 1] = prev
               return path
            end
         end
      end
      return nil
   end

   local function path_on(index, block)
      if index >= #steps then
         return {}
      end
      for _, next_block in ipairs(across(block, steps[index].out, false)) do
         if is_step(index + 1, next_block) then
            local path = path_on(index + 1, next_block)
            if path ~= nil then
               table.insert(path, 1, next_block)
               return path
            end
         end
      end
      return nil
   end

   local function through(index, block)
      local path = path_back(index, block)
      if path == nil then
         return nil
      end
      local rest = path_on(index, block)
      if rest == nil then
         return nil
      end
      path[#path + 1] = block
      for _, b in ipairs(rest) do
         path[#path + 1] = b
      end
      return path
   end

   local chain = { name = name, steps = steps }

   function chain.find_built(ctx)
      if ctx.block == nil or ctx.position == nil then
         return nil
      end
      local built = ctx.block.name:lower()
      local block = nil
      for i = 1, #steps do
         if blocks[i][built] then
            block = block or dim:get_block(ctx.position)
            if block ~= nil then
               local found = through(i, block)
               if found ~= nil then
                  return found
               end
            end
         end
      end
      return nil
   end

   function chain.remember(found)
      if name == nil or storage == nil then
         return
      end
      local positions = {}
      for i, block in ipairs(found) do
         positions[i] = block.pos
      end
      storage.chains = storage.chains or {}
      storage.chains[name] = positions
   end

   function chain.recall()
      if name == nil or storage == nil or storage.chains == nil or dim == nil then
         return nil
      end
      local positions = storage.chains[name]
      if positions == nil or #positions ~= #steps then
         return nil
      end
      local found = {}
      for i, pos in ipairs(positions) do
         local block = dim:get_block(pos)
         if not is_step(i, block) then
            return nil
         end
         found[i] = block
      end
      return found
   end

   return chain
end

function qb.chain(name, steps)
   return make_chain(name, steps)
end

function qb.build_chain(chain, opts)
   opts = opts or {}
   if chain.steps == nil then
      chain = make_chain(nil, chain)
   end
   local last = to_list(chain.steps[#chain.steps].block)
   return {
      kind = "build_chain",
      id = opts.id or ("chain_" .. names_label(last):gsub("[^%w]", "_")),
      event = defines.events.on_built_block,
      required = 1,
      show_progress = false,
      label = opts.label,
      match = function(ctx)
         local found = chain.find_built(ctx)
         if found == nil then
            return false
         end
         chain.remember(found)
         return true
      end,
      amount = function(ctx) return 1 end,
   }
end

function qb.chain_running(chain, index, opts)
   opts = opts or {}
   local accepted = {}
   for _, state in ipairs(opts.states or { "working", "resource_saturated" }) do
      accepted[defines.block_state[state]] = true
   end
   return {
      kind = "chain_running",
      id = opts.id or ("running_" .. chain.name .. "_" .. tostring(index)),
      event = defines.events.on_built_block,
      required = 1,
      show_progress = false,
      label = opts.label,
      poll_absolute = true,
      poll = function()
         local found = chain.recall()
         if found == nil then
            return nil
         end
         return accepted[found[index].state] and 1 or 0
      end,
      match = function(ctx)
         local found = chain.find_built(ctx)
         if found ~= nil then
            chain.remember(found)
         end
         return false
      end,
      amount = function(ctx) return 0 end,
   }
end

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

function qb.search_item(names, opts)
   opts = opts or {}
   local list = to_list(names)
   local set = to_set(list)
   return {
      kind = "search_item",
      id = opts.id or ("search_" .. names_label(list):gsub("[^%w]", "_")),
      event = defines.events.on_item_searched,
      required = 1,
      show_progress = false,
      label = opts.label,
      match = function(ctx)
         if ctx.items == nil then
            return false
         end
         for _, item in ipairs(ctx.items) do
            if set[item.name:lower()] then
               return true
            end
         end
         return false
      end,
      amount = function(ctx) return 1 end,
   }
end

function qb.view_recipes(names, opts)
   opts = opts or {}
   local list = to_list(names)
   local set = to_set(list)
   return {
      kind = "view_recipes",
      id = opts.id or ("recipes_" .. names_label(list):gsub("[^%w]", "_")),
      event = defines.events.on_recipes_shown,
      required = 1,
      show_progress = false,
      label = opts.label,
      match = function(ctx) return ctx.item ~= nil and set[ctx.item.name:lower()] == true end,
      amount = function(ctx) return 1 end,
   }
end

function qb.hotbar_item(names, opts)
   opts = opts or {}
   local list = to_list(names)
   local items = nil
   return {
      kind = "hotbar_item",
      id = opts.id or ("hotbar_" .. names_label(list):gsub("[^%w]", "_")),
      required = 1,
      show_progress = false,
      label = opts.label,
      poll_absolute = true,
      poll = function()
         local player = Player.get()
         if player == nil then
            return nil
         end
         if items == nil then
            items = {}
            for _, name in ipairs(list) do
               local item = StaticItem.find(name)
               if item == nil then
                  print_err("questbook: hotbar_item references unknown item '" .. name .. "'")
               else
                  items[#items + 1] = item
               end
            end
         end
         for _, item in ipairs(items) do
            if player:hotbar_has(item) then
               return 1
            end
         end
         return 0
      end,
   }
end

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

local function build_objectives(quest, def)
   local done = quest.state == defines.quest_state.completed
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
         obj.current = done and spec.required or 0
         obj.completed = done or (spec.required <= 0)
      end
   end
end

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

local function poll_tick()
   for _, def in ipairs(poll_defs) do
      local quest = StaticQuest.find(def.name)
      if quest ~= nil and quest.state == defines.quest_state.active then
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

function qb.advance(quest_name, objective_id, amount)
   local q = StaticQuest.find(quest_name)
   local def = quest_by_name[quest_name:lower()]
   if q == nil or def == nil then
      return
   end
   if q.state ~= defines.quest_state.active then
      return
   end
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

local function resolve_relations(defs)
   local required = {}
   for _, def in ipairs(defs) do
      required[def.name] = {}
      if def.requires ~= nil then
         for _, r in ipairs(def.requires) do
            table.insert(required[def.name], r)
         end
      end
   end
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

function qb.build()
   local chapters = chapter_defs
   local quests = quest_defs
   chapter_defs = {}
   quest_defs = {}

   for _, def in ipairs(chapters) do
      db:from_table({
         class = "StaticChapter",
         name = def.name,
         label = def.label,
      })
   end

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
