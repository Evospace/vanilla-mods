-- VanillaQuests: sample questbook content built on the questbook framework.
--
-- This is the *foundation* example: one chapter with two mining quests that
-- demonstrate the full pipeline end to end:
--   * a chapter available from the start of the game,
--   * a quest unlocked from the chapter start (GatherCopperOre),
--   * an OR-group objective ("20 chalcopyrite OR malachite ore", any mix),
--   * a quest unlocked by completing another (StockpileCopperOre),
--   * an explanatory image + an item context preview.
--
-- Add real chapters/quests by copying this file's pattern. The other objective
-- types (research / build_block / count) are shown commented out below.

local qb = require('questbook')

local VanillaQuestsMod = {}

function VanillaQuestsMod.pre_init()
end

function VanillaQuestsMod.init()
   -- === Chapter: Copper production (available from the start) ===
   qb.chapter("CopperProduction", {
      label = Loc.new("CopperProductionChapter", "quests"),
      description = { Loc.new("CopperProductionChapterDesc", "quests") },
      -- requires = {}  -- empty / omitted => unlocked immediately
   })

   -- Quest 1: available as soon as the chapter unlocks.
   qb.quest("GatherCopperOre", {
      chapter = "CopperProduction",
      label = Loc.new("GatherCopperOre", "quests"),
      description = {
         Loc.new("GatherCopperOreDesc1", "quests"),
         Loc.new("GatherCopperOreDesc2", "quests"),
      },
      image = "Textures/CopperOre.png",
      context = { "ChalcopyriteOre", "MalachiteOre" },
      unlocks = { "StockpileCopperOre" },
      objectives = {
         -- OR-group: any mix of chalcopyrite and malachite ore counts toward 20.
         qb.collect_item({ "ChalcopyriteOre", "MalachiteOre" }, 20,
            { label = Loc.new("ObjGatherCopperOre", "quests") }),
      },
   })

   -- Quest 2: unlocked when GatherCopperOre is completed.
   qb.quest("StockpileCopperOre", {
      chapter = "CopperProduction",
      label = Loc.new("StockpileCopperOre", "quests"),
      description = { Loc.new("StockpileCopperOreDesc", "quests") },
      objectives = {
         qb.collect_item({ "ChalcopyriteOre", "MalachiteOre" }, 50,
            { label = Loc.new("ObjStockpileCopperOre", "quests") }),
      },
   })

   -- === Other objective types (examples, kept commented) ===
   --
   -- qb.quest("BuildFirstSmelter", {
   --    chapter   = "CopperProduction",
   --    label     = Loc.new("BuildFirstSmelter", "quests"),
   --    description = { Loc.new("BuildFirstSmelterDesc", "quests") },
   --    objectives = {
   --       qb.build_block({ "StoneSmelter", "CopperSmelter" }, 1),  -- build any smelter
   --       qb.research("Smelting0"),   -- research names may carry a level suffix
   --    },
   -- })
   --
   -- A second chapter gated behind the copper chapter (chapter unlock graph):
   -- qb.chapter("NuclearEnergy", {
   --    label = Loc.new("NuclearEnergyChapter", "quests"),
   --    description = { Loc.new("NuclearEnergyChapterDesc", "quests") },
   --    requires = { "StockpileCopperOre" },  -- needs this quest completed first
   -- })

   qb.build()
end

function VanillaQuestsMod.post_init()
end

db:mod(VanillaQuestsMod)
