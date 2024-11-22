function register_controls()
    db:from_table({
       class = "Setting",
       category = "Controls",
       type = "Key",
       key_binding = "ActionPrimary",
       label = "ActionPrimary",
       name = "ActionPrimary",
       default_key = "LeftMouseButton",
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
       key_binding = "ActionSecondary",
       label = "ActionSecondary",
       name = "ActionSecondary",
       default_key = "RightMouseButton",
    })
    db:from_table({
       class = "Setting",
       category = "Controls",
       type = "Key",
       key_binding = "ActionTertiary",
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
          key_binding = "ActiveSlot_"..i,
          label = "ActiveSlot_"..i,
          name = "ActiveSlot_"..i,
          default_key = nums[i+1],
       })
    end
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
       label = "NeiLeft",
       name = "NeiLeft",
       default_key = "Backspace",
    })
    db:from_table({
       class = "Setting",
       category = "Controls",
       type = "Key",
       key_binding = "NeiRight",
       label = "NeiRight",
       name = "NeiRight",
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
       default_key = "T",
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
       key_binding = "ToggleInventory",
       label = "ToggleInventory",
       name = "ToggleInventory",
       default_key = "E",
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
 end