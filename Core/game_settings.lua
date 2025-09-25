return function()
    db:from_table({
        class = "Setting",
        category = "Game",
        type = "Slider",
        max_value = 25,
        min_value = 6,
        int_default_value = 12,
        ---@param setting Setting
        set_action = function(setting)
           local value = setting.int_value
           game.engine_data.loading_range = value
           print("set LoadingRange "..value)
           game.engine_data:apply()
        end,
        label = "LoadingRange",
        name = "LoadingRange",
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
    
    db:from_table({
        class = "Setting",
        category = "Game",
        type = "String",
        default_string_value = "English",
        string_options = LocArray,
        ---@param setting Setting
        set_action = function(setting)
            local loc = get_select(setting.string_value)
            print("localization set "..setting.string_value)
            game.localization = loc
        end,
        label = "Localization",
        name = "Localization",
    })

    db:from_table({
       class = "Setting",
       category = "Game",
       type = "Slider",
       max_value = 200,
       min_value = 50,
       int_default_value = 100,
       ---@param setting Setting
       set_action = function(setting)
          local value = setting.int_value / 100.0
          game.engine_data.dpi = value
          print("set Dpi "..value)
          game.engine_data:apply()
       end,
       label = "Dpi",
       name = "Dpi",
    })

    local function make_bool_set(name, field)
        db:from_table({
            class = "Setting",
            category = "Game",
            type = "String",
            default_string_value = "Off",
            string_options = {"Off", "On"},
            ---@param setting Setting
            set_action = function(setting)
                local value = setting.string_value == "On"
                print("set "..name.." "..tostring(value))
                game.engine_data[field] = value
                game.engine_data:apply()
            end,
            label = name,
            name = name,
        })
    end

    make_bool_set("Performance", "performance")
    make_bool_set("PerformanceGraph", "performance_graph")
    make_bool_set("CtrlHotbar", "ctrl_hotbar")
    make_bool_set("AltHotbar", "alt_hotbar")
    make_bool_set("ShiftHotbar", "shift_hotbar")

    db:from_table({
        class = "Setting",
        category = "Game",
        type = "Slider",
        max_value = 60,
        min_value = 0,
        int_default_value = 10,
        ---@param setting Setting
        set_action = function(setting)
           local value = setting.int_value
           game.engine_data.autosave_period = value
           print("set AutosavePeriod "..value)
           game.engine_data:apply()
        end,
        label = "AutosavePeriod",
        name = "AutosavePeriod",
     })

end