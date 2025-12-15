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

            local relf_values = {"Low", "Medium", "High", "High"}
            local set = Setting.find("MaterialQuality")
            set.string_value = relf_values[scalability + 1]
            set:set_action()

            local values = {0.3, 0.7, 1.0, 1.0}
            local set = Setting.find("GrassRenderingRange")
            set.int_value = math.floor(values[scalability + 1] * 100)
            set:set_action()

            local values = {2, 5, 9, 10}
            local set = Setting.find("DecorationsQuality")
            set.int_value = math.floor(values[scalability + 1])
            set:set_action()

            local values = {"FXAA", "FXAA", "TAA", "TAA"}
            local set = Setting.find("AntiAliasingMethod")
            set.string_value = values[scalability + 1]
            set:set_action()

            local values = {"100%", "100%", "100%", "100%"}
            local set = Setting.find("ScreenPersentage")
            set.string_value = values[scalability + 1]
            set:set_action()

            local detail = Setting.find("DetailShadows")
            if scalability <= 1 then
                detail.string_value = "Off"
            else
                detail.string_value = "On"
            end
            detail:set_action()

            local values = {"Low", "Medium", "High", "High"}
            local transparency = Setting.find("Transparency")
            transparency.string_value = values[scalability + 1]
            transparency:set_action()

            local clouds = Setting.find("CloudsQuality")
            if scalability == 0 then
                clouds.string_value = "Off"
            elseif scalability == 1 then
                clouds.string_value = "Simple"
            else
                clouds.string_value = "Volumteric"
            end
            clouds:set_action()

            Setting.update_widgets()
        end,

        label = "ScalabilityPreset",
        name = "ScalabilityPreset",
    })

    db:from_table({
        class = "Setting",
        category = "Graphics",
        type = "String",
        default_string_value = "Simple",
        string_options = {"Off", "Simple", "Volumteric"},
        ---@param setting Setting
        set_action = function(setting)
           local function option3_to_int(string_value)
               local preset = 0
               if string_value == "Simple" then preset = 1 end
               if string_value == "Volumteric" then preset = 2 end
               return preset
           end
           engine.cloud_preset = option3_to_int(setting.string_value)
           engine:apply()
        end,
        label = "CloudsQuality",
        name = "CloudsQuality",
    })

    db:from_table({
        class = "Setting",
        category = "Graphics",
        type = "String",
        default_string_value = "High",
        string_options = {"Off", "On"},
        ---@param setting Setting
        set_action = function(setting)
            local enabled = (setting.string_value == "On")
            engine.enable_rain = enabled
            engine:apply()
        end,
        label = "Rain",
        name = "Rain",
    })

    db:from_table({
        class = "Setting",
        category = "Graphics",
        type = "String",
        default_string_value = "On",
        string_options = {"Off", "On"},
        ---@param setting Setting
        set_action = function(setting)
            local enabled = (setting.string_value == "On")
            engine.detail_shadows = enabled
            engine:apply()
        end,
        label = "DetailShadows",
        name = "DetailShadows",
    })

    db:from_table({
        class = "Setting",
        category = "Graphics",
        type = "String",
        default_string_value = "Windowed",
        string_options = {"Fullscreen", "WindowedFullscreen", "Windowed"},
        ---@param setting Setting
        set_action = function(setting)
           local function option3_to_int(string_value)
               local preset = 0
               if string_value == "WindowedFullscreen" then preset = 1 end
               if string_value == "Windowed" then preset = 2 end
               return preset
           end
           engine.window_mode = option3_to_int(setting.string_value)
           engine:show_confirmation()
           engine:apply()
        end,
        label = "Fullscreen",
        name = "Fullscreen",
    })

    db:from_table({
        class = "Setting",
        category = "Graphics",
        type = "String",
        default_string_value = "800x600",
        string_options = Game.get_supported_resolutions(),
        ---@param setting Setting
        set_action = function(setting)
            local width, height = string.match(setting.string_value, "^(%d+)x(%d+)$")
            engine.res_x, engine.res_y = tonumber(width), tonumber(height)
            print("resolution set "..width.."x"..height)
            engine:show_confirmation()
            engine:apply()
        end,
        label = "Resolution",
        name = "Resolution",
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

    db:from_table({
        class = "Setting",
        category = "Graphics",
        type = "String",
        default_string_value = "High",
        string_options = {"Low", "Medium", "High"},
        ---@param setting Setting
        set_action = function(setting)
            engine.transparency_preset = option4_to_int(setting.string_value)
        end,
        label = "Transparency",
        name = "Transparency",
    })

    db:from_table({
        class = "Setting",
        category = "Graphics",
        type = "String",
        default_string_value = "High",
        string_options = {"Low", "Medium", "High"},
        ---@param setting Setting
        set_action = function(setting)
            local preset = 0
            if setting.string_value == "Low" then preset = 0 end
            if setting.string_value == "Medium" then preset = 2 end
            if setting.string_value == "High" then preset = 1 end

            Console.run("R.MaterialQualityLevel "..preset)
        end,
        label = "MaterialQuality",
        name = "MaterialQuality",
    })

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

                engine[field] = preset
                engine:apply()
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
           engine.props_quality = value
           print("set DecorationsQuality "..value)
           engine:apply()
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
               engine[variable] = value
               print("set "..variable.." "..value)
               engine:apply()
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
           engine.fov = value
           print("set ".."Fov".." "..value)
           engine:apply()
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
           engine.fps = tonumber(setting.string_value)
           engine:apply()
        end,
        label = "MaxFps",
        name = "MaxFps",
    })

    generate_setting_on_off("VSync", "r.Vsync")

    --r.DynamicRes.OperationMode
    --r.AntiAliasingMethod
    --sg.AntiAliasingQuality
end