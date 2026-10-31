local qb = require('@self/questbook')
local ev01 = require('@self/ev01')

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
         Loc.new("WelcomeDesc3", "quests"),
         Loc.new("WelcomeDesc4", "quests"),
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

   qb.quest("ItemDatabase", {
      chapter = "OreToPower",
      label = Loc.new("ItemDatabase", "quests"),
      description = {
         Loc.new("OpenInventoryDesc1", "quests"),
         Loc.new("ItemDatabaseDesc1", "quests"),
         Loc.new("ItemDatabaseDesc2", "quests"),
      },
      context = { "StoneFurnace" },
      objectives = {
         qb.open_gui("inventory", { label = Loc.new("ObjOpenInventory", "quests") }),
         qb.view_recipes({ "StoneFurnace" }, { label = Loc.new("ObjRecipesStoneFurnace", "quests") }),
      },
   })

   qb.quest("ReturnHome", {
      chapter = "OreToPower",
      label = Loc.new("ReturnHome", "quests"),
      description = {
         Loc.new("ReturnHomeDesc1", "quests"),
         Loc.new("ReturnHomeDesc2", "quests"),
      },
      unlocks = { "CraftFirstBlocks", "ItemDatabase", "BuildPlatforms" },
      objectives = {
         qb.return_home({ label = Loc.new("ObjReturnHome", "quests") }),
      },
   })

   qb.quest("BuildPlatforms", {
      chapter = "OreToPower",
      label = Loc.new("BuildPlatforms", "quests"),
      description = {
         Loc.new("BuildPlatformsDesc1", "quests"),
         Loc.new("BuildPlatformsDesc2", "quests"),
         Loc.new("BuildPlatformsDesc3", "quests"),
      },
      context = { "BasicPlatform", "BuildingMaterial", "StoneSurface" },
      objectives = {
         qb.open_gui("decor", { label = Loc.new("ObjOpenDecor", "quests") }),
         qb.build_block({ "BasicPlatform" }, 20,
            { label = Loc.new("ObjBuildPlatforms", "quests") }),
         qb.craft_item({ "BuildingMaterial" }, 10,
            { label = Loc.new("ObjOrderBuildingMaterial", "quests") }),
      },
   })

   qb.quest("CraftFirstBlocks", {
      chapter = "OreToPower",
      label = Loc.new("CraftFirstBlocks", "quests"),
      description = {
         Loc.new("CraftFirstBlocksDesc", "quests"),
         Loc.new("CraftFirstBlocksDesc2", "quests"),
      },
      context = { "StoneFurnace", "StoneSmelter" },
      unlocks = { "PinToHotbar" },
      objectives = {
         qb.craft_item({ "StoneFurnace" }, 2,
            { label = Loc.new("ObjCraftStoneFurnace", "quests") }),
         qb.craft_item({ "StoneSmelter" }, 1,
            { label = Loc.new("ObjCraftStoneSmelter", "quests") }),
      },
   })

   qb.quest("PinToHotbar", {
      chapter = "OreToPower",
      label = Loc.new("PinToHotbar", "quests"),
      description = {
         Loc.new("PinToHotbarDesc1", "quests"),
         Loc.new("PinToHotbarDesc2", "quests"),
      },
      context = { "StoneFurnace", "StoneSmelter" },
      unlocks = { "BuildFirstSmelter" },
      objectives = {
         qb.hotbar_item({ "StoneFurnace", "StoneSmelter" }, { label = Loc.new("ObjPinToHotbar", "quests") }),
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
         qb.produce_item({ "CopperPlate" }, 25,
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

   local power_plant = qb.chain("PowerPlant", {
      { block = { "StoneFurnace", "CopperFurnace" }, out = "rao" },
      { block = "CopperStirlingEngine", inp = "Input1", out = "Output" },
      { block = "CopperCompactGenerator", inp = "rai", out = "rao" },
      { block = "CopperComputer", inp = "rai" },
   })

   qb.quest("BuildFirstPowerPlant", {
      chapter = "OreToPower",
      label = Loc.new("BuildFirstPowerPlant", "quests"),
      description = {
         Loc.new("BuildFirstPowerPlantDesc1", "quests"),
         Loc.new("BuildFirstPowerPlantDesc2", "quests"),
      },
      context = { "StoneFurnace", "CopperStirlingEngine", "CopperCompactGenerator", "CopperComputer" },
      unlocks = { "StartPowerPlant" },
      objectives = {
         qb.build_chain(power_plant, { label = Loc.new("ObjBuildPowerPlant", "quests") }),
      },
   })

   qb.quest("StartPowerPlant", {
      chapter = "OreToPower",
      label = Loc.new("StartPowerPlant", "quests"),
      description = {
         Loc.new("StartPowerPlantDesc1", "quests"),
         Loc.new("StartPowerPlantDesc2", "quests"),
      },
      context = { "StoneFurnace", "CopperStirlingEngine", "CopperCompactGenerator", "CopperComputer" },
      objectives = {
         qb.chain_running(power_plant, 1, { label = Loc.new("ObjPlantFurnace", "quests") }),
         qb.chain_running(power_plant, 2, { label = Loc.new("ObjPlantEngine", "quests") }),
         qb.chain_running(power_plant, 3, { label = Loc.new("ObjPlantGenerator", "quests") }),
         qb.chain_running(power_plant, 4, { states = { "working", "idle" }, label = Loc.new("ObjPlantComputer", "quests") }),
      },
      on_complete = function()
         ev01.say("ResearchComputerOnline")
      end,
   })

   qb.chapter("Automation", {
      label = Loc.new("AutomationChapter", "quests"),
      requires = { "StartPowerPlant" },
   })

   qb.quest("BuildResearchLaboratory", {
      chapter = "Automation",
      label = Loc.new("BuildResearchLaboratory", "quests"),
      description = {
         Loc.new("BuildResearchLaboratoryDesc1", "quests"),
         Loc.new("BuildResearchLaboratoryDesc2", "quests"),
      },
      context = { "CopperResearchLaboratory", "CopperComputer", "CopperCompactGenerator" },
      unlocks = { "RunExperiments" },
      objectives = {
         qb.research("ResearchLaboratory", { label = Loc.new("ObjResearchLaboratory", "quests") }),
         qb.craft_item({ "CopperResearchLaboratory" }, 1,
            { label = Loc.new("ObjCraftLaboratory", "quests") }),
         qb.build_block({ "CopperResearchLaboratory" }, 1,
            { label = Loc.new("ObjBuildLaboratory", "quests") }),
      },
   })

   qb.quest("RunExperiments", {
      chapter = "Automation",
      label = Loc.new("RunExperiments", "quests"),
      description = {
         Loc.new("RunExperimentsDesc1", "quests"),
         Loc.new("RunExperimentsDesc2", "quests"),
      },
      context = { "CopperResearchLaboratory", "CopperStirlingEngine", "Coal", "CoalOre" },
      unlocks = { "ResearchBasicMachines" },
      objectives = {
         qb.consume_item({ "CopperStirlingEngine" }, 10,
            { label = Loc.new("ObjRunMachinesExperiments", "quests") }),
      },
   })

   qb.quest("ResearchBasicMachines", {
      chapter = "Automation",
      label = Loc.new("ResearchBasicMachines", "quests"),
      description = {
         Loc.new("ResearchBasicMachinesDesc1", "quests"),
         Loc.new("ResearchBasicMachinesDesc2", "quests"),
      },
      context = { "CopperAutomaticHammer" },
      unlocks = { "ResearchAutomaticMining" },
      objectives = {
         qb.open_gui("research", { label = Loc.new("ObjOpenResearch", "quests") }),
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
      unlocks = { "BuildAutomaticMine", "BuildPortalFoundation" },
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

   qb.quest("BuildPortalFoundation", {
      chapter = "Automation",
      label = Loc.new("BuildPortalFoundation", "quests"),
      description = {
         Loc.new("BuildPortalFoundationDesc1", "quests"),
         Loc.new("BuildPortalFoundationDesc2", "quests"),
      },
      context = { "Portal", "BuildingMaterial", "StoneSurface" },
      unlocks = { "RunAutomationExperiments" },
      objectives = {
         qb.research("PortalTier0", { label = Loc.new("ObjBuildPortalFoundation", "quests") }),
      },
   })

   qb.quest("RunAutomationExperiments", {
      chapter = "Automation",
      label = Loc.new("RunAutomationExperiments", "quests"),
      description = {
         Loc.new("RunAutomationExperimentsDesc1", "quests"),
      },
      context = { "CopperResearchLaboratory", "CopperConveyor", "CopperRobotArm" },
      unlocks = { "CraftOreMultiplication" },
      objectives = {
         qb.consume_item({ "CopperConveyor" }, 10,
            { label = Loc.new("ObjRunAutomationExperiments", "quests") }),
      },
   })

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

   qb.chapter("Circuits", {
      label = Loc.new("CircuitsChapter", "quests"),
      requires = { "ResearchCircuits" },
   })

   qb.quest("BuildConstructor", {
      chapter = "Circuits",
      label = Loc.new("BuildConstructor", "quests"),
      description = {
         Loc.new("BuildConstructorDesc1", "quests"),
         Loc.new("BuildConstructorDesc2", "quests"),
      },
      context = { "CopperConstructor", "CopperWire", "CopperCompactGenerator" },
      unlocks = { "SmeltGlass" },
      objectives = {
         qb.craft_item({ "CopperConstructor" }, 1,
            { label = Loc.new("ObjCraftConstructor", "quests") }),
         qb.build_block({ "CopperConstructor" }, 1,
            { label = Loc.new("ObjBuildConstructor", "quests") }),
         qb.produce_item({ "CopperWire" }, 20,
            { label = Loc.new("ObjProduceCopperWire", "quests") }),
      },
   })

   qb.quest("SmeltGlass", {
      chapter = "Circuits",
      label = Loc.new("SmeltGlass", "quests"),
      description = { Loc.new("SmeltGlassDesc", "quests") },
      context = { "SandSurface", "Glass", "StoneSmelter" },
      unlocks = { "MachineCircuits" },
      objectives = {
         qb.collect_item({ "SandSurface" }, 20,
            { label = Loc.new("ObjMineSand", "quests") }),
         qb.produce_item({ "Glass" }, 9,
            { label = Loc.new("ObjSmeltGlass", "quests") }),
      },
   })

   qb.quest("MachineCircuits", {
      chapter = "Circuits",
      label = Loc.new("MachineCircuits", "quests"),
      description = {
         Loc.new("MachineCircuitsDesc1", "quests"),
         Loc.new("MachineCircuitsDesc2", "quests"),
      },
      context = { "CopperWire", "Triod", "CircuitBoard", "Circuit", "CopperRobotArm" },
      unlocks = { "BoostResearch" },
      objectives = {
         qb.produce_item({ "Triod" }, 9,
            { label = Loc.new("ObjProduceTriod", "quests") }),
         qb.produce_item({ "Circuit" }, 3,
            { label = Loc.new("ObjProduceCircuit", "quests") }),
      },
   })

   qb.quest("BoostResearch", {
      chapter = "Circuits",
      label = Loc.new("BoostResearch", "quests"),
      description = {
         Loc.new("BoostResearchDesc1", "quests"),
         Loc.new("BoostResearchDesc2", "quests"),
      },
      context = { "CopperComputer", "Circuit", "CopperRobotArm" },
      unlocks = { "QueueResearch" },
      objectives = {
         qb.consume_item({ "Circuit" }, 3,
            { label = Loc.new("ObjBoostComputer", "quests") }),
      },
   })

   qb.quest("QueueResearch", {
      chapter = "Circuits",
      label = Loc.new("QueueResearch", "quests"),
      description = {
         Loc.new("QueueResearchDesc1", "quests"),
         Loc.new("QueueResearchDesc2", "quests"),
      },
      context = { "CopperOven", "CopperBlastFurnace" },
      objectives = {
         qb.research("Oven", { label = Loc.new("ObjResearchOven", "quests") }),
         qb.research("SteelProduction", { label = Loc.new("ObjResearchSteelProduction", "quests") }),
      },
   })

   qb.chapter("Steel", {
      label = Loc.new("SteelChapter", "quests"),
      requires = { "QueueResearch" },
   })

   qb.quest("AutomateFuel", {
      chapter = "Steel",
      label = Loc.new("AutomateFuel", "quests"),
      description = {
         Loc.new("AutomateFuelDesc1", "quests"),
         Loc.new("AutomateFuelDesc2", "quests"),
         Loc.new("AutomateFuelDesc3", "quests"),
      },
      context = { "CopperDrillingRig", "CoalOre", "CopperAutomaticFarm", "Log", "CopperPump", "CopperAtmosphericCondenser" },
      unlocks = { "MakeCoke" },
      any = true,
      objectives = {
         qb.produce_item({ "CoalOre" }, 20,
            { label = Loc.new("ObjDrillCoalOre", "quests") }),
         qb.produce_item({ "Log" }, 20,
            { label = Loc.new("ObjFarmLogs", "quests") }),
      },
   })

   qb.quest("MakeCoke", {
      chapter = "Steel",
      label = Loc.new("MakeCoke", "quests"),
      description = {
         Loc.new("MakeCokeDesc1", "quests"),
         Loc.new("MakeCokeDesc2", "quests"),
         Loc.new("MakeCokeDesc3", "quests"),
      },
      context = { "CopperOven", "CopperFurnace", "Coke", "Creosote", "CopperPump", "CopperFluidFurnace", "CopperDestroyer" },
      unlocks = { "MineIron" },
      objectives = {
         qb.produce_item({ "Coke" }, 10,
            { label = Loc.new("ObjProduceCoke", "quests") }),
      },
   })

   qb.quest("MineIron", {
      chapter = "Steel",
      label = Loc.new("MineIron", "quests"),
      description = {
         Loc.new("MineIronDesc1", "quests"),
         Loc.new("MineIronDesc2", "quests"),
      },
      context = { "MagnetiteOre", "PyriteOre", "CopperDrillingRig", "IronPlate" },
      unlocks = { "SmeltSteel" },
      objectives = {
         qb.produce_item({ "IronPlate" }, 10,
            { label = Loc.new("ObjSmeltIronPlate", "quests") }),
      },
   })

   qb.quest("SmeltSteel", {
      chapter = "Steel",
      label = Loc.new("SmeltSteel", "quests"),
      description = {
         Loc.new("SmeltSteelDesc1", "quests"),
      },
      context = { "CopperBlastFurnace", "IronPlate", "Coke", "SteelPlate" },
      unlocks = { "SteamIndustry" },
      objectives = {
         qb.produce_item({ "SteelPlate" }, 10,
            { label = Loc.new("ObjSmeltSteelPlate", "quests") }),
      },
   })

   qb.quest("SteamIndustry", {
      chapter = "Steel",
      label = Loc.new("SteamIndustry", "quests"),
      description = {
         Loc.new("SteamIndustryDesc1", "quests"),
         Loc.new("SteamIndustryDesc2", "quests"),
         Loc.new("SteamIndustryDesc3", "quests"),
      },
      context = { "SteelBoiler", "SteelSteamEngine", "SteelCompactGenerator", "Steam", "Resistor", "AdvancedCircuit" },
      unlocks = { "AdvancedCircuits" },
      objectives = {
         qb.research("Boiler", { label = Loc.new("ObjResearchBoiler", "quests") }),
         qb.research("SteamEngine", { label = Loc.new("ObjResearchSteamEngine", "quests") }),
         qb.research("Resistor", { label = Loc.new("ObjResearchResistor", "quests") }),
         qb.research("AdvancedCircuit", { label = Loc.new("ObjResearchAdvancedCircuit", "quests") }),
      },
   })

   qb.quest("AdvancedCircuits", {
      chapter = "Steel",
      label = Loc.new("AdvancedCircuits", "quests"),
      description = {
         Loc.new("AdvancedCircuitsDesc1", "quests"),
         Loc.new("AdvancedCircuitsDesc2", "quests"),
         Loc.new("AdvancedCircuitsDesc3", "quests"),
      },
      context = { "AdvancedCircuit", "CircuitBoard", "Resistor", "Circuit", "CopperConstructor", "SteelComputer" },
      unlocks = { "ResearchAluminium" },
      objectives = {
         qb.research("Dynamo", { label = Loc.new("ObjResearchDistributedComputing1", "quests") }),
         qb.produce_item({ "AdvancedCircuit" }, 3,
            { label = Loc.new("ObjProduceAdvancedCircuit", "quests") }),
      },
   })

   qb.quest("ResearchAluminium", {
      chapter = "Steel",
      label = Loc.new("ResearchAluminium", "quests"),
      description = {
         Loc.new("ResearchAluminiumDesc1", "quests"),
      },
      context = { "SteelElectrolyzer", "SteelArcSmelter", "AluminiumPlate" },
      objectives = {
         qb.research("AluminiumProduction", { label = Loc.new("ObjResearchAluminiumProduction", "quests") }),
      },
   })

   qb.chapter("Aluminium", {
      label = Loc.new("AluminiumChapter", "quests"),
      requires = { "ResearchAluminium" },
   })

   qb.quest("MineAluminiumOre", {
      chapter = "Aluminium",
      label = Loc.new("MineAluminiumOre", "quests"),
      description = {
         Loc.new("MineAluminiumOreDesc1", "quests"),
      },
      context = { "BauxiteOre", "RubyOre", "CopperDrillingRig" },
      unlocks = { "ProcessAluminiumOre" },
      objectives = {
         qb.produce_item({ "BauxiteOre", "RubyOre" }, 20,
            { label = Loc.new("ObjDrillAluminiumOre", "quests") }),
      },
   })

   qb.quest("ProcessAluminiumOre", {
      chapter = "Aluminium",
      label = Loc.new("ProcessAluminiumOre", "quests"),
      description = {
         Loc.new("ProcessAluminiumOreDesc1", "quests"),
         Loc.new("ProcessAluminiumOreDesc2", "quests"),
      },
      context = { "BauxiteDust", "RubyDust", "CopperSmelter", "CopperAutomaticHammer", "CopperMacerator", "SteelSeparator" },
      unlocks = { "Electrolysis" },
      objectives = {
         qb.produce_item({ "BauxiteDust", "RubyDust" }, 24,
            { label = Loc.new("ObjProduceAluminiumOreDust", "quests") }),
      },
   })

   qb.quest("Electrolysis", {
      chapter = "Aluminium",
      label = Loc.new("Electrolysis", "quests"),
      description = {
         Loc.new("ElectrolysisDesc1", "quests"),
         Loc.new("ElectrolysisDesc2", "quests"),
         Loc.new("ElectrolysisDesc3", "quests"),
      },
      context = { "SteelElectrolyzer", "AluminiumOxideDust", "AluminiumDust", "Oxygen", "CopperPump", "CopperDestroyer", "CopperLoader", "SteelSorter", "CopperItemRack" },
      objectives = {
         qb.produce_item({ "AluminiumDust" }, 12,
            { label = Loc.new("ObjProduceAluminiumDust", "quests") }),
      },
   })

   qb.build()
   ev01.listen()
end

function VanillaQuestsMod.post_init()
end

db:mod(VanillaQuestsMod)
