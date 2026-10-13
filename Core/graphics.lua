return function()
    local function option4_to_int(value)
        local preset = 0
        if value == "Medium" then preset = 1 end
        if value == "High" then preset = 2 end
        if value == "Epic" then preset = 3 end
        return preset
    end

    Setting.reg("ScalabilityPreset", {
        category = "Graphics",
        type = "Buttons",

        default = "High",
        options = {"Low", "Medium", "High", "Epic"},
        ---@param setting Setting
        set_action = function(setting)
            local scalability = option4_to_int(setting.value)

            local four_opts = {"ShadowQuality", "TextureQuality", "EffectsQuality", "PostProcessQuality"}
            for _, name in ipairs(four_opts) do
                local set = Setting.find(name)
                set.value = setting.value
                set:set_action()
            end

            local relf_values = {"Disable", "Disable", "ScreenSpace", "Lumen"}
            local set = Setting.find("GlobalIllumination")
            set.value = relf_values[scalability + 1]
            set:set_action()

            local relf_values = {"Disable", "ScreenSpace", "ScreenSpace", "Lumen"}
            local set = Setting.find("Reflection")
            set.value = relf_values[scalability + 1]
            set:set_action()

            local relf_values = {"Low", "Low", "High", "High"}
            local set = Setting.find("ReflectionQuality")
            set.value = relf_values[scalability + 1]
            set:set_action()

            local relf_values = {"Low", "Medium", "High", "High"}
            local set = Setting.find("MaterialQuality")
            set.value = relf_values[scalability + 1]
            set:set_action()

            local values = {0.3, 0.7, 1.0, 1.0}
            local set = Setting.find("GrassRenderingRange")
            set.value = math.floor(values[scalability + 1] * 100)
            set:set_action()

            local values = {2, 5, 9, 10}
            local set = Setting.find("DecorationsQuality")
            set.value = math.floor(values[scalability + 1])
            set:set_action()

            local values = {15, 18, 25, 27}
            local set = Setting.find("LoadingRange")
            set.value = values[scalability + 1]
            set:set_action()

            local values = {"FXAA", "FXAA", "TAA", "TAA"}
            local set = Setting.find("AntiAliasingMethod")
            set.value = values[scalability + 1]
            set:set_action()

            local values = {"100%", "100%", "100%", "100%"}
            local set = Setting.find("ScreenPersentage")
            set.value = values[scalability + 1]
            set:set_action()

            local detail = Setting.find("DetailShadows")
            if scalability <= 1 then
                detail.value = "Off"
            else
                detail.value = "On"
            end
            detail:set_action()

            local spotlight = Setting.find("SpotlightShadows")
            if scalability <= 1 then
                spotlight.value = "Off"
            else
                spotlight.value = "On"
            end
            spotlight:set_action()

            local values = {"Low", "Medium", "High", "High"}
            local transparency = Setting.find("Transparency")
            transparency.value = values[scalability + 1]
            transparency:set_action()

            local clouds = Setting.find("CloudsQuality")
            if scalability == 0 then
                clouds.value = "Off"
            elseif scalability == 1 then
                clouds.value = "Simple"
            else
                clouds.value = "Volumteric"
            end
            clouds:set_action()

            local values = {"Off", "Minimal", "Full", "Full"}
            local wind = Setting.find("WindAnimation")
            wind.value = values[scalability + 1]
            wind:set_action()

            local values = {"Low", "High", "High", "High"}
            local particles = Setting.find("WeatherParticles")
            particles.value = values[scalability + 1]
            particles:set_action()

            local values = {"Low", "Medium", "High", "High"}
            local vram = Setting.find("VramBudget")
            vram.value = values[scalability + 1]
            vram:set_action()

            Setting.update_widgets()
        end,

        label = "ScalabilityPreset",
    })

    Setting.reg("CloudsQuality", {
        category = "Graphics",
        type = "String",
        default = "Simple",
        options = {"Off", "Simple", "Volumteric"},
        ---@param setting Setting
        set_action = function(setting)
           local function option3_to_int(value)
               local preset = 0
               if value == "Simple" then preset = 1 end
               if value == "Volumteric" then preset = 2 end
               return preset
           end
           engine.cloud_preset = option3_to_int(setting.value)
           engine:apply()
        end,
        label = "CloudsQuality",
    })

    Setting.reg("WeatherParticles", {
        category = "Graphics",
        type = "String",
        default = "High",
        options = {"Off", "Low", "High"},
        ---@param setting Setting
        set_action = function(setting)
            local preset = 0
            if setting.value == "Low" then preset = 1 end
            if setting.value == "High" then preset = 2 end
            engine.weather_particles = preset
            engine:apply()
        end,
        label = "WeatherParticles",
    })

    Setting.reg("WindAnimation", {
        category = "Graphics",
        type = "String",
        default = "Full",
        options = {"Off", "Minimal", "Full"},
        ---@param setting Setting
        set_action = function(setting)
            local value = 1.0
            if setting.value == "Off" then value = 0.0 end
            if setting.value == "Minimal" then value = 0.25 end
            engine.wind_animation = value
            engine:apply()
        end,
        label = "WindAnimation",
    })

    Setting.reg("DetailShadows", {
        category = "Graphics",
        type = "String",
        default = "On",
        options = {"Off", "On"},
        ---@param setting Setting
        set_action = function(setting)
            local enabled = (setting.value == "On")
            engine.detail_shadows = enabled
            engine:apply()
        end,
        label = "DetailShadows",
    })

    Setting.reg("SpotlightShadows", {
        category = "Graphics",
        type = "String",
        default = "On",
        options = {"Off", "On"},
        ---@param setting Setting
        set_action = function(setting)
            local enabled = (setting.value == "On")
            engine.spotlight_shadows = enabled
            engine:apply()
        end,
        label = "SpotlightShadows",
    })

    Setting.reg("Fullscreen", {
        category = "Graphics",
        type = "String",
        default = "Windowed",
        options = {"Fullscreen", "WindowedFullscreen", "Windowed"},
        ---@param setting Setting
        set_action = function(setting)
           local function option3_to_int(value)
               local preset = 0
               if value == "WindowedFullscreen" then preset = 1 end
               if value == "Windowed" then preset = 2 end
               return preset
           end
           engine.window_mode = option3_to_int(setting.value)
           engine:show_confirmation()
           engine:apply()
        end,
        label = "Fullscreen",
    })

    Setting.reg("Resolution", {
        category = "Graphics",
        type = "String",
        default = "800x600",
        options = Game.get_supported_resolutions(),
        ---@param setting Setting
        set_action = function(setting)
            local width, height = string.match(setting.value, "^(%d+)x(%d+)$")
            engine.res_x, engine.res_y = tonumber(width), tonumber(height)
            print_info("resolution set "..width.."x"..height)
            engine:show_confirmation()
            engine:apply()
        end,
        label = "Resolution",
    })

    local function generate_setting_on_off(name, command)
        Setting.reg(name, {
            category = "Graphics",
            type = "String",
            default = "Off",
            options = {"Off", "On"},
            ---@param setting Setting
            set_action = function(setting)
                local value = (setting.value == "On") and 1 or 0
                Console.run(command.." "..value)
            end,
            label = name,
        })
    end

    local function generate_setting(name, command)
        Setting.reg(name, {
            category = "Graphics",
            type = "String",
            default = "High",
            options = {"Low", "Medium", "High", "Epic"},
            ---@param setting Setting
            set_action = function(setting)
                Console.run(command.." "..option4_to_int(setting.value))
            end,
            label = name,
        })
    end

    generate_setting("ShadowQuality", "sg.ShadowQuality")
    generate_setting("TextureQuality", "sg.TextureQuality")
    generate_setting("EffectsQuality", "sg.EffectsQuality")
    generate_setting("PostProcessQuality", "sg.PostProcessQuality")

    Setting.reg("Transparency", {
        category = "Graphics",
        type = "String",
        default = "High",
        options = {"Low", "Medium", "High"},
        ---@param setting Setting
        set_action = function(setting)
            engine.transparency_preset = option4_to_int(setting.value)
        end,
        label = "Transparency",
    })

    Setting.reg("MaterialQuality", {
        category = "Graphics",
        type = "String",
        default = "High",
        options = {"Low", "Medium", "High"},
        ---@param setting Setting
        set_action = function(setting)
            local preset = 0
            if setting.value == "Low" then preset = 0 end
            if setting.value == "Medium" then preset = 2 end
            if setting.value == "High" then preset = 1 end

            Console.run("R.MaterialQualityLevel "..preset)
        end,
        label = "MaterialQuality",
    })

    local function generate_reflection(name, command, field)
        Setting.reg(name, {
            category = "Graphics",
            type = "String",
            default = "ScreenSpace",
            options = {"Disable", "ScreenSpace", "Lumen"},
            ---@param setting Setting
            set_action = function(setting)
                local preset = 0
                if setting.value == "Lumen" then preset = 1 end
                if setting.value == "ScreenSpace" then preset = 2 end

                Console.run(command.." "..preset)

                engine[field] = preset
                engine:apply()
            end,
            label = name,
        })
    end
    generate_reflection("GlobalIllumination", "r.DynamicGlobalIlluminationMethod", "gi_preset")
    generate_reflection("Reflection", "r.ReflectionMethod", "reflection_preset")

    Setting.reg("ReflectionQuality", {
        category = "Graphics",
        type = "String",
        default = "High",
        options = {"Low", "High"},
        ---@param setting Setting
        set_action = function(setting)
            local preset = 3
            if setting.value == "Low" then preset = 1 end

            Console.run("r.SSR.Quality "..preset)
        end,
        label = "ReflectionQuality",
    })

    Setting.reg("ScreenPersentage", {
        category = "Graphics",
        type = "String",
        default = "100%",
        options = {"30%", "50%", "75%", "85%", "90%", "100%"},
        ---@param setting Setting
        set_action = function(setting)
            local preset = 90
            if setting.value == "30%" then preset = 30 end
            if setting.value == "50%" then preset = 50 end
            if setting.value == "75%" then preset = 75 end
            if setting.value == "85%" then preset = 85 end
            if setting.value == "90%" then preset = 90 end
            if setting.value == "100%" then preset = 100 end
            Console.run("r.ScreenPercentage "..preset)
        end,
        label = "ScreenPersentage",
    })

    Setting.reg("AntiAliasingMethod", {
        category = "Graphics",
        type = "String",
        default = "TAA",
        options = {"None", "FXAA", "TAA", "TSR"},
        set_action = function(setting)
            local preset = 2
            if setting.value == "None" then preset = 0 end
            if setting.value == "FXAA" then preset = 1 end
            if setting.value == "TSR" then preset = 4 end
            Console.run("r.AntiAliasingMethod "..preset)
        end,
        label = "AntiAliasingMethod",
    })

    Setting.reg("DecorationsQuality", {
        category = "Graphics",
        type = "Slider",
        max = 10,
        min = 1,
        default = 10,
        ---@param setting Setting
        set_action = function(setting)
           local value = setting.value / 10.0
           engine.props_quality = value
           print_info("set DecorationsQuality "..value)
           engine:apply()
        end,
        label = "DecorationsQuality",
    })

    Setting.reg("LoadingRange", {
        category = "Graphics",
        type = "Slider",
        max = 30,
        min = 6,
        default = 22,
        ---@param setting Setting
        set_action = function(setting)
           local value = setting.value
           engine.loading_range = value
           print_info("set LoadingRange "..value)
           engine:apply()
        end,
        label = "LoadingRange",
    })

    local function generate_slider(name, variable)
        Setting.reg(name, {
            category = "Graphics",
            type = "Slider",
            max = 100,
            min = 0,
            default = 100,
            ---@param setting Setting
            set_action = function(setting)
               local value = setting.value / 100.0
               engine[variable] = value
               print_info("set "..variable.." "..value)
               engine:apply()
            end,
            label = name,
        })
    end

    generate_slider("GrassRenderingRange", "props_mul")
    generate_slider("Fog", "fog")

    Setting.reg("Fov", {
        category = "Graphics",
        type = "Slider",
        max = 100,
        min = 70,
        default = 80,
        ---@param setting Setting
        set_action = function(setting)
           local value = setting.value
           engine.fov = value
           print_info("set ".."Fov".." "..value)
           engine:apply()
        end,
        label = "Fov",
    })

    Setting.reg("MaxFps", {
        category = "Graphics",
        type = "String",
        default = "60",
        options = {"24", "30", "60", "120"},
        ---@param setting Setting
        set_action = function(setting)
           engine.fps = tonumber(setting.value)
           engine:apply()
        end,
        label = "MaxFps",
    })

    Setting.reg("VramBudget", {
        category = "Graphics",
        type = "String",
        default = "Medium",
        options = {"Low", "Medium", "High"},
        ---@param setting Setting
        set_action = function(setting)
            if setting.value == "Low" then
                engine.limit_texture_pool_to_vram = true
                engine.texture_pool_size_mb = 768
                engine.texture_max_temp_memory_mb = 96
                engine.texture_mip_bias = 2
                engine.render_target_pool_min_mb = 256
            elseif setting.value == "High" then
                engine.limit_texture_pool_to_vram = true
                engine.texture_pool_size_mb = 1536
                engine.texture_max_temp_memory_mb = 192
                engine.texture_mip_bias = 0
                engine.render_target_pool_min_mb = 400
            else
                engine.limit_texture_pool_to_vram = true
                engine.texture_pool_size_mb = 1200
                engine.texture_max_temp_memory_mb = 128
                engine.texture_mip_bias = 1
                engine.render_target_pool_min_mb = 300
            end

            local limit_value = engine.limit_texture_pool_to_vram and 1 or 0
            Console.run("r.TextureStreaming 1")
            Console.run("r.Streaming.LimitPoolSizeToVRAM "..limit_value)
            Console.run("r.Streaming.PoolSize "..engine.texture_pool_size_mb)
            Console.run("r.Streaming.MaxTempMemoryAllowed "..engine.texture_max_temp_memory_mb)
            Console.run("r.Streaming.MipBias "..engine.texture_mip_bias)
            Console.run("r.Streaming.UsePerTextureBias 1")
            Console.run("r.Streaming.DefragDynamicBounds 1")
            Console.run("r.RenderTargetPoolMin "..engine.render_target_pool_min_mb)
            engine:apply()
        end,
        label = "VramBudget",
    })

    generate_setting_on_off("VSync", "r.Vsync")

end