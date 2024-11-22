function register_graphics()
    function option4_to_int(string_value)
        local preset = 0
        if string_value == "Medium" then preset = 1 end
        if string_value == "High" then preset = 2 end
        if string_value == "Epic" then preset = 3 end
        return preset
    end

    -- db:from_table({
    --     class = "Setting",
    --     category = "Graphics",
    --     type = "String",

    --     default_string_value = "High",
    --     string_options = {"Low", "Medium", "High", "Epic"},

    --     action = function(setting)
    --         Console.run("Scalability "..option4_to_int(setting.string_value))
    --         local set = Setting.find("ShadowQuality")
    --         set.string_value = setting.string_value
    --     end,

    --     label = "ScalabilityPreset",
    --     name = "ScalabilityPreset",
    --  })

    function generate_setting(name, command)
        db:from_table({
            class = "Setting",
            category = "Graphics",
            type = "String",
            default_string_value = "High",
            string_options = {"Low", "Medium", "High", "Epic"},
            action = function(setting)
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

    function generate_reflection(name, command)
        db:from_table({
            class = "Setting",
            category = "Graphics",
            type = "String",
            default_string_value = "SSGI",
            string_options = {"Disable", "SSGI", "Lumen"},
            action = function(setting)
                local preset = 0
                if setting.string_value == "Lumen" then preset = 1 end
                if setting.string_value == "SSGI" then preset = 2 end
                Console.run(command.." "..preset)
            end,
            label = name,
            name = name,
         })
    end
    generate_reflection("GlobalIllumination", "r.DynamicGlobalIlluminationMethod")
    generate_reflection("Reflection", "r.ReflectionMethod")

    --r.DynamicRes.OperationMode
    --r.AntiAliasingMethod
    --sg.AntiAliasingQuality
end