return function()
   local function make_audio(name, class, default) 
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
            local className = "/Game/Audio/"..class.."."..class
            local sc = SoundClass.load(className)
            sc.volume = value
            print("set "..class.." volume "..value)
            engine:apply()
         end,
         label = name,
         name = name,
      })
   end

   make_audio("Master", "EvospaceMaster", 100)
   make_audio("Music", "Music", 60)
   make_audio("Blocks", "Blocks", 100)
   make_audio("Ambient", "Ambient", 100)
   make_audio("NatureAmbient", "NatureAmbient", 100)
   make_audio("Rain", "Rain", 100)
   make_audio("Footsteps", "Footsteps", 75)
   make_audio("UI", "UI", 100)
 end