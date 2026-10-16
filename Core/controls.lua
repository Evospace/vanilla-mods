return function()

   Setting.reg("MouseSensitivityX", {
      category = "Controls",
      type = "Slider",
      max = 200,
      min = 30,
      default = 100,
      ---@param setting Setting
      set_action = function(setting)
         local value = setting.value / 100.0
         engine.mouse_sensitivity_x = value
         print_info("set MouseSensitivityX "..value)
         engine:apply()
      end,
      label = "MouseSensitivityX",
   })

   Setting.reg("MouseSensitivityY", {
      category = "Controls",
      type = "Slider",
      max = 200,
      min = 30,
      default = 100,
      ---@param setting Setting
      set_action = function(setting)
         local value = setting.value / 100.0
         engine.mouse_sensitivity_y = value
         print_info("set MouseSensitivityY "..value)
         engine:apply()
      end,
      label = "MouseSensitivityY",
   })

   Setting.reg("MouseInversionX", {
      category = "Controls",
      type = "Bool",
      default = false,
      ---@param setting Setting
      set_action = function(setting)
         local value = setting.value
         engine.mouse_inversion_x = value
         print_info("set MouseInversionX "..tostring(value))
         engine:apply()
      end,
      label = "MouseInversionX",
   })

   Setting.reg("MouseInversionY", {
      category = "Controls",
      type = "Bool",
      default = false,
      ---@param setting Setting
      set_action = function(setting)
         local value = setting.value
         engine.mouse_inversion_y = value
         print_info("set MouseInversionY "..tostring(value))
         engine:apply()
      end,
      label = "MouseInversionY",
   })

   Setting.reg("MoveForward", {
      category = "Controls",
      type = "Key",
      key_binding = "Move",
      label = "MoveForward",
      default_key = "W",
   })
   Setting.reg("MoveBack", {
      category = "Controls",
      type = "Key",
      key_binding = "Move",
      label = "MoveBack",
      default_key = "S",
   })
   Setting.reg("MoveRight", {
      category = "Controls",
      type = "Key",
      key_binding = "Move",
      label = "MoveRight",
      default_key = "D",
   })
   Setting.reg("MoveLeft", {
      category = "Controls",
      type = "Key",
      key_binding = "Move",
      label = "MoveLeft",
      default_key = "A",
   })
   Setting.reg("RaiseBlock", {
      category = "Controls",
      type = "Key",
      key_binding = "VertOffset",
      label = "RaiseBlock",
      default_key = "MouseWheelAxis",
   })
   Setting.reg("MoveUp", {
      category = "Controls",
      type = "Key",
      key_binding = "MoveUp",
      label = "MoveUp",
      default_key = "Spacebar",
   })
   Setting.reg("MoveDown", {
      category = "Controls",
      type = "Key",
      key_binding = "MoveUp",
      label = "MoveDown",
      default_key = "C",
   })
   Setting.reg("ActionRotate", {
      category = "Controls",
      type = "Key",
      key_binding = "ActionRotate",
      label = "ActionRotate",
      default_key = "R",
   })
   Setting.reg("ToggleInventory", {
      category = "Controls",
      type = "Key",
      key_binding = "ToggleInventory",
      label = "ToggleInventory",
      default_key = "E",
   })
   Setting.reg("BlockAction", {
      category = "Controls",
      type = "Key",
      key_binding = "BlockAction",
      label = "BlockAction",
      default_key = "T",
   })
   Setting.reg("BlockUp", {
      category = "Controls",
      type = "Key",
      key_binding = "BlockUp",
      label = "BlockUp",
      default_key = "Up",
   })
   Setting.reg("BlockDown", {
      category = "Controls",
      type = "Key",
      key_binding = "BlockDown",
      label = "BlockDown",
      default_key = "Down",
   })
   
   Setting.reg("ChangeMovementMode", {
      category = "Controls",
      type = "Key",
      key_binding = "ChangeMovementMode",
      label = "ChangeMovementMode",
      default_key = "F",
   })
   Setting.reg("Chat", {
      category = "Controls",
      type = "Key",
      key_binding = "Chat",
      label = "Chat",
      default_key = "Enter",
   })
   Setting.reg("Console", {
      category = "Controls",
      type = "Key",
      key_binding = "Console",
      label = "Console",
      default_key = "Slash",
   })
   Setting.reg("Crouch", {
      category = "Controls",
      type = "Key",
      key_binding = "Crouch",
      label = "Crouch",
      default_key = "C",
   })
   Setting.reg("EmptyHand", {
      category = "Controls",
      type = "Key",
      key_binding = "EmptyHand",
      label = "EmptyHand",
      default_key = "Alt+Q",
   })
   Setting.reg("Escape", {
      category = "Controls",
      type = "Key",
      key_binding = "Escape",
      label = "Escape",
      default_key = "Escape",
   })
   Setting.reg("Journal", {
      category = "Controls",
      type = "Key",
      key_binding = "Journal",
      label = "Researches",
      default_key = "J",
   })
   Setting.reg("QuestBook", {
      category = "Controls",
      type = "Key",
      key_binding = "QuestBook",
      label = "QuestBook",
      default_key = "B",
   })
   Setting.reg("Blueprints", {
      category = "Controls",
      type = "Key",
      key_binding = "Blueprints",
      label = "Blueprints",
      default_key = "N",
   })
   Setting.reg("Trains", {
      category = "Controls",
      type = "Key",
      key_binding = "Trains",
      label = "Trains",
      default_key = "K",
   })
   Setting.reg("Production", {
      category = "Controls",
      type = "Key",
      key_binding = "Production",
      label = "Production",
      default_key = "P",
   })
   Setting.reg("Decor", {
      category = "Controls",
      type = "Key",
      key_binding = "Decor",
      label = "Decor",
      default_key = "V",
   })
   Setting.reg("Jump", {
      category = "Controls",
      type = "Key",
      key_binding = "Jump",
      label = "Jump",
      default_key = "SpaceBar",
   })
   Setting.reg("LoadSettings", {
      category = "Controls",
      type = "Key",
      key_binding = "LoadSettings",
      label = "LoadSettings",
      default_key = "Ctrl+V",
   })
   Setting.reg("RecipesLeft", {
      category = "Controls",
      type = "Key",
      key_binding = "NeiLeft",
      label = "RecipesLeft",
      default_key = "Backspace",
   })
   Setting.reg("RecipesRight", {
      category = "Controls",
      type = "Key",
      key_binding = "NeiRight",
      label = "RecipesRight",
      default_key = "Alt+Backspace",
   })
   Setting.reg("PickBlock", {
      category = "Controls",
      type = "Key",
      key_binding = "PickBlock",
      label = "PickBlock",
      default_key = "Q",
   })
   Setting.reg("Recipe", {
      category = "Controls",
      type = "Key",
      key_binding = "Recipe",
      label = "Recipe",
      default_key = "U",
   })
   Setting.reg("SaveSettings", {
      category = "Controls",
      type = "Key",
      key_binding = "SaveSettings",
      label = "SaveSettings",
      default_key = "Ctrl+C",
   })
   Setting.reg("Sprint", {
      category = "Controls",
      type = "Key",
      key_binding = "Sprint",
      label = "Sprint",
      default_key = "LeftShift",
   })
   Setting.reg("SwitchCreativeMode", {
      category = "Controls",
      type = "Key",
      key_binding = "SwitchCreativeMode",
      label = "SwitchCreativeMode",
      default_key = "Shift+F",
   })
   Setting.reg("ThrowItem", {
      category = "Controls",
      type = "Key",
      key_binding = "ThrowItem",
      label = "ThrowItem",
      default_key = "G",
   })
   Setting.reg("ToggleMap", {
      category = "Controls",
      type = "Key",
      key_binding = "ToggleMap",
      label = "ToggleMap",
      default_key = "M",
   })
   Setting.reg("ToggleReplaceMode", {
      category = "Controls",
      type = "Key",
      key_binding = "ToggleReplaceMode",
      label = "ToggleReplaceMode",
      default_key = "Y",
   })
   Setting.reg("ToggleFoundation", {
      category = "Controls",
      type = "Key",
      key_binding = "ToggleFoundation",
      label = "ToggleFoundation",
      default_key = "H",
   })
   Setting.reg("Undo", {
      category = "Controls",
      type = "Key",
      key_binding = "Undo",
      label = "Undo",
      default_key = "Ctrl+Z",
   })
   Setting.reg("Redo", {
      category = "Controls",
      type = "Key",
      key_binding = "Redo",
      label = "Redo",
      default_key = "Ctrl+Y",
   })
   Setting.reg("ToggleSideIcons", {
      category = "Controls",
      type = "Key",
      key_binding = "ToggleSideIcons",
      label = "ToggleSideIcons",
      default_key = "X",
   })
   Setting.reg("ToggleHud", {
      category = "Controls",
      type = "Key",
      key_binding = "ToggleHud",
      label = "ToggleHud",
      default_key = "Period",
   })
   Setting.reg("ToggleFlashlight", {
      category = "Controls",
      type = "Key",
      key_binding = "ToggleFlashlight",
      label = "ToggleFlashlight",
      default_key = "L",
   })
   Setting.reg("Ping", {
      category = "Controls",
      type = "Key",
      key_binding = "Ping",
      label = "Ping",
      default_key = "Z",
   })
   Setting.reg("SelectToolMultitool", {
      category = "Controls",
      type = "Key",
      key_binding = "SelectToolMultitool",
      label = "SelectToolMultitool",
      default_key = "Alt+Z",
   })
   Setting.reg("SelectToolScrewdriver", {
      category = "Controls",
      type = "Key",
      key_binding = "SelectToolScrewdriver",
      label = "SelectToolScrewdriver",
      default_key = "Alt+X",
   })
   Setting.reg("SelectToolGroundLevelingTool", {
      category = "Controls",
      type = "Key",
      key_binding = "SelectToolGroundLevelingTool",
      label = "SelectToolGroundLevelingTool",
      default_key = "Alt+V",
   })
   Setting.reg("VehicleForward", {
      category = "Controls",
      type = "Key",
      key_binding = "VehicleThrottle",
      label = "VehicleForward",
      default_key = "W",
   })
   Setting.reg("VehicleBack", {
      category = "Controls",
      type = "Key",
      key_binding = "VehicleThrottle",
      label = "VehicleBack",
      default_key = "S",
   })
   Setting.reg("VehicleRight", {
      category = "Controls",
      type = "Key",
      key_binding = "VehicleSteer",
      label = "VehicleRight",
      default_key = "D",
   })
   Setting.reg("VehicleLeft", {
      category = "Controls",
      type = "Key",
      key_binding = "VehicleSteer",
      label = "VehicleLeft",
      default_key = "A",
   })
   Setting.reg("VehicleHandbrake", {
      category = "Controls",
      type = "Key",
      key_binding = "VehicleHandbrake",
      label = "VehicleHandbrake",
      default_key = "SpaceBar",
   })
   Setting.reg("VehicleExit", {
      category = "Controls",
      type = "Key",
      key_binding = "VehicleExit",
      label = "VehicleExit",
      default_key = "T",
   })
   local nums = {"Zero","One","Two", "Three", "Four", "Five", "Six", "Seven", "Eight", "Nine"}
   for i=0,9 do
      Setting.reg("ActiveSlot_"..i, {
         category = "Controls",
         type = "Key",
         key_binding = "ActiveSlot"..i,
         label = "ActiveSlot_"..i,
         default_key = nums[i+1],
      })
   end
end