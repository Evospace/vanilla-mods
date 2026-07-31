-- ExampleMod: the smallest folder that adds content to Evospace.
--
-- A mod is a directory under Content/Mods holding an info.json and this file.
-- The prototypes the game ships with are read from Content/Generated before any
-- mod runs, so a mod ships no prototype json of its own: everything it adds is
-- registered here, from Lua, through the reg functions of the api.
--
-- Copy this folder, rename it in info.json, and replace the four registrations
-- below with your own.

-- require reads a module out of this folder first, then out of the folders of
-- the mods named in the dependencies of info.json. It works here at the top of
-- the file: every mod folder is registered before any init.lua runs, so a
-- dependency does not have to sort earlier than you on disk.
local Vlib = require('vlib')

local ExampleMod = {}

local ITEM = "ExampleGear"
local DICTIONARY = "ExampleAssemblerRecipeDictionary"
local RECIPE = "ExampleGearFromCopperPlate"
local BLOCK = "ExampleAssembler"
local INPUT_ITEM = Vlib.tier_material[2] .. "Plate"
local RESEARCH = "ExampleAssembly"
local PARENT_RESEARCH = "Metalwork"
local TIP = "ExampleGuide"
local BARE_BLOCK = "ExampleBareAssembler"

-- Every .ini under Loc/<locale>/ in this folder is read as the mod loads, and
-- its [section] headers become localization tables. Loc.new(key, table) points a
-- prototype at one line of one of them; a key with no line behind it shows up in
-- the game as the bare key, so the names below live in Loc/en/example.ini.
local LOC = "example"

-- An icon comes out of this folder the same way: image_path is a path relative
-- to the mod directory, resolved once loading finishes, so a mod never has to
-- drop a png into the base game's Content/Icons.

function ExampleMod.pre_init()
end

function ExampleMod.init()
   -- The item the machine produces.
   local gear = StaticItem.reg(ITEM)
   gear.stack_size = 32
   gear.tier = 1
   gear.category = "Example"
   gear.label = Loc.new(ITEM, LOC)
   gear.image_path = "Textures/ExampleGear.png"

   -- The recipe group a machine family works from.
   local dictionary = RecipeDictionary.reg(DICTIONARY)
   dictionary.start_tier = 1

   -- Two copper plates in, one gear out, two seconds at 20 ticks per second.
   -- The plate is named through the tier table of VanillaLib rather than spelled
   -- out, so the mod fails loudly if the library it depends on is not there.
   -- A recipe carries no label of its own: every screen showing one names it
   -- after the item in its first output slot.
   local recipe = Recipe.reg(RECIPE)
   recipe.ticks = 40
   recipe.tier = 1
   recipe.input:add(StaticItem.find(INPUT_ITEM), 2)
   recipe.output:add(gear, 1)
   dictionary:add(recipe)

   -- The machine, and the item it is built from and mined back into. The vanilla
   -- machines give the block and its item one name; do the same.
   local machine = StaticBlock.reg(BLOCK)
   local machine_item = StaticItem.reg(BLOCK)
   machine_item.stack_size = 32
   machine_item.tier = 1
   machine_item.category = "Example"
   machine_item.label = Loc.new(BLOCK, LOC)
   machine_item.image_path = "Textures/ExampleAssembler.png"
   machine_item.block = machine
   machine.item = machine_item

   -- logic_init runs on every placed block and wires the instance: the
   -- dictionary it crafts from, one input and one output slot, and the
   -- electricity accessor that feeds it from the side.
   machine.logic = AutoCrafter.get_class()
   machine.tier = 1
   machine.energy_consumption_per_tick = 20
   machine.lua = {
      logic_init = function(self)
         local crafter = AbstractCrafter.cast(self)
         crafter.recipes = RecipeDictionary.find(DICTIONARY)
         crafter.speed = 100

         crafter.crafter_input_container:bind(SingleSlotInventory.new(crafter, "ii1"))
         crafter.crafter_output_container:bind(SingleSlotInventory.new(crafter, "io1"))

         local energy = ResourceInventory.new(crafter, "rii")
         energy.item = StaticItem.find("Electricity")
         crafter.energy_input_inventory = energy

         local accessor = ResourceAccessor.new(crafter, "rai")
         accessor.side, accessor.pos = Vec3i.back, Vec3i.zero
         accessor.inventory = energy
         accessor.is_input = true
         accessor.channel = "Electricity"
         accessor.cover = StaticCover.find("ElectricityInput")
      end,
   }

   -- Nothing above makes the machine buildable: an item reaches the player's
   -- hand crafting only when a research unlocks a recipe of HandRecipeDictionary
   -- that produces it. So the mod adds both — the hand recipe, and a research
   -- node hung off a vanilla one through required_research, which is how a mod
   -- puts its content into the tree the player already climbs.
   local hand_recipe = Recipe.reg(BLOCK)
   hand_recipe.ticks = 40
   hand_recipe.input:add(StaticItem.find(INPUT_ITEM), 8)
   hand_recipe.output:add(machine_item, 1)
   RecipeDictionary.find("HandRecipeDictionary"):add(hand_recipe)

   local research = StaticResearchRecipe.reg(RESEARCH)
   research.label = Loc.new(RESEARCH, LOC)
   research.complexity = 200
   research.required_research = { StaticResearch.find(PARENT_RESEARCH) }
   research:unlocks(hand_recipe)

   -- An encyclopedia page telling the player what the machine is for. Its
   -- illustration comes out of this folder the same way an icon does: image is a
   -- path relative to the mod directory, resolved once loading finishes.
   local tip = StaticTip.reg(TIP)
   tip.label = Loc.new(TIP, LOC)
   tip.description_parts = { Loc.new(TIP .. "Description", LOC) }
   tip.image = "Textures/ExampleAssembler.png"

   local bare = StaticBlock.reg(BARE_BLOCK)
   local bare_item = StaticItem.reg(BARE_BLOCK)
   bare_item.stack_size = 32
   bare_item.tier = 1
   bare_item.category = "Example"
   bare_item.label = Loc.new(BARE_BLOCK, LOC)
   bare_item.block = bare
   bare.item = bare_item

   bare.logic = AutoCrafter.get_class()
   bare.tier = 1
   bare.lua = {
      logic_init = function(self)
         local crafter = AbstractCrafter.cast(self)

         crafter.crafter_input_container:bind(SingleSlotInventory.new(crafter, "ii1"))
         crafter.crafter_output_container:bind(SingleSlotInventory.new(crafter, "io1"))

         crafter.switch_on = crafter:select_recipe_by_output(StaticItem.find(ITEM))
      end,
   }
end

function ExampleMod.post_init()
end

db:mod(ExampleMod)
