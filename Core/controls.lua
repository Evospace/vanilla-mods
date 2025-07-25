return function()

   db:from_table({
      class = "Setting",
      category = "Controls",
      type = "Slider",
      max_value = 200,
      min_value = 30,
      int_default_value = 100,
      ---@param setting Setting
      set_action = function(setting)
         local value = setting.int_value / 200.0
         game.engine_data.mouse_sensitivity_x = value
         print("set MouseSensitivityX "..value)
         game.engine_data:apply()
      end,
      label = "MouseSensitivityX",
      name = "MouseSensitivityX",
   })

   db:from_table({
      class = "Setting",
      category = "Controls",
      type = "Slider",
      max_value = 200,
      min_value = 30,
      int_default_value = 100,
      ---@param setting Setting
      set_action = function(setting)
         local value = setting.int_value / 200.0
         game.engine_data.mouse_sensitivity_y = value
         print("set MouseSensitivityY "..value)
         game.engine_data:apply()
      end,
      label = "MouseSensitivityY",
      name = "MouseSensitivityY",
   })

   db:from_table({
      class = "Setting",
      category = "Controls",
      type = "Bool",
      bool_default_value = false,
      ---@param setting Setting
      set_action = function(setting)
         local value = setting.bool_value
         game.engine_data.mouse_inversion_x = value
         print("set MouseInversionX "..tostring(value))
         game.engine_data:apply()
      end,
      label = "MouseInversionX",
      name = "MouseInversionX",
   })

   db:from_table({
      class = "Setting",
      category = "Controls",
      type = "Bool",
      bool_default_value = false,
      ---@param setting Setting
      set_action = function(setting)
         local value = setting.bool_value
         game.engine_data.mouse_inversion_y = value
         print("set MouseInversionY "..tostring(value))
         game.engine_data:apply()
      end,
      label = "MouseInversionY",
      name = "MouseInversionY",
   })

   db:from_table({
      class = "Setting",
      category = "Controls",
      type = "Key",
      key_binding = "MoveForward",
      label = "MoveForward",
      name = "MoveForward",
      int_default_value = 1,
      default_key = "W",
   })
   db:from_table({
      class = "Setting",
      category = "Controls",
      type = "Key",
      key_binding = "MoveForward",
      label = "MoveBack",
      name = "MoveBack",
      int_default_value = -1,
      default_key = "S",
   })
   db:from_table({
      class = "Setting",
      category = "Controls",
      type = "Key",
      key_binding = "MoveRight",
      label = "MoveRight",
      name = "MoveRight",
      int_default_value = 1,
      default_key = "D",
   })
   db:from_table({
      class = "Setting",
      category = "Controls",
      type = "Key",
      key_binding = "MoveRight",
      label = "MoveLeft",
      name = "MoveLeft",
      int_default_value = -1,
      default_key = "A",
   })
   db:from_table({
      class = "Setting",
      category = "Controls",
      type = "Key",
      key_binding = "VertOffset",
      label = "RaiseBlock",
      name = "RaiseBlock",
      int_default_value = 1,
      default_key = "MouseWheelAxis",
   })
   db:from_table({
      class = "Setting",
      category = "Controls",
      type = "Key",
      key_binding = "MoveUp",
      label = "MoveUp",
      name = "MoveUp",
      int_default_value = 1,
      default_key = "Spacebar",
   })
   db:from_table({
      class = "Setting",
      category = "Controls",
      type = "Key",
      key_binding = "MoveUp",
      label = "MoveDown",
      name = "MoveDown",
      int_default_value = -1,
      default_key = "LeftShift",
   })
   db:from_table({
      class = "Setting",
      category = "Controls",
      type = "Key",
      key_binding = "ActionRotate",
      label = "ActionRotate",
      name = "ActionRotate",
      default_key = "R",
   })
   db:from_table({
      class = "Setting",
      category = "Controls",
      type = "Key",
      key_binding = "ToggleInventory",
      label = "ToggleInventory",
      name = "ToggleInventory",
      default_key = "E",
   })
   db:from_table({
      class = "Setting",
      category = "Controls",
      type = "Key",
      key_binding = "BlockAction",
      label = "BlockAction",
      name = "BlockAction",
      default_key = "T",
   })
   db:from_table({
      class = "Setting",
      category = "Controls",
      type = "Key",
      key_binding = "Search",
      label = "Search",
      name = "Search",
      default_key = "Tab",
   })
   db:from_table({
      class = "Setting",
      category = "Controls",
      type = "Key",
      key_binding = "ChangeMovementMode",
      label = "ChangeMovementMode",
      name = "ChangeMovementMode",
      default_key = "F",
   })
   db:from_table({
      class = "Setting",
      category = "Controls",
      type = "Key",
      key_binding = "Crouch",
      label = "Crouch",
      name = "Crouch",
      default_key = "C",
   })
   db:from_table({
      class = "Setting",
      category = "Controls",
      type = "Key",
      key_binding = "EmptyHand",
      label = "EmptyHand",
      name = "EmptyHand",
      default_key = "None",
   })
   db:from_table({
      class = "Setting",
      category = "Controls",
      type = "Key",
      key_binding = "Esc",
      label = "Escape",
      name = "Escape",
      default_key = "Escape",
   })
   db:from_table({
      class = "Setting",
      category = "Controls",
      type = "Key",
      key_binding = "Journal",
      label = "Researches",
      name = "Journal",
      default_key = "J",
   })
   db:from_table({
      class = "Setting",
      category = "Controls",
      type = "Key",
      key_binding = "Jump",
      label = "Jump",
      name = "Jump",
      default_key = "SpaceBar",
   })
   db:from_table({
      class = "Setting",
      category = "Controls",
      type = "Key",
      key_binding = "LoadSettings",
      label = "LoadSettings",
      name = "LoadSettings",
      default_key = "Ctrl+V",
   })
   db:from_table({
      class = "Setting",
      category = "Controls",
      type = "Key",
      key_binding = "NeiLeft",
      label = "RecipesLeft",
      name = "RecipesLeft",
      default_key = "Backspace",
   })
   db:from_table({
      class = "Setting",
      category = "Controls",
      type = "Key",
      key_binding = "NeiRight",
      label = "RecipesRight",
      name = "RecipesRight",
      default_key = "Alt+Backspace",
   })
   db:from_table({
      class = "Setting",
      category = "Controls",
      type = "Key",
      key_binding = "PickBlock",
      label = "PickBlock",
      name = "PickBlock",
      default_key = "Q",
   })
   db:from_table({
      class = "Setting",
      category = "Controls",
      type = "Key",
      key_binding = "Recipe",
      label = "Recipe",
      name = "Recipe",
      default_key = "R",
   })
   db:from_table({
      class = "Setting",
      category = "Controls",
      type = "Key",
      key_binding = "SaveSettings",
      label = "SaveSettings",
      name = "SaveSettings",
      default_key = "Ctrl+C",
   })
   db:from_table({
      class = "Setting",
      category = "Controls",
      type = "Key",
      key_binding = "Sprint",
      label = "Sprint",
      name = "Sprint",
      default_key = "LeftShift",
   })
   db:from_table({
      class = "Setting",
      category = "Controls",
      type = "Key",
      key_binding = "SwitchCreativeMode",
      label = "SwitchCreativeMode",
      name = "SwitchCreativeMode",
      default_key = "Shift+F",
   })
   db:from_table({
      class = "Setting",
      category = "Controls",
      type = "Key",
      key_binding = "ThrowItem",
      label = "ThrowItem",
      name = "ThrowItem",
      default_key = "G",
   })
   db:from_table({
      class = "Setting",
      category = "Controls",
      type = "Key",
      key_binding = "ToggleMap",
      label = "ToggleMap",
      name = "ToggleMap",
      default_key = "M",
   })
   db:from_table({
      class = "Setting",
      category = "Controls",
      type = "Key",
      key_binding = "ToggleReplaceMode",
      label = "ToggleReplaceMode",
      name = "ToggleReplaceMode",
      default_key = "Y",
   })
   db:from_table({
      class = "Setting",
      category = "Controls",
      type = "Key",
      key_binding = "ToggleSideIcons",
      label = "ToggleSideIcons",
      name = "ToggleSideIcons",
      default_key = "X",
   })
   local nums = {"Zero","One","Two", "Three", "Four", "Five", "Six", "Seven", "Eight", "Nine"}
   for i=0,9 do
      db:from_table({
         class = "Setting",
         category = "Controls",
         type = "Key",
         key_binding = "ActiveSlot_"..i,
         label = "ActiveSlot_"..i,
         name = "ActiveSlot_"..i,
         default_key = nums[i+1],
      })
   end
end