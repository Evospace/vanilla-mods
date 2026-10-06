local VanillaTipsMod = {}

function VanillaTipsMod.init()
    local i_hud = AutosizeInventory.new_simple()
    i_hud:add(StaticItem.find("Multitool"), 1)
    i_hud:add(StaticItem.find("Screwdriver"), 1)
    i_hud:add(StaticItem.find("StoneFurnace"), 1)
    db:from_table({
        class = "StaticTip",
        name = "Interface",
        label = Loc.new("Interface", "tips"),
        description_parts = {
            Loc.new("InterfaceDescription1", "tips"),
            Loc.new("InterfaceDescription2", "tips"),
            Loc.new("InterfaceDescription3", "tips"),
            Loc.new("InterfaceDescription4", "tips"),
            Loc.new("InterfaceDescription5", "tips"),
            Loc.new("InterfaceDescription6", "tips"),
            Loc.new("InterfaceDescription7", "tips")
        },
        image = "Textures/Hud.png",
        context = i_hud
    })

    db:from_table({
        class = "StaticTip",
        name = "Map",
        label = Loc.new("Map", "tips"),
        description_parts = {Loc.new("MapDescription", "tips")},
        image = "Textures/Map.png"
    })

    local i_first = AutosizeInventory.new_simple()
    i_first:add(StaticItem.find("ChalcopyriteOre"), 1)
    i_first:add(StaticItem.find("MalachiteOre"), 1)
    i_first:add(StaticItem.find("BasicPlatform"), 1)
    i_first:add(StaticItem.find("StoneSmelter"), 1)
    i_first:add(StaticItem.find("StoneFurnace"), 1)
    i_first:add(StaticItem.find("CopperStirlingEngine"), 1)
    i_first:add(StaticItem.find("CopperCompactGenerator"), 1)
    i_first:add(StaticItem.find("CopperComputer"), 1)
    db:from_table({
        class = "StaticTip",
        name = "FirstSteps",
        label = Loc.new("FirstSteps", "tips"),
        description_parts = {Loc.new("FirstStepsDescription", "tips")},
        image = "Textures/FirstSteps.png",
        context = i_first
    })

    local i_comp = AutosizeInventory.new_simple()
    i_comp:add(StaticItem.find("CopperComputer"), 1)
    i_comp:add(StaticItem.find("Circuit"), 3)
    i_comp:add(StaticItem.find("SteelComputer"), 1)
    i_comp:add(StaticItem.find("AdvancedCircuit"), 3)
    i_comp:add(StaticItem.find("Electricity"), 1)
    db:from_table({
        class = "StaticTip",
        name = "Research",
        label = Loc.new("Research", "tips"),
        description_parts = {
            Loc.new("ResearchDescription", "tips"),
            Loc.new("ResearchDescription1", "tips"),
            Loc.new("ResearchDescription2", "tips"),
            Loc.new("ResearchDescription3", "tips"),
            Loc.new("ResearchComputersDescription1", "tips"),
            Loc.new("ResearchComputersDescription2", "tips"),
            Loc.new("ResearchComputersDescription3", "tips"),
            Loc.new("ResearchComputersDescription4", "tips"),
            Loc.new("ResearchComputersDescription5", "tips")
        },
        image = "Textures/Research.png",
        context = i_comp
    })

    local i_prod = AutosizeInventory.new_simple()
    i_prod:add(StaticItem.find("CopperAutomaticHammer"), 1)
    i_prod:add(StaticItem.find("CopperMacerator"), 1)
    i_prod:add(StaticItem.find("ChalcopyriteOre"), 1)
    i_prod:add(StaticItem.find("ChalcopyriteOreImpureGravel"), 1)
    i_prod:add(StaticItem.find("ChalcopyriteOreDust"), 1)
    i_prod:add(StaticItem.find("CopperPlate"), 1)
    db:from_table({
        class = "StaticTip",
        name = "Productivity",
        label = Loc.new("Productivity", "tips"),
        description_parts = {
            Loc.new("ProductivityDescription1", "tips"),
            Loc.new("ProductivityDescription2", "tips")
        },
        context = i_prod
    })

    local i_scr = AutosizeInventory.new_simple()
    i_scr:add(StaticItem.find("Screwdriver"), 1)
    db:from_table({
        class = "StaticTip",
        name = "Screwdriver",
        label = Loc.new("Screwdriver", "tips"),
        description_parts = {Loc.new("ScrewdriverDescription", "tips")},
        image = "Textures/Screwdriver.png",
        context = i_scr
    })

    local i_modes = AutosizeInventory.new_simple()
    i_modes:add(StaticItem.find("StoneFurnace"), 1)
    i_modes:add(StaticItem.find("BasicPlatform"), 1)
    i_modes:add(StaticItem.find("CopperConveyor"), 1)
    i_modes:add(StaticItem.find("CopperPipe"), 1)
    i_modes:add(StaticItem.find("CopperConnector"), 1)
    db:from_table({
        class = "StaticTip",
        name = "BuildingModes",
        label = Loc.new("BuildingModes", "tips"),
        description_parts = {
            Loc.new("BuildingModesDescription1", "tips"),
            Loc.new("BuildingModesDescription2", "tips"),
            Loc.new("BuildingModesDescription3", "tips")
        },
        context = i_modes
    })

    db:from_table({
        class = "StaticTip",
        name = "RotationWhileBuilding",
        label = Loc.new("RotationWhileBuilding", "tips"),
        description_parts = {Loc.new("RotationWhileBuildingDescription", "tips")},
        image = "Textures/Rotation.png"
    })

    db:from_table({
        class = "StaticTip",
        name = "BlockPipette",
        label = Loc.new("BlockPipette", "tips"),
        description_parts = {Loc.new("BlockPipetteDescription", "tips")},
        image = "Textures/Pipette.png"
    })

    db:from_table({
        class = "StaticTip",
        name = "StackTransfers",
        label = Loc.new("StackTransfers", "tips"),
        description_parts = {Loc.new("StackTransfersDescription", "tips")},
        image = "Textures/StackTransfers.png"
    })

    local i_db = AutosizeInventory.new_simple()
    i_db:add(StaticItem.find("StoneFurnace"), 1)
    i_db:add(StaticItem.find("StoneSmelter"), 1)
    db:from_table({
        class = "StaticTip",
        name = "ItemDatabase",
        label = Loc.new("ItemDatabase", "tips"),
        description_parts = {
            Loc.new("ItemDatabaseDescription1", "tips"),
            Loc.new("ItemDatabaseDescription2", "tips"),
            Loc.new("ItemDatabaseDescription3", "tips"),
            Loc.new("ItemDatabaseDescription4", "tips")
        },
        image = "Textures/ItemDatabase.png",
        context = i_db
    })

    local i_recipes = AutosizeInventory.new_simple()
    i_recipes:add(StaticItem.find("CopperPlate"), 1)
    i_recipes:add(StaticItem.find("StoneSmelter"), 1)
    i_recipes:add(StaticItem.find("CopperStirlingEngine"), 1)
    db:from_table({
        class = "StaticTip",
        name = "Recipes",
        label = Loc.new("Recipes", "tips"),
        description_parts = {
            Loc.new("RecipesDescription1", "tips"),
            Loc.new("RecipesDescription2", "tips")
        },
        context = i_recipes
    })

    db:from_table({
        class = "StaticTip",
        name = "CraftQueue",
        label = Loc.new("CraftQueue", "tips"),
        description_parts = {
            Loc.new("CraftQueueDescription1", "tips"),
            Loc.new("CraftQueueDescription2", "tips")
        }
    })

    local i_energy = AutosizeInventory.new_simple()
    i_energy:add(StaticItem.find("StoneFurnace"), 1)
    i_energy:add(StaticItem.find("CopperStirlingEngine"), 1)
    i_energy:add(StaticItem.find("CopperCompactGenerator"), 1)
    i_energy:add(StaticItem.find("CopperComputer"), 1)
    i_energy:add(StaticItem.find("CopperConnector"), 1)
    i_energy:add(StaticItem.find("CopperHeatPipe"), 1)
    i_energy:add(StaticItem.find("SteelFlywheel"), 1)
    i_energy:add(StaticItem.find("Heat"), 1)
    i_energy:add(StaticItem.find("Kinetic"), 1)
    i_energy:add(StaticItem.find("Electricity"), 1)
    db:from_table({
        class = "StaticTip",
        name = "Energy",
        label = Loc.new("Energy", "tips"),
        description_parts = {
            Loc.new("EnergyDescription1", "tips"),
            Loc.new("EnergyDescription2", "tips"),
            Loc.new("DockingDescription1", "tips"),
            Loc.new("DockingDescription2", "tips"),
            Loc.new("DockingDescription3", "tips")
        },
        image = "Textures/Energy.png",
        context = i_energy
    })

    local i_power = AutosizeInventory.new_simple()
    i_power:add(StaticItem.find("StoneFurnace"), 1)
    i_power:add(StaticItem.find("CopperComputer"), 1)
    db:from_table({
        class = "StaticTip",
        name = "NoPower",
        label = Loc.new("NoPower", "tips"),
        description_parts = {
            Loc.new("NoPowerDescription1", "tips"),
            Loc.new("NoPowerDescription2", "tips"),
            Loc.new("NoPowerDescription3", "tips")
        },
        context = i_power
    })

    local i_ctor = AutosizeInventory.new_simple()
    i_ctor:add(StaticItem.find("CopperConstructor"), 1)
    i_ctor:add(StaticItem.find("CopperRobotArm"), 1)
    i_ctor:add(StaticItem.find("CopperWire"), 1)
    i_ctor:add(StaticItem.find("Triod"), 1)
    i_ctor:add(StaticItem.find("CircuitBoard"), 1)
    i_ctor:add(StaticItem.find("Circuit"), 1)
    db:from_table({
        class = "StaticTip",
        name = "Constructor",
        label = Loc.new("Constructor", "tips"),
        description_parts = {
            Loc.new("ConstructorDescription1", "tips"),
            Loc.new("ConstructorDescription2", "tips"),
            Loc.new("ConstructorDescription3", "tips"),
            Loc.new("ConstructorDescription4", "tips"),
            Loc.new("ConstructorDescription5", "tips"),
            Loc.new("ConstructorDescription6", "tips"),
            Loc.new("ConstructorDescription7", "tips")
        },
        image = "Textures/Constructor.png",
        context = i_ctor
    })
end

function VanillaTipsMod.pre_init()
end

function VanillaTipsMod.post_init()
end

db:mod(VanillaTipsMod)