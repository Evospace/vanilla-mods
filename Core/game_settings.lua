return function()
    local LocalizationMap = {
        English   = "en",
        Russian   = "ru-RU",
        Portugese = "pt-BR",
        Hungarian = "hu-HU",
        Deutch    = "de-DE",
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
end