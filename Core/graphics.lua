return function()
    local steam_deck = Game.is_steam_deck()

    local quality_levels = {"Low", "Medium", "High", "Epic"}

    local function level_of(value, legacy)
        for index, name in ipairs(quality_levels) do
            if name == value then
                return index - 1
            end
        end
        return legacy and legacy[value]
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
            if setting.value == "SteamDeck" then
                engine:set_overall_quality(2)
                engine:set_quality("Shadow", 1)
                engine:set_fps_limit(40)
            else
                local level = level_of(setting.value)
                if level then
                    engine:set_overall_quality(level)
                end
            end
            Setting.update_widgets()
        end,

        label = "ScalabilityPreset",
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

    local function generate_quality(name, group, default, legacy)
        Setting.reg(name, {
            category = "Graphics",
            type = "String",
            default = default,
            options = quality_levels,
            ---@param setting Setting
            get_action = function(setting)
                return quality_levels[math.min(engine:get_quality(group), 3) + 1]
            end,
            ---@param setting Setting
            set_action = function(setting)
                local level = level_of(setting.value, legacy)
                if level then
                    engine:set_quality(group, level)
                end
            end,
            label = name,
        })
    end

    local legacy_methods = {Disable = 0, ScreenSpace = 2, Lumen = 3}

    generate_quality("ShadowQuality", "Shadow", steam_deck and "Medium" or "High")
    generate_quality("TextureQuality", "Texture", "High")
    generate_quality("EffectsQuality", "Effects", "High")
    generate_quality("PostProcessQuality", "PostProcess", "High")
    generate_quality("GlobalIllumination", "GlobalIllumination", "High", legacy_methods)
    generate_quality("Reflection", "Reflection", "High", legacy_methods)
    generate_quality("MaterialQuality", "Shading", "High")
    generate_quality("DecorationsQuality", "Foliage", "High")
    generate_quality("LoadingRange", "ViewDistance", "High")

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

    Setting.reg("Fog", {
        category = "Graphics",
        type = "Slider",
        max = 100,
        min = 0,
        default = 100,
        ---@param setting Setting
        set_action = function(setting)
           engine.fog = setting.value / 100.0
           engine:apply()
        end,
        label = "Fog",
    })

    Setting.reg("Fov", {
        category = "Graphics",
        type = "Slider",
        max = 100,
        min = 70,
        default = 80,
        ---@param setting Setting
        set_action = function(setting)
           engine.fov = setting.value
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
        default = steam_deck and "40" or "60",
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
end
