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


function vanilla_mod.pre_init()
   register_settings()
end

function vanilla_mod.init()
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

   local ss = StaticStructure.reg("StartPlatform")
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
      label = "ActionPrimary",
      name = "ActionPrimary",
      default_key = "LeftMouseButton",
   })
   db:from_table({
      class = "Setting",
      category = "Controls",
      type = "Key",
      string_value = "ActionRotate",
      label = "ActionRotate",
      name = "ActionRotate",
      default_key = "R",
   })
   db:from_table({
      class = "Setting",
      category = "Controls",
      type = "Key",
      string_value = "ActionSecondary",
      label = "ActionSecondary",
      name = "ActionSecondary",
      default_key = "RightMouseButton",
   })
   db:from_table({
      class = "Setting",
      category = "Controls",
      type = "Key",
      string_value = "ActionTertiary",
      label = "ActionTertiary",
      name = "ActionTertiary",
      default_key = "MiddleMouseButton",
   })
   local nums = {"Zero","One","Two", "Three", "Four", "Five", "Six", "Seven", "Eight", "Nine"}
   for i=0,9 do
      db:from_table({
         class = "Setting",
         category = "Controls",
         type = "Key",
         string_value = "ActiveSlot_"..i,
         label = "ActiveSlot_"..i,
         name = "ActiveSlot_"..i,
         default_key = nums[i+1],
      })
   end
   db:from_table({
      class = "Setting",
      category = "Controls",
      type = "Key",
      string_value = "ChangeMovementMode",
      label = "ChangeMovementMode",
      name = "ChangeMovementMode",
      default_key = "F",
   })
   db:from_table({
      class = "Setting",
      category = "Controls",
      type = "Key",
      string_value = "Crouch",
      label = "Crouch",
      name = "Crouch",
      default_key = "C",
   })
   db:from_table({
      class = "Setting",
      category = "Controls",
      type = "Key",
      string_value = "EmptyHand",
      label = "EmptyHand",
      name = "EmptyHand",
      default_key = "None",
   })
   db:from_table({
      class = "Setting",
      category = "Controls",
      type = "Key",
      string_value = "Esc",
      label = "Escape",
      name = "Escape",
      default_key = "Escape",
   })
   db:from_table({
      class = "Setting",
      category = "Controls",
      type = "Key",
      string_value = "Journal",
      label = "Researches",
      name = "Journal",
      default_key = "J",
   })
   db:from_table({
      class = "Setting",
      category = "Controls",
      type = "Key",
      string_value = "Jump",
      label = "Jump",
      name = "Jump",
      default_key = "SpaceBar",
   })
   db:from_table({
      class = "Setting",
      category = "Controls",
      type = "Key",
      string_value = "LoadSettings",
      label = "LoadSettings",
      name = "LoadSettings",
      default_key = "Ctrl+V",
   })
   db:from_table({
      class = "Setting",
      category = "Controls",
      type = "Key",
      string_value = "NeiLeft",
      label = "NeiLeft",
      name = "NeiLeft",
      default_key = "Backspace",
   })
   db:from_table({
      class = "Setting",
      category = "Controls",
      type = "Key",
      string_value = "NeiRight",
      label = "NeiRight",
      name = "NeiRight",
      default_key = "Alt+Backspace",
   })
   db:from_table({
      class = "Setting",
      category = "Controls",
      type = "Key",
      string_value = "PickBlock",
      label = "PickBlock",
      name = "PickBlock",
      default_key = "Q",
   })
   db:from_table({
      class = "Setting",
      category = "Controls",
      type = "Key",
      string_value = "Recipe",
      label = "Recipe",
      name = "Recipe",
      default_key = "R",
   })
   db:from_table({
      class = "Setting",
      category = "Controls",
      type = "Key",
      string_value = "SaveSettings",
      label = "SaveSettings",
      name = "SaveSettings",
      default_key = "Ctrl+C",
   })
   db:from_table({
      class = "Setting",
      category = "Controls",
      type = "Key",
      string_value = "Sprint",
      label = "Sprint",
      name = "Sprint",
      default_key = "LeftShift",
   })
   db:from_table({
      class = "Setting",
      category = "Controls",
      type = "Key",
      string_value = "SwitchCreativeMode",
      label = "SwitchCreativeMode",
      name = "SwitchCreativeMode",
      default_key = "T",
   })
   db:from_table({
      class = "Setting",
      category = "Controls",
      type = "Key",
      string_value = "ThrowItem",
      label = "ThrowItem",
      name = "ThrowItem",
      default_key = "G",
   })
   db:from_table({
      class = "Setting",
      category = "Controls",
      type = "Key",
      string_value = "ToggleInventory",
      label = "ToggleInventory",
      name = "ToggleInventory",
      default_key = "E",
   })
   db:from_table({
      class = "Setting",
      category = "Controls",
      type = "Key",
      string_value = "ToggleMap",
      label = "ToggleMap",
      name = "ToggleMap",
      default_key = "M",
   })
   db:from_table({
      class = "Setting",
      category = "Controls",
      type = "Key",
      string_value = "ToggleReplaceMode",
      label = "ToggleReplaceMode",
      name = "ToggleReplaceMode",
      default_key = "Y",
   })
   db:from_table({
      class = "Setting",
      category = "Controls",
      type = "Key",
      string_value = "ToggleSideIcons",
      label = "ToggleSideIcons",
      name = "ToggleSideIcons",
      default_key = "X",
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

function vanilla_mod.post_init()
end

db:mod(vanilla_mod)
