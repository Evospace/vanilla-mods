local core_mod = {}

function core_mod.pre_init()
   require('controls')()
   require('graphics')()
   require('game_settings')()
   require('audio')()
end

function core_mod.init()
end

function core_mod.post_init()
end

db:mod(core_mod)
