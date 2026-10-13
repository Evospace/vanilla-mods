return function()
    Setting.reg("SectorLodCount", {
        category = "Game",
        type = "Slider",
        max = 2,
        min = 0,
        default = 2,
        ---@param setting Setting
        set_action = function(setting)
           local value = setting.value
           engine.sector_lod_count = value
           print_info("set SectorLodCount "..value)
           engine:apply()
        end,
        label = "SectorLodCount",
    })

    local LocalizationMap = {
        English   = "en",
        Russian   = "ru-RU",
        Portugese = "pt-BR",
        Hungarian = "hu-HU",
        German    = "de-DE",
        Polish    = "pl-PL",
        Japanese  = "ja-JP",
        Korean    = "ko-KR",
        French    = "fr-FR",
        Spanish   = "es-ES",
        Chinese   = "zh-CN",
    }

    local LocArray = {}
    local index = 1
    for name, _ in pairs(LocalizationMap) do
        LocArray[index] = name
        index = index + 1
    end

    local function get_select(value)
        return LocalizationMap[value] or "en"
    end
    
    Setting.reg("Localization", {
        category = "Game",
        type = "String",
        default = "English",
        options = LocArray,
        ---@param setting Setting
        set_action = function(setting)
            local loc = get_select(setting.value)
            print_info("localization set "..setting.value)
            game.localization = loc
        end,
        label = "Localization",
    })

    Setting.reg("Dpi", {
       category = "Game",
       type = "Slider",
       max = 200,
       min = 50,
       default = 100,
       ---@param setting Setting
       set_action = function(setting)
          local value = setting.value / 100.0
          engine.dpi = value
          print_info("set Dpi "..value)
          engine:apply()
       end,
       label = "Dpi",
    })

    local function make_bool_set(name, field)
        Setting.reg(name, {
            category = "Game",
            type = "String",
            default = "Off",
            options = {"Off", "On"},
            ---@param setting Setting
            set_action = function(setting)
                local value = setting.value == "On"
                print_info("set "..name.." "..tostring(value))
                engine[field] = value
                engine:apply()
            end,
            label = name,
        })
    end

    local function make_bool_set_on(name, field)
        Setting.reg(name, {
            category = "Game",
            type = "String",
            default = "On",
            options = {"Off", "On"},
            ---@param setting Setting
            set_action = function(setting)
                local value = setting.value == "On"
                print_info("set "..name.." "..tostring(value))
                engine[field] = value
                engine:apply()
            end,
            label = name,
        })
    end

    make_bool_set("Performance", "performance")
    make_bool_set("PerformanceGraph", "performance_graph")
    make_bool_set("MemoryStats", "memory_stats")
    make_bool_set_on("Compass", "compass")
    make_bool_set_on("CompassShowNearestOre", "compass_show_nearest_ore")
    make_bool_set_on("CompassShowSpawnPoint", "compass_show_spawn_point")
    make_bool_set_on("QuestTracker", "quest_tracker")
    make_bool_set_on("ToolHints", "tool_hints")
    make_bool_set("CtrlHotbar", "ctrl_hotbar")
    make_bool_set("AltHotbar", "alt_hotbar")
    make_bool_set("ShiftHotbar", "shift_hotbar")

    Setting.reg("AutosavePeriod", {
        category = "Game",
        type = "Slider",
        max = 60,
        min = 0,
        default = 10,
        ---@param setting Setting
        set_action = function(setting)
           local value = setting.value
           engine.autosave_period = value
           print_info("set AutosavePeriod "..value)
           engine:apply()
        end,
        label = "AutosavePeriod",
     })

    Setting.reg("UndoConfirmMinutes", {
        category = "Game",
        type = "Slider",
        max = 5,
        min = 0,
        default = 1,
        ---@param setting Setting
        set_action = function(setting)
           local value = setting.value
           engine.undo_confirm_minutes = value
           print_info("set UndoConfirmMinutes "..value)
        end,
        label = "UndoConfirmMinutes",
     })

end