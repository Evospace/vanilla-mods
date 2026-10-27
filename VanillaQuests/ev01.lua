local ev01 = {}

local sound_root = "/Game/Audio/Voice/EV01/EN/VO_EV01_"

local intro_handler_id = nil

function ev01.say(name, opts)
   local spec = {
      id = "ev01." .. name,
      sound = sound_root .. name .. "_EN",
      text = Loc.new("EV01" .. name, "voice"),
      speaker = "EV-01",
   }
   for key, value in pairs(opts or {}) do
      spec[key] = value
   end
   voice.say(spec)
end

function ev01.listen()
   if intro_handler_id ~= nil then
      return
   end
   intro_handler_id = EventSystem.get():sub(defines.events.on_intro_finished, function()
      ev01.say("LandingComplete", { delay = 0.6 })
      ev01.say("NoExpeditionContact", { delay = 1.5 })
   end)
end

return ev01
