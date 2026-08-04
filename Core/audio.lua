return function()
   local function make_audio(name, classes, default)
      db:from_table({
         class = "Setting",
         category = "Audio",
         type = "Slider",
         max_value = 100,
         min_value = 0,
         int_default_value = default,
         ---@param setting Setting
         set_action = function(setting)
            local value = setting.int_value / 100.0
            for _, path in ipairs(classes) do
               local className = path .. "." .. string.match(path, "[^/]+$")
               local sc = SoundClass.load(className)
               sc.volume = value
               print_info("set " .. className .. " volume " .. value)
            end
            engine:apply()
         end,
         label = name,
         name = name,
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
 end
