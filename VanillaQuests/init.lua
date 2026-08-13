local qb = require('questbook')

local VanillaQuestsMod = {}

function VanillaQuestsMod.pre_init()
end

function VanillaQuestsMod.init()
   qb.chapter("CopperProduction", {
      label = Loc.new("CopperProductionChapter", "quests"),
      description = { Loc.new("CopperProductionChapterDesc", "quests") },
   })

   qb.quest("GatherCopperOre", {
      chapter = "CopperProduction",
      label = Loc.new("GatherCopperOre", "quests"),
      description = {
         Loc.new("GatherCopperOreDesc1", "quests"),
         Loc.new("GatherCopperOreDesc2", "quests"),
      },
      image = "Textures/CopperOre.png",
      context = { "ChalcopyriteOre", "MalachiteOre" },
      unlocks = { "BuildFirstSmelter" },
      objectives = {
         qb.collect_item({ "ChalcopyriteOre", "MalachiteOre" }, 20,
            { label = Loc.new("ObjGatherCopperOre", "quests") }),
      },
   })

   qb.quest("GatherFuel", {
      chapter = "CopperProduction",
      label = Loc.new("GatherFuel", "quests"),
      description = { Loc.new("GatherFuelDesc", "quests") },
      context = { "CoalOre", "Log" },
      objectives = {
         qb.collect_item({ "CoalOre", "Log" }, 40,
            { label = Loc.new("ObjGatherFuel", "quests"), weights = { CoalOre = 2 } }),
      },
   })

   qb.quest("BuildFirstSmelter", {
      chapter = "CopperProduction",
      label = Loc.new("BuildFirstSmelter", "quests"),
      description = {
         Loc.new("BuildFirstSmelterDesc1", "quests"),
         Loc.new("BuildFirstSmelterDesc2", "quests"),
      },
      context = { "StoneFurnace", "StoneSmelter" },
      unlocks = { "SmeltCopperPlates" },
      objectives = {
         qb.build_block({ "StoneFurnace" }, 1,
            { label = Loc.new("ObjBuildStoneFurnace", "quests") }),
         qb.build_stack({ "StoneSmelter" }, { "StoneFurnace" },
            { label = Loc.new("ObjStackStoneSmelter", "quests") }),
      },
   })

   qb.quest("SmeltCopperPlates", {
      chapter = "CopperProduction",
      label = Loc.new("SmeltCopperPlates", "quests"),
      description = {
         Loc.new("SmeltCopperPlatesDesc1", "quests"),
         Loc.new("SmeltCopperPlatesDesc2", "quests"),
      },
      context = { "CopperPlate" },
      objectives = {
         qb.craft_item({ "CopperPlate" }, 20,
            { label = Loc.new("ObjSmeltCopperPlates", "quests") }),
      },
   })

   qb.build()
end

function VanillaQuestsMod.post_init()
end

db:mod(VanillaQuestsMod)
