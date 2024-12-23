local VanillaTipsMod = {}

function VanillaTipsMod.init()
    local i = AutosizeInventory.new_simple()
    i:add(StaticItem.find("CopperOre"), 1)
    i:add(StaticItem.find("BasicPlatform"), 1)
    i:add(StaticItem.find("StoneSmelter"), 1)
    i:add(StaticItem.find("StoneFurnace"), 1)
    i:add(StaticItem.find("CopperStirlingEngine"), 1)
    i:add(StaticItem.find("CopperCompactGenerator"), 1)
    i:add(StaticItem.find("CopperComputer"), 1)
    db:from_table({
        class = "StaticTip",
        name = "FirstSteps",
        label = Loc.new("FirstSteps", "tips"),
        description = Loc.new("FirstStepsDescription", "tips"),
        image = "Textures/FirstSteps.png",
        context = i
    })

    local i = AutosizeInventory.new_simple()
    i:add(StaticItem.find("CopperStirlingEngine"), 1)
    i:add(StaticItem.find("CopperConnector"), 10)
    i:add(StaticItem.find("CopperHeatPipe"), 1)
    i:add(StaticItem.find("SteelFlywheel"), 1)
    i:add(StaticItem.find("Electricity"), 1)
    i:add(StaticItem.find("Kinetic"), 1)
    i:add(StaticItem.find("Heat"), 1)
    db:from_table({
        class = "StaticTip",
        name = "Accessors1",
        label = Loc.new("Accessors1", "tips"),
        description = Loc.new("Accessors1Description", "tips"),
        image = "Textures/Accessors1.png",
        context = i
    })

    local i = AutosizeInventory.new_simple()
    i:add(StaticItem.find("Screwdriver"), 1)
    db:from_table({
        class = "StaticTip",
        name = "Screwdriver",
        label = Loc.new("Screwdriver", "tips"),
        description = Loc.new("ScrewdriverDescription", "tips"),
        image = "Textures/Screwdriver.png",
        context = i
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