return function()
    local function option4_to_int(string_value)
        local preset = 0
        if string_value == "Medium" then preset = 1 end
        if string_value == "High" then preset = 2 end
        if string_value == "Epic" then preset = 3 end
        return preset
    end

    db:from_table({
        class = "Setting",
        category = "Graphics",
        type = "Buttons",

        default_string_value = "High",
        string_options = {"Low", "Medium", "High", "Epic"},
        ---@param setting Setting
        set_action = function(setting)
            local scalability = option4_to_int(setting.string_value)

            local four_opts = {"ShadowQuality", "TextureQuality", "EffectsQuality", "PostProcessQuality"}
            for _, name in ipairs(four_opts) do
                local set = Setting.find(name)
                set.string_value = setting.string_value
                set:set_action()
            end

            local relf_values = {"Disable", "Disable", "ScreenSpace", "Lumen"}
            local set = Setting.find("GlobalIllumination")
            set.string_value = relf_values[scalability + 1]
            set:set_action()

            local relf_values = {"Disable", "ScreenSpace", "ScreenSpace", "Lumen"}
            local set = Setting.find("Reflection")
            set.string_value = relf_values[scalability + 1]
            set:set_action()

            local values = {0.3, 0.7, 1.0, 1.0}
            local set = Setting.find("GrassRenderingRange")
            set.int_value = math.floor(values[scalability + 1] * 100)
            set:set_action()

            values = {2, 5, 9, 10}
            local set = Setting.find("DecorationsQuality")
            set.int_value = math.floor(values[scalability + 1])
            set:set_action()

            local values = {"FXAA", "FXAA", "TAA", "TAA"}
            local set = Setting.find("AntiAliasingMethod")
            set.string_value = values[scalability + 1]
            set:set_action()

            local values = {"85%", "90%", "100%", "100%"}
            local set = Setting.find("ScreenPersentage")
            set.string_value = values[scalability + 1]
            set:set_action()

            Setting.update_widgets()
        end,

        label = "ScalabilityPreset",
        name = "ScalabilityPreset",
    })

    db:from_table({
        class = "Setting",
        category = "Graphics",
        type = "String",
        default_string_value = "1920x1080",
        string_options = Game.get_supported_resolutions(),
        ---@param setting Setting
        set_action = function(setting)
            local width, height = string.match(setting.string_value, "^(%d+)x(%d+)$")
            game.engine_data.res_x, game.engine_data.res_y = tonumber(width), tonumber(height)
            print("resolution set "..width.."x"..height)
            game.engine_data:apply()
        end,
        label = "Resolution",
        name = "Resolution",
    })

    db:from_table({
        class = "Setting",
        category = "Graphics",
        type = "String",
        default_string_value = "Fullscreen",
        string_options = {"Fullscreen", "WindowedFullscreen", "Windowed"},
        ---@param setting Setting
        set_action = function(setting)
           local function option3_to_int(string_value)
               local preset = 0
               if string_value == "WindowedFullscreen" then preset = 1 end
               if string_value == "Windowed" then preset = 2 end
               return preset
           end
           game.engine_data.window_mode = option3_to_int(setting.string_value)
           game.engine_data:apply()
        end,
        label = "Fullscreen",
        name = "Fullscreen",
    })

    local function generate_setting_on_off(name, command)
        db:from_table({
            class = "Setting",
            category = "Graphics",
            type = "String",
            default_string_value = "Off",
            string_options = {"Off", "On"},
            ---@param setting Setting
            set_action = function(setting)
                local value = (setting.string_value == "On") and 1 or 0
                Console.run(command.." "..value)
            end,
            label = name,
            name = name,
        })
    end

    generate_setting_on_off("HardwareRayTracing", "r.Lumen.HardwareRayTracing")

    local function generate_setting(name, command)
        db:from_table({
            class = "Setting",
            category = "Graphics",
            type = "String",
            default_string_value = "High",
            string_options = {"Low", "Medium", "High", "Epic"},
            ---@param setting Setting
            set_action = function(setting)
                Console.run(command.." "..option4_to_int(setting.string_value))
            end,
            label = name,
            name = name,
        })
    end

    generate_setting("ShadowQuality", "sg.ShadowQuality")
    generate_setting("TextureQuality", "sg.TextureQuality")
    generate_setting("EffectsQuality", "sg.EffectsQuality")
    generate_setting("PostProcessQuality", "sg.PostProcessQuality")

    local function generate_reflection(name, command, field)
        db:from_table({
            class = "Setting",
            category = "Graphics",
            type = "String",
            default_string_value = "ScreenSpace",
            string_options = {"Disable", "ScreenSpace", "Lumen"},
            ---@param setting Setting
            set_action = function(setting)
                local preset = 0
                if setting.string_value == "Lumen" then preset = 1 end
                if setting.string_value == "ScreenSpace" then preset = 2 end

                Console.run(command.." "..preset)

                game.engine_data[field] = preset
                game.engine_data:apply()
            end,
            label = name,
            name = name,
        })
    end
    generate_reflection("GlobalIllumination", "r.DynamicGlobalIlluminationMethod", "gi_preset")
    generate_reflection("Reflection", "r.ReflectionMethod", "reflection_preset")

    db:from_table({
        class = "Setting",
        category = "Graphics",
        type = "String",
        default_string_value = "100%",
        string_options = {"30%", "50%", "75%", "85%", "90%", "100%"},
        ---@param setting Setting
        set_action = function(setting)
            local preset = 90
            if setting.string_value == "30%" then preset = 30 end
            if setting.string_value == "50%" then preset = 50 end
            if setting.string_value == "75%" then preset = 75 end
            if setting.string_value == "85%" then preset = 85 end
            if setting.string_value == "90%" then preset = 90 end
            if setting.string_value == "100%" then preset = 100 end
            Console.run("r.ScreenPercentage "..preset)
        end,
        label = "ScreenPersentage",
        name = "ScreenPersentage",
    })

    db:from_table({
        class = "Setting",
        category = "Graphics",
        type = "String",
        default_string_value = "TAA",
        string_options = {"None", "FXAA", "TAA", "TSR"},
        set_action = function(setting)
            local preset = 2
            if setting.string_value == "None" then preset = 0 end
            if setting.string_value == "FXAA" then preset = 1 end
            if setting.string_value == "TSR" then preset = 4 end
            Console.run("r.AntiAliasingMethod "..preset)
        end,
        label = "AntiAliasingMethod",
        name = "AntiAliasingMethod",
    })

    db:from_table({
        class = "Setting",
        category = "Graphics",
        type = "Slider",
        max_value = 10,
        min_value = 1,
        int_default_value = 10,
        ---@param setting Setting
        set_action = function(setting)
           local value = setting.int_value / 10.0
           game.engine_data.props_quality = value
           print("set DecorationsQuality "..value)
           game.engine_data:apply()
        end,
        label = "DecorationsQuality",
        name = "DecorationsQuality",
    })

    local function generate_slider(name, variable)
        db:from_table({
            class = "Setting",
            category = "Graphics",
            type = "Slider",
            max_value = 100,
            min_value = 0,
            int_default_value = 100,
            ---@param setting Setting
            set_action = function(setting)
               local value = setting.int_value / 100.0
               game.engine_data[variable] = value
               print("set "..variable.." "..value)
               game.engine_data:apply()
            end,
            label = name,
            name = name,
        })
    end

    generate_slider("GrassRenderingRange", "props_mul")
    generate_slider("Fog", "fog")

    db:from_table({
        class = "Setting",
        category = "Graphics",
        type = "Slider",
        max_value = 100,
        min_value = 70,
        int_default_value = 80,
        ---@param setting Setting
        set_action = function(setting)
           local value = setting.int_value
           game.engine_data.fov = value
           print("set ".."Fov".." "..value)
           game.engine_data:apply()
        end,
        label = "Fov",
        name = "Fov",
    })

    db:from_table({
        class = "Setting",
        category = "Graphics",
        type = "String",
        default_string_value = "60",
        string_options = {"24", "30", "60", "120"},
        ---@param setting Setting
        set_action = function(setting)
           game.engine_data.fps = tonumber(setting.string_value)
           game.engine_data:apply()
        end,
        label = "MaxFps",
        name = "MaxFps",
    })

    generate_setting_on_off("VSync", "r.Vsync")

    --r.DynamicRes.OperationMode
    --r.AntiAliasingMethod
    --sg.AntiAliasingQuality
end