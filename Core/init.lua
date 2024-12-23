require 'controls'
require 'graphics'
require 'game_settings'

local core_mod = {}

function core_mod.pre_init()
   --register_controls() 0.20.1
   --register_graphics()
   --register_game_settings()
end

function core_mod.init()
end

function core_mod.post_init()
end

db:mod(core_mod)
