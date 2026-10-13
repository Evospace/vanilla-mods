return function()
   local function make_audio(name, classes, default)
      Setting.reg(name, {
         category = "Audio",
         type = "Slider",
         max = 100,
         min = 0,
         default = default,
         ---@param setting Setting
         set_action = function(setting)
            local value = setting.value / 100.0
            for _, path in ipairs(classes) do
               local className = path .. "." .. string.match(path, "[^/]+$")
               local sc = SoundClass.load(className)
               sc.volume = value
               print_info("set " .. className .. " volume " .. value)
            end
            engine:apply()
         end,
         label = name,
      })
   end

   local audio = "/Game/Audio/"
   local uds = "/Game/UltraDynamicSky/Sound/"

   make_audio("Master", { audio .. "EvospaceMaster", uds .. "UDS_Weather" }, 100)
   make_audio("Music", { audio .. "Music" }, 60)
   make_audio("Blocks", { audio .. "Blocks" }, 100)
   make_audio("Ambient", { audio .. "Ambient" }, 100)
   make_audio("Environment", { uds .. "UDS_Environment_Sound", uds .. "UDS_Outdoor_Sound" }, 50)
   make_audio("Weather", { uds .. "UDS_Weather_Mixer" }, 50)
   make_audio("Footsteps", { audio .. "Footsteps" }, 75)
   make_audio("UI", { audio .. "UI" }, 100)

   Setting.reg("MuteOnFocusLoss", {
      category = "Audio",
      type = "Bool",
      default = true,
      ---@param setting Setting
      set_action = function(setting)
         local value = setting.value
         engine.mute_on_focus_loss = value
         print_info("set MuteOnFocusLoss "..tostring(value))
         engine:apply()
      end,
      label = "MuteOnFocusLoss",
   })
 end
