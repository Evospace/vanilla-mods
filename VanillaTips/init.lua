local VanillaTipsMod = {}

function VanillaTipsMod.init()
    db:from_table({
        class = "StaticTip",
        name = "Accessors1",
        label = {"Accessors1", "tips"},
        description = {"Accessors1Description", "tips"},
        image = "Accessors1.png",
        context = {items = {"CopperStirlingEngineStaticItem", "CopperConnectorStaticItem", "CopperHeatPipeStaticItem", "SteelFlywheelStaticItem", "ElectricityStaticItem", "KineticStaticItem", "HeatStaticItem"}}
    })

    db:from_table({
        class = "StaticTip",
        name = "Screwdriver",
        label = {"Screwdriver", "tips"},
        description = {"ScrewdriverDescription", "tips"},
        image = "Screwdriver.png",
        context = {items = {"ScrewdriverStaticItem"}}
    })

    db:from_table({
        class = "StaticTip",
        name = "RotationWhileBuilding",
        label = {"RotationWhileBuilding", "tips"},
        description = {"RotationWhileBuildingDescription", "tips"},
        image = "Rotation.png"
    })

    db:from_table({
        class = "StaticTip",
        name = "BlockPipette",
        label = {"BlockPipette", "tips"},
        description = {"BlockPipetteDescription", "tips"},
        image = "Pipette.png"
    })

    db:from_table({
        class = "StaticTip",
        name = "StackTransfers",
        label = {"StackTransfers", "tips"},
        description = {"StackTransfersDescription", "tips"},
        image = "StackTransfers.png"
    })
end

function VanillaTipsMod.pre_init()
end

function VanillaTipsMod.post_init()
end

db:mod(VanillaTipsMod)