local core_mod = {}

function core_mod.pre_init()
   require('@self/controls')()
   require('@self/graphics')()
   require('@self/game_settings')()
   require('@self/audio')()
end

function core_mod.init()
end

function core_mod.post_init()
end

db:mod(core_mod)
