local VanillaTipsMod = {}

function VanillaTipsMod.init()
    local i_first = AutosizeInventory.new_simple()
    i_first:add(StaticItem.find("CopperOre"), 1)
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
        description = Loc.new("FirstStepsDescription", "tips"),
        image = "Textures/FirstSteps.png",
        context = i_first
    })

    local i_acc = AutosizeInventory.new_simple()
    i_acc:add(StaticItem.find("CopperStirlingEngine"), 1)
    i_acc:add(StaticItem.find("CopperConnector"), 10)
    i_acc:add(StaticItem.find("CopperHeatPipe"), 1)
    i_acc:add(StaticItem.find("SteelFlywheel"), 1)
    i_acc:add(StaticItem.find("LV"), 1)
    i_acc:add(StaticItem.find("Kinetic"), 1)
    i_acc:add(StaticItem.find("Heat"), 1)
    db:from_table({
        class = "StaticTip",
        name = "Accessors1",
        label = Loc.new("Accessors1", "tips"),
        description = Loc.new("Accessors1Description", "tips"),
        image = "Textures/Accessors1.png",
        context = i_acc
    })

    local i_scr = AutosizeInventory.new_simple()
    i_scr:add(StaticItem.find("Screwdriver"), 1)
    db:from_table({
        class = "StaticTip",
        name = "Screwdriver",
        label = Loc.new("Screwdriver", "tips"),
        description = Loc.new("ScrewdriverDescription", "tips"),
        image = "Textures/Screwdriver.png",
        context = i_scr
    })

    db:from_table({
        class = "StaticTip",
        name = "RotationWhileBuilding",
        label = Loc.new("RotationWhileBuilding", "tips"),
        description = Loc.new("RotationWhileBuildingDescription", "tips"),
        image = "Textures/Rotation.png"
    })

    db:from_table({
        class = "StaticTip",
        name = "BlockPipette",
        label = Loc.new("BlockPipette", "tips"),
        description = Loc.new("BlockPipetteDescription", "tips"),
        image = "Textures/Pipette.png"
    })

    db:from_table({
        class = "StaticTip",
        name = "StackTransfers",
        label = Loc.new("StackTransfers", "tips"),
        description = Loc.new("StackTransfersDescription", "tips"),
        image = "Textures/StackTransfers.png"
    })
end

function VanillaTipsMod.pre_init()
end

function VanillaTipsMod.post_init()
end

db:mod(VanillaTipsMod)