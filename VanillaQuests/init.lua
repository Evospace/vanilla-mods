-- VanillaQuests: the opening questbook chain.
--
-- Everything here has to be doable with what a new game actually gives the
-- player: the multitool, the hand recipes behind the researches completed at
-- session start (MineralsScan, Smelting, Metalwork, ...) and nothing else. The
-- research tree stays out of the chain -- researching costs Computations, which
-- take a Computer, which takes copper the player does not have yet.
--
-- One chapter with three quests:
--   * a chapter available from the start of the game,
--   * two quests offered side by side from the chapter start (GatherCopperOre
--     and GatherFuel), since nothing gates one behind the other,
--   * an OR-group objective ("20 chalcopyrite OR malachite ore", any mix),
--   * a weighted OR-group ("20 coal ore OR 40 logs", any mix),
--   * a quest unlocked by completing another, whose second objective is a
--     placement rather than a count (BuildFirstSmelter),
--   * an explanatory image + an item context preview.
--
-- Add real chapters/quests by copying this file's pattern. The remaining
-- objective types (research, count) are shown commented out below.

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
      unlocks = { "BuildFirstSmelter" },
      objectives = {
         -- OR-group: any mix of chalcopyrite and malachite ore counts toward 20.
         qb.collect_item({ "ChalcopyriteOre", "MalachiteOre" }, 20,
            { label = Loc.new("ObjGatherCopperOre", "quests") }),
      },
   })

   -- Quest 2: offered next to GatherCopperOre rather than behind it -- a quest
   -- with no prerequisite is unlocked from the chapter start. The furnace burns
   -- either fuel, so the objective is one weighted counter: coal is worth two
   -- units and a log one, which is 20 coal, 40 logs, or any mix of the two.
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

   -- Quest 3: unlocked when GatherCopperOre is completed. A smelter makes no
   -- heat of its own, so it only runs standing on a furnace burning fuel
   -- underneath it -- which is why the second objective is qb.build_stack and
   -- not a second qb.build_block: a smelter dropped anywhere must not count.
   -- Both stone machines are hand recipes from the start (Smelting /
   -- MineralsScan); the copper smelter is not -- it sits behind the Smelting1
   -- research, which needs a Computer the player cannot build yet.
   qb.quest("BuildFirstSmelter", {
      chapter = "CopperProduction",
      label = Loc.new("BuildFirstSmelter", "quests"),
      description = {
         Loc.new("BuildFirstSmelterDesc1", "quests"),
         Loc.new("BuildFirstSmelterDesc2", "quests"),
      },
      context = { "StoneFurnace", "StoneSmelter" },
      objectives = {
         qb.build_block({ "StoneFurnace" }, 1,
            { label = Loc.new("ObjBuildStoneFurnace", "quests") }),
         qb.build_stack({ "StoneSmelter" }, { "StoneFurnace" },
            { label = Loc.new("ObjStackStoneSmelter", "quests") }),
      },
   })

   -- === Other objective types (examples, kept commented) ===
   --
   -- A quest that sends the player to the research tree. Research names carry a
   -- level suffix and the base level is unsuffixed, so "Smelting" is level 0 and
   -- "Smelting1" unlocks the copper smelter:
   -- objectives = { qb.research("Smelting1", { label = ... }) }
   --
   -- A second chapter gated behind the copper chapter (chapter unlock graph):
   -- qb.chapter("NuclearEnergy", {
   --    label = Loc.new("NuclearEnergyChapter", "quests"),
   --    description = { Loc.new("NuclearEnergyChapterDesc", "quests") },
   --    requires = { "BuildFirstSmelter" },  -- needs this quest completed first
   -- })

   qb.build()
end

function VanillaQuestsMod.post_init()
end

db:mod(VanillaQuestsMod)
