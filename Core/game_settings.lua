function register_game_settings()
    db:from_table({
        class = "Setting",
        category = "Game",
        type = "String",
        default_string_value = "English",
        string_options = {"English", "Russian", "Portugese", "Spanish", "Hungarian", "Deutch", "Japanese", "Korean", "French", "Spanish", "Chinese"},
        action = function(setting)
            local loc = "en"
            if setting.string_value == "Russian" then loc = "en" end
            if setting.string_value == "Portugese" then loc = "pt-BR" end
            if setting.string_value == "Hungarian" then loc = "hu-HU" end
            if setting.string_value == "Deutch" then loc = "de" end
            if setting.string_value == "Japanese" then loc = "ja" end
            if setting.string_value == "Korean" then loc = "ko" end
            if setting.string_value == "French" then loc = "fr" end
            if setting.string_value == "Spanish" then loc = "es-ES" end
            if setting.string_value == "Chinese" then loc = "zh" end
            Game.set_localization(loc)
        end,
        label = "Localization",
        name = "Localization",
     })
end