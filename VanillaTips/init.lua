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

    db:from_table({
        class = "StaticTip",
        name = "Research",
        label = Loc.new("Research", "tips"),
        description_parts = {Loc.new("ResearchDescription", "tips")},
        image = "Textures/Research.png"
    })

    local i_comp = AutosizeInventory.new_simple()
    i_comp:add(StaticItem.find("CopperComputer"), 1)
    i_comp:add(StaticItem.find("Circuit"), 3)
    i_comp:add(StaticItem.find("SteelComputer"), 1)
    i_comp:add(StaticItem.find("AdvancedCircuit"), 3)
    i_comp:add(StaticItem.find("Electricity"), 1)
    db:from_table({
        class = "StaticTip",
        name = "ResearchComputers",
        label = Loc.new("ResearchComputers", "tips"),
        description_parts = {
            Loc.new("ResearchComputersDescription1", "tips"),
            Loc.new("ResearchComputersDescription2", "tips"),
            Loc.new("ResearchComputersDescription3", "tips"),
            Loc.new("ResearchComputersDescription4", "tips")
        },
        context = i_comp
    })

    local i_acc = AutosizeInventory.new_simple()
    i_acc:add(StaticItem.find("CopperStirlingEngine"), 1)
    i_acc:add(StaticItem.find("CopperConnector"), 10)
    i_acc:add(StaticItem.find("CopperHeatPipe"), 1)
    i_acc:add(StaticItem.find("SteelFlywheel"), 1)
    i_acc:add(StaticItem.find("Electricity"), 1)
    i_acc:add(StaticItem.find("Kinetic"), 1)
    i_acc:add(StaticItem.find("Heat"), 1)
    db:from_table({
        class = "StaticTip",
        name = "Accessors1",
        label = Loc.new("Accessors1", "tips"),
        description_parts = {Loc.new("Accessors1Description", "tips")},
        image = "Textures/Accessors1.png",
        context = i_acc
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
end

function VanillaTipsMod.pre_init()
end

function VanillaTipsMod.post_init()
end

db:mod(VanillaTipsMod)