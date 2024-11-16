local vanilla_mod = {}

function dump(o)
   if type(o) == 'table' then
      local s = '('
      for k,v in pairs(o) do
         s = s .. k ..' = ' .. dump(v) .. ','
      end
      return s .. ')'
   elseif type(o) == 'userdata' then
      return tostring(o)
   else
      return tostring(o)
   end
end


function vanilla_mod.pre_init(mod_table)
   register_settings()
end

function vanilla_mod.init(mod_table)
   local es = EventSystem.get_instance()

   print("11111111")
   print(dump(mod_table))

   es:sub(defines.events.on_player_at_sector, function(context) 
      --local pos = context.pos * cs.sector_size + Vec3i.new(0,0,23)
      --print("On sector "..tostring(pos)) 
      --local block = StaticBlock.find("CopperMacerator")
      --dim:spawn_block_identity(pos, block)
      local grid_pos = LargeSectors.world_block_to_grid(pos)
      if not regions:has_region(grid_pos) then
         local region = regions:get_region(grid_pos)

         local ms = MapStructure.new()
         ms.structure = ss
         ms.offset = Vec2i.zero()

         region:add_structure(ms)
      end
   end)

   local resources = {
      
      {"CopperOre", 1.0},
      {"CoalOre", 1.5},

      {"IronOre", 0.5},
      {"AluminiumOre", 0.25},
      {"UraniumOre", 0.125},
      {"MineralWater", 1.0},
      {"RawOil", 0.5},
   }

   for key, value in ipairs(resources) do
      local ed = ExtractionData.new()
      ed.item = StaticItem.find(value[1])
      ed.speed = value[2]
      regions:add_resource(ed)
   end

   local ss = StaticStructure.new("StartPlatform")
   ss.generate = function(context) print("11111111111") end
   ss.size = Vec2i.new(10, 10);
   db:reg(ss)
end

function register_settings()
   db:from_table({
      class = "Setting",
      category = "Controls",
      type = "Key",
      string_value = "ActionPrimary",
      key = "LeftMouseButton",
   })
   db:from_table({
      class = "Setting",
      category = "Controls",
      type = "Key",
      string_value = "ActionRotate",
      key = "R",
   })
   db:from_table({
      class = "Setting",
      category = "Controls",
      type = "Key",
      string_value = "ActionSecondary",
      key = "RightMouseButton",
   })
   db:from_table({
      class = "Setting",
      category = "Controls",
      type = "Key",
      string_value = "ActionTertiary",
      key = "MiddleMouseButton",
   })
   local nums = {"Zero","One","Two", "Three", "Four", "Five", "Six", "Seven", "Eight", "Nine"}
   for i=0,9 do
      db:from_table({
         class = "Setting",
         category = "Controls",
         type = "Key",
         string_value = "ActiveSlot_"..i,
         key = nums[i],
      })
   end
   db:from_table({
      class = "Setting",
      category = "Controls",
      type = "Key",
      string_value = "ChangeMovementMode",
      key = "F",
   })
   db:from_table({
      class = "Setting",
      category = "Controls",
      type = "Key",
      string_value = "Crouch",
      key = "C",
   })
   db:from_table({
      class = "Setting",
      category = "Controls",
      type = "Key",
      string_value = "EmptyHand",
      key = "None",
   })
   db:from_table({
      class = "Setting",
      category = "Controls",
      type = "Key",
      string_value = "Ecs",
      key = "Escape",
   })
   db:from_table({
      class = "Setting",
      category = "Controls",
      type = "Key",
      string_value = "Inventory",
      key = "I",
   })
   db:from_table({
      class = "Setting",
      category = "Controls",
      type = "Key",
      string_value = "Journal",
      key = "J",
   })
   db:from_table({
      class = "Setting",
      category = "Controls",
      type = "Key",
      string_value = "Jump",
      key = "SpaceBar",
   })
   db:from_table({
      class = "Setting",
      category = "Controls",
      type = "Key",
      string_value = "LoadSettings",
      key = "Ctrl+V",
   })
   db:from_table({
      class = "Setting",
      category = "Controls",
      type = "Key",
      string_value = "NeiLeft",
      key = "Delete",
   })
   db:from_table({
      class = "Setting",
      category = "Controls",
      type = "Key",
      string_value = "NeiRight",
      key = "Alt+Delete",
   })
   db:from_table({
      class = "Setting",
      category = "Controls",
      type = "Key",
      string_value = "PickBlock",
      key = "Q",
   })
   db:from_table({
      class = "Setting",
      category = "Controls",
      type = "Key",
      string_value = "Recipe",
      key = "R",
   })
   db:from_table({
      class = "Setting",
      category = "Controls",
      type = "Key",
      string_value = "SaveSettings",
      key = "Ctrl+C",
   })
   db:from_table({
      class = "Setting",
      category = "Controls",
      type = "Key",
      string_value = "Sprint",
      key = "LeftShift",
   })
   db:from_table({
      class = "Setting",
      category = "Controls",
      type = "Key",
      string_value = "SwitchCreativeMode",
      key = "T",
   })
   db:from_table({
      class = "Setting",
      category = "Controls",
      type = "Key",
      string_value = "ThrowItem",
      key = "G",
   })
   db:from_table({
      class = "Setting",
      category = "Controls",
      type = "Key",
      string_value = "ToggleInventory",
      key = "E",
   })
   db:from_table({
      class = "Setting",
      category = "Controls",
      type = "Key",
      string_value = "ToggleMap",
      key = "M",
   })
   db:from_table({
      class = "Setting",
      category = "Controls",
      type = "Key",
      string_value = "ToggleReplaceMode",
      key = "Y",
   })
   db:from_table({
      class = "Setting",
      category = "Controls",
      type = "Key",
      string_value = "ToggleSideIcons",
      key = "X",
   })
   ---
   db:from_table({
      class = "Setting",
      category = "AnotherCat",
      type = "Int",
      string_value = "Inventory1",
      int_value = 123,
   })
   db:from_table({
      class = "Setting",
      category = "AnotherCat",
      type = "Int",
      string_value = "Inventory2",
      int_value = 321,
   })
   db:from_table({
      class = "Setting",
      category = "AnotherCat",
      type = "Bool",
      string_value = "Inventory3",
      int_value = 321,
   })
   db:from_table({
      class = "Setting",
      category = "AnotherCat",
      type = "String",
      string_value = "Inventory4",
      int_value = 321,
   })
end

function vanilla_mod.post_init(mod_table)
end

db:mod(vanilla_mod)
