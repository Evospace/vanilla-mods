return function()
   local function make_audio(name, class) 
         db:from_table({
         class = "Setting",
         category = "Audio",
         type = "Slider",
         max_value = 100,
         min_value = 0,
         int_default_value = 100,
         ---@param setting Setting
         set_action = function(setting)
            local value = setting.int_value / 100.0
            local sc = SoundClass.load("/Game/Sounds/"..class.."."..class)
            sc.volume = value
            print("set "..class.." volume "..value)
            game.engine_data:apply()
         end,
         label = class,
         name = class,
   })
   end

   make_audio("Master", "EvospaceMaster")
   make_audio("Music", "Music")
   make_audio("Blocks", "Blocks")
   make_audio("Ambient", "Ambient")
   make_audio("NatureAmbient", "NatureAmbient")
   make_audio("UI", "UI")
 end