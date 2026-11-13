return function()
    local steam_deck = Game.is_steam_deck()

    local function option4_to_int(value)
        local preset = 0
        if value == "Medium" then preset = 1 end
        if value == "High" then preset = 2 end
        if value == "Epic" then preset = 3 end
        return preset
    end

    local function preset_values(preset)
        local deck = preset == "SteamDeck"
        local level = deck and "High" or preset
        local scalability = option4_to_int(level)
        local function pick(values)
            return values[scalability + 1]
        end

        local values = {
            {"ShadowQuality", deck and "Medium" or level},
            {"TextureQuality", level},
            {"EffectsQuality", level},
            {"PostProcessQuality", level},
            {"GlobalIllumination", pick({"Disable", "Disable", "ScreenSpace", "Lumen"})},
            {"Reflection", pick({"Disable", "ScreenSpace", "ScreenSpace", "Lumen"})},
            {"ReflectionQuality", pick({"Low", "Low", "High", "High"})},
            {"MaterialQuality", pick({"Low", "Medium", "High", "High"})},
            {"GrassRenderingRange", pick({30, 70, 100, 100})},
            {"DecorationsQuality", pick({2, 5, 9, 10})},
            {"LoadingRange", pick({15, 18, 25, 27})},
            {"AntiAliasingMethod", pick({"FXAA", "FXAA", "TAA", "TAA"})},
            {"ScreenPersentage", "100%"},
            {"DetailShadows", (deck or scalability <= 1) and "Off" or "On"},
            {"SpotlightShadows", scalability <= 1 and "Off" or "On"},
            {"Transparency", pick({"Low", "Medium", "High", "High"})},
            {"CloudsQuality", pick({"Off", "Simple", "Volumteric", "Volumteric"})},
            {"WindAnimation", pick({"Off", "Minimal", "Full", "Full"})},
            {"WeatherParticles", pick({"Low", "High", "High", "High"})},
            {"VramBudget", pick({"Low", "Medium", "High", "High"})},
        }
        if deck then
            table.insert(values, {"MaxFps", "40"})
        end
        return values
    end

    local preset_options = {"Low", "Medium", "High", "Epic"}
    if steam_deck then
        table.insert(preset_options, "SteamDeck")
    end

    Setting.reg("ScalabilityPreset", {
        category = "Graphics",
        type = "Buttons",

        default = steam_deck and "SteamDeck" or "High",
        options = preset_options,
        ---@param setting Setting
        set_action = function(setting)
            for _, entry in ipairs(preset_values(setting.value)) do
                local set = Setting.find(entry[1])
                set.value = entry[2]
                set:set_action()
            end

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

    local window_modes = {"Fullscreen", "WindowedFullscreen", "Windowed"}

    Setting.reg("Fullscreen", {
        category = "Graphics",
        type = "String",
        default = "WindowedFullscreen",
        options = window_modes,
        ---@param setting Setting
        get_action = function(setting)
            return window_modes[engine:get_window_mode() + 1]
        end,
        ---@param setting Setting
        set_action = function(setting)
           for index, mode in ipairs(window_modes) do
               if mode == setting.value then
                   engine.window_mode = index - 1
               end
           end
           engine:show_confirmation()
        end,
        label = "Fullscreen",
    })

    Setting.reg("Resolution", {
        category = "Graphics",
        type = "String",
        default = Game.get_desktop_resolution(),
        options = Game.get_supported_resolutions(),
        ---@param setting Setting
        get_action = function(setting)
            return engine:get_resolution()
        end,
        ---@param setting Setting
        set_action = function(setting)
            local width, height = string.match(setting.value, "^(%d+)x(%d+)$")
            engine.res_x, engine.res_y = tonumber(width), tonumber(height)
            engine:show_confirmation()
        end,
        label = "Resolution",
    })

    local quality_levels = {"Low", "Medium", "High", "Epic"}

    local function generate_quality(name, group)
        Setting.reg(name, {
            category = "Graphics",
            type = "String",
            default = "High",
            options = quality_levels,
            ---@param setting Setting
            get_action = function(setting)
                return quality_levels[math.min(engine:get_quality(group), 3) + 1]
            end,
            ---@param setting Setting
            set_action = function(setting)
                engine:set_quality(group, option4_to_int(setting.value))
            end,
            label = name,
        })
    end

    generate_quality("ShadowQuality", "Shadow")
    generate_quality("TextureQuality", "Texture")
    generate_quality("EffectsQuality", "Effects")
    generate_quality("PostProcessQuality", "PostProcess")

    Setting.reg("Transparency", {
        category = "Graphics",
        type = "String",
        default = "High",
        options = {"Low", "Medium", "High"},
        ---@param setting Setting
        set_action = function(setting)
            engine.transparency_preset = option4_to_int(setting.value)
        end,
        label = "TransparencyQuality",
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
        label = "ScreenPercentage",
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

    local fps_options = {"24", "30", "60", "120"}
    if steam_deck then
        table.insert(fps_options, 3, "40")
    end

    Setting.reg("MaxFps", {
        category = "Graphics",
        type = "String",
        default = "60",
        options = fps_options,
        ---@param setting Setting
        get_action = function(setting)
            return tostring(engine:get_fps_limit())
        end,
        ---@param setting Setting
        set_action = function(setting)
            engine:set_fps_limit(tonumber(setting.value))
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
            Console.run("r.Streaming.LimitPoolSizeToVRAM "..limit_value)
            Console.run("r.Streaming.PoolSize "..engine.texture_pool_size_mb)
            Console.run("r.Streaming.MaxTempMemoryAllowed "..engine.texture_max_temp_memory_mb)
            Console.run("r.Streaming.MipBias "..engine.texture_mip_bias)
            Console.run("r.RenderTargetPoolMin "..engine.render_target_pool_min_mb)
            engine:apply()
        end,
        label = "VramBudget",
    })

    Setting.reg("VSync", {
        category = "Graphics",
        type = "String",
        default = "Off",
        options = {"Off", "On"},
        ---@param setting Setting
        get_action = function(setting)
            return engine:get_vsync() and "On" or "Off"
        end,
        ---@param setting Setting
        set_action = function(setting)
            engine:set_vsync(setting.value == "On")
        end,
        label = "VSync",
    })

    if steam_deck then
        for _, entry in ipairs(preset_values("SteamDeck")) do
            local set = Setting.find(entry[1])
            set.default = entry[2]
            set.value = entry[2]
        end
    end
end