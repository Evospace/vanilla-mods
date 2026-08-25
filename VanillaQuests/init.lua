local qb = require('questbook')

local VanillaQuestsMod = {}

function VanillaQuestsMod.pre_init()
end

function VanillaQuestsMod.init()
   qb.chapter("OreToPower", {
      label = Loc.new("OreToPowerChapter", "quests"),
   })

   qb.quest("Welcome", {
      chapter = "OreToPower",
      label = Loc.new("Welcome", "quests"),
      unlocks = { "GatherCopperOre", "GatherFuel" },
      description = {
         Loc.new("WelcomeDesc1", "quests"),
         Loc.new("WelcomeDesc2", "quests"),
      },
      objectives = {
         qb.open_gui("questbook", { label = Loc.new("ObjOpenQuestBook", "quests") }),
         qb.close_all_gui({ label = Loc.new("ObjReturnToWorld", "quests") }),
      },
   })

   qb.quest("GatherCopperOre", {
      chapter = "OreToPower",
      label = Loc.new("GatherCopperOre", "quests"),
      description = {
         Loc.new("GatherCopperOreDesc", "quests"),
         Loc.new("GatherCopperOreDesc2", "quests"),
      },
      context = { "ChalcopyriteOre", "MalachiteOre" },
      objectives = {
         qb.collect_item({ "ChalcopyriteOre", "MalachiteOre" }, 25,
            { label = Loc.new("ObjGatherCopperOre", "quests") }),
      },
   })

   qb.quest("GatherFuel", {
      chapter = "OreToPower",
      label = Loc.new("GatherFuel", "quests"),
      description = { Loc.new("GatherFuelDesc", "quests") },
      context = { "CoalOre", "Log" },
      any = true,
      objectives = {
         qb.collect_item({ "CoalOre" }, 20,
            { label = Loc.new("ObjGatherCoal", "quests") }),
         qb.collect_item({ "Log" }, 40,
            { label = Loc.new("ObjGatherLogs", "quests") }),
      },
   })

   qb.quest("MineStone", {
      chapter = "OreToPower",
      label = Loc.new("MineStone", "quests"),
      description = { Loc.new("MineStoneDesc", "quests") },
      context = { "StoneSurface" },
      requires = { "GatherCopperOre", "GatherFuel" },
      unlocks = { "ReturnHome" },
      objectives = {
         qb.collect_item({ "StoneSurface" }, 12,
            { label = Loc.new("ObjMineStone", "quests") }),
      },
   })

   qb.quest("OpenInventory", {
      chapter = "OreToPower",
      label = Loc.new("OpenInventory", "quests"),
      description = {
         Loc.new("OpenInventoryDesc1", "quests"),
         Loc.new("OpenInventoryDesc2", "quests"),
      },
      objectives = {
         qb.open_gui("inventory", { label = Loc.new("ObjOpenInventory", "quests") }),
      },
   })

   qb.quest("ReturnHome", {
      chapter = "OreToPower",
      label = Loc.new("ReturnHome", "quests"),
      description = {
         Loc.new("ReturnHomeDesc1", "quests"),
         Loc.new("ReturnHomeDesc2", "quests"),
      },
      unlocks = { "CraftFirstBlocks", "OpenInventory" },
      objectives = {
         qb.return_home({ label = Loc.new("ObjReturnHome", "quests") }),
      },
   })

   qb.quest("CraftFirstBlocks", {
      chapter = "OreToPower",
      label = Loc.new("CraftFirstBlocks", "quests"),
      description = { Loc.new("CraftFirstBlocksDesc", "quests") },
      context = { "StoneFurnace", "StoneSmelter" },
      unlocks = { "BuildFirstSmelter" },
      objectives = {
         qb.craft_item({ "StoneFurnace" }, 2,
            { label = Loc.new("ObjCraftStoneFurnace", "quests") }),
         qb.craft_item({ "StoneSmelter" }, 1,
            { label = Loc.new("ObjCraftStoneSmelter", "quests") }),
      },
   })

   qb.quest("BuildFirstSmelter", {
      chapter = "OreToPower",
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
      chapter = "OreToPower",
      label = Loc.new("SmeltCopperPlates", "quests"),
      description = {
         Loc.new("SmeltCopperPlatesDesc1", "quests"),
         Loc.new("SmeltCopperPlatesDesc2", "quests"),
      },
      context = { "CopperPlate" },
      unlocks = { "CraftMachines" },
      objectives = {
         qb.craft_item({ "CopperPlate" }, 25,
            { label = Loc.new("ObjSmeltCopperPlates", "quests") }),
      },
   })

   qb.quest("CraftMachines", {
      chapter = "OreToPower",
      label = Loc.new("CraftMachines", "quests"),
      description = { Loc.new("CraftMachinesDesc", "quests") },
      context = { "CopperStirlingEngine", "CopperCompactGenerator", "CopperComputer" },
      unlocks = { "BuildFirstPowerPlant" },
      objectives = {
         qb.craft_item({ "CopperStirlingEngine" }, 1,
            { label = Loc.new("ObjCraftStirlingEngine", "quests") }),
         qb.craft_item({ "CopperCompactGenerator" }, 1,
            { label = Loc.new("ObjCraftCompactGenerator", "quests") }),
         qb.craft_item({ "CopperComputer" }, 1,
            { label = Loc.new("ObjCraftComputer", "quests") }),
      },
   })

   qb.quest("BuildFirstPowerPlant", {
      chapter = "OreToPower",
      label = Loc.new("BuildFirstPowerPlant", "quests"),
      description = {
         Loc.new("BuildFirstPowerPlantDesc1", "quests"),
         Loc.new("BuildFirstPowerPlantDesc2", "quests"),
      },
      context = { "StoneFurnace", "CopperStirlingEngine", "CopperCompactGenerator", "CopperComputer" },
      objectives = {
         qb.build_chain({
            { block = { "StoneFurnace", "CopperFurnace" }, out = "rao" },
            { block = "CopperStirlingEngine", inp = "Input1", out = "Output" },
            { block = "CopperCompactGenerator", inp = "rai", out = "rao" },
            { block = "CopperComputer", inp = "rai" },
         }, { label = Loc.new("ObjBuildPowerPlant", "quests") }),
      },
   })

   qb.chapter("Automation", {
      label = Loc.new("AutomationChapter", "quests"),
      requires = { "BuildFirstPowerPlant" },
   })

   -- Three nodes still stand between the running computer and the drill; everything under them, up
   -- to Metalwork and DistributedComputing, gates a recipe the first chapter already had the player
   -- build, so it is complete before this chapter is ever offered. The first of the three carries
   -- the research window itself, which nothing has asked the player to open until now.
   qb.quest("ResearchBasicMachines", {
      chapter = "Automation",
      label = Loc.new("ResearchBasicMachines", "quests"),
      description = {
         Loc.new("ResearchBasicMachinesDesc1", "quests"),
         Loc.new("ResearchBasicMachinesDesc2", "quests"),
      },
      context = { "CopperMacerator", "CopperAutomaticHammer" },
      unlocks = { "ResearchAutomaticMining" },
      objectives = {
         qb.research("BasicMachines", { label = Loc.new("ObjResearchBasicMachines", "quests") }),
      },
   })

   qb.quest("ResearchAutomaticMining", {
      chapter = "Automation",
      label = Loc.new("ResearchAutomaticMining", "quests"),
      description = {
         Loc.new("ResearchAutomaticMiningDesc1", "quests"),
         Loc.new("ResearchAutomaticMiningDesc2", "quests"),
      },
      context = { "CopperConveyor", "CopperRobotArm", "CopperDrillingRig" },
      unlocks = { "BuildAutomaticMine" },
      objectives = {
         qb.research("Automatization", { label = Loc.new("ObjResearchAutomatization", "quests") }),
         qb.research("AutomaticMining", { label = Loc.new("ObjResearchAutomaticMining", "quests") }),
      },
   })

   qb.quest("BuildAutomaticMine", {
      chapter = "Automation",
      label = Loc.new("BuildAutomaticMine", "quests"),
      description = {
         Loc.new("BuildAutomaticMineDesc1", "quests"),
         Loc.new("BuildAutomaticMineDesc2", "quests"),
         Loc.new("BuildAutomaticMineDesc3", "quests"),
      },
      context = { "CopperDrillingRig", "CopperStirlingEngine", "StoneChest" },
      unlocks = { "CraftOreMultiplication" },
      objectives = {
         qb.build_chain({
            { block = { "StoneFurnace", "CopperFurnace" }, out = "rao" },
            { block = "CopperStirlingEngine", inp = "Input1", out = "Output" },
            { block = "CopperDrillingRig", inp = "ria" },
         }, { label = Loc.new("ObjPowerDrillingRig", "quests") }),
         qb.build_chain({
            { block = "CopperDrillingRig", out = "oa" },
            { block = { "StoneChest", "CopperChest" } },
         }, { label = Loc.new("ObjDockMineChest", "quests") }),
      },
   })

   -- The machines the line takes, counted as it stands: chest, arm, hammer, arm, each macerator,
   -- arm, smelter, arm, chest, and behind the row the engine that drives the hammer with the
   -- furnace under it plus the furnace that heats the smelter. Two macerators per hammer: one
   -- macerator grinds slower than the hammer crushes.
   qb.quest("CraftOreMultiplication", {
      chapter = "Automation",
      label = Loc.new("CraftOreMultiplication", "quests"),
      description = {
         Loc.new("CraftOreMultiplicationDesc1", "quests"),
         Loc.new("CraftOreMultiplicationDesc2", "quests"),
      },
      context = { "CopperAutomaticHammer", "CopperMacerator", "CopperRobotArm", "StoneSmelter", "StoneChest" },
      unlocks = { "ResearchCircuits" },
      objectives = {
         qb.craft_item({ "StoneChest" }, 2,
            { label = Loc.new("ObjCraftLineChests", "quests") }),
         qb.craft_item({ "CopperAutomaticHammer" }, 1,
            { label = Loc.new("ObjCraftLineHammer", "quests") }),
         qb.craft_item({ "CopperMacerator" }, 2,
            { label = Loc.new("ObjCraftMultiplierMacerators", "quests") }),
         qb.craft_item({ "StoneSmelter" }, 2,
            { label = Loc.new("ObjCraftLineSmelter", "quests") }),
         qb.craft_item({ "CopperRobotArm" }, 5,
            { label = Loc.new("ObjCraftMultiplierArms", "quests") }),
         qb.craft_item({ "CopperStirlingEngine" }, 3,
            { label = Loc.new("ObjCraftLineEngine", "quests") }),
         qb.craft_item({ "StoneFurnace" }, 5,
            { label = Loc.new("ObjCraftLineFurnaces", "quests") }),
      },
   })

   -- CopperWire hangs off DistributedComputing and opens the circuit branch; Constructor sits on
   -- Automatization, which the mining quest already finished.
   qb.quest("ResearchCircuits", {
      chapter = "Automation",
      label = Loc.new("ResearchCircuits", "quests"),
      description = {
         Loc.new("ResearchCircuitsDesc1", "quests"),
      },
      context = { "CircuitBoard", "Triod", "Circuit", "CopperConstructor" },
      objectives = {
         qb.research("CircuitBoard", { label = Loc.new("ObjResearchCircuitBoard", "quests") }),
         qb.research("Triod", { label = Loc.new("ObjResearchTriod", "quests") }),
         qb.research("Circuit", { label = Loc.new("ObjResearchCircuit", "quests") }),
         qb.research("Constructor", { label = Loc.new("ObjResearchConstructor", "quests") }),
      },
   })

   qb.build()
end

function VanillaQuestsMod.post_init()
end

db:mod(VanillaQuestsMod)
