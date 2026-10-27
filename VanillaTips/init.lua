local VanillaTipsMod = {}

function VanillaTipsMod.init()
    local i_hud = AutosizeInventory.new_simple()
    i_hud.draggable = false
    i_hud:add(StaticItem.find("Multitool"), 1)
    i_hud:add(StaticItem.find("Screwdriver"), 1)
    i_hud:add(StaticItem.find("StoneFurnace"), 1)
    local interface = StaticTip.reg("Interface", {
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

    StaticTip.reg("Map", {
        label = Loc.new("Map", "tips"),
        parent = interface,
        description_parts = {Loc.new("MapDescription", "tips")},
        image = "Textures/Map.png"
    })

    local i_first = AutosizeInventory.new_simple()
    i_first.draggable = false
    i_first:add(StaticItem.find("ChalcopyriteOre"), 1)
    i_first:add(StaticItem.find("MalachiteOre"), 1)
    i_first:add(StaticItem.find("BasicPlatform"), 1)
    i_first:add(StaticItem.find("StoneSmelter"), 1)
    i_first:add(StaticItem.find("StoneFurnace"), 1)
    i_first:add(StaticItem.find("CopperStirlingEngine"), 1)
    i_first:add(StaticItem.find("CopperCompactGenerator"), 1)
    i_first:add(StaticItem.find("CopperComputer"), 1)
    StaticTip.reg("FirstSteps", {
        label = Loc.new("FirstSteps", "tips"),
        description_parts = {Loc.new("FirstStepsDescription", "tips")},
        image = "Textures/FirstSteps.png",
        context = i_first
    })

    local i_comp = AutosizeInventory.new_simple()
    i_comp.draggable = false
    i_comp:add(StaticItem.find("CopperComputer"), 1)
    i_comp:add(StaticItem.find("Circuit"), 3)
    i_comp:add(StaticItem.find("SteelComputer"), 1)
    i_comp:add(StaticItem.find("AdvancedCircuit"), 3)
    i_comp:add(StaticItem.find("Electricity"), 1)
    StaticTip.reg("Research", {
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
    i_prod.draggable = false
    i_prod:add(StaticItem.find("CopperAutomaticHammer"), 1)
    i_prod:add(StaticItem.find("CopperMacerator"), 1)
    i_prod:add(StaticItem.find("ChalcopyriteOre"), 1)
    i_prod:add(StaticItem.find("ChalcopyriteOreImpureGravel"), 1)
    i_prod:add(StaticItem.find("ChalcopyriteOreDust"), 1)
    i_prod:add(StaticItem.find("CopperPlate"), 1)
    StaticTip.reg("Productivity", {
        label = Loc.new("Productivity", "tips"),
        description_parts = {
            Loc.new("ProductivityDescription1", "tips"),
            Loc.new("ProductivityDescription2", "tips")
        },
        context = i_prod
    })

    local i_modes = AutosizeInventory.new_simple()
    i_modes.draggable = false
    i_modes:add(StaticItem.find("StoneFurnace"), 1)
    i_modes:add(StaticItem.find("BasicPlatform"), 1)
    i_modes:add(StaticItem.find("CopperConveyor"), 1)
    i_modes:add(StaticItem.find("CopperPipe"), 1)
    i_modes:add(StaticItem.find("CopperConnector"), 1)
    local building = StaticTip.reg("BuildingModes", {
        label = Loc.new("BuildingModes", "tips"),
        description_parts = {
            Loc.new("BuildingModesDescription1", "tips"),
            Loc.new("BuildingModesDescription2", "tips"),
            Loc.new("BuildingModesDescription3", "tips")
        },
        context = i_modes
    })

    local i_scr = AutosizeInventory.new_simple()
    i_scr.draggable = false
    i_scr:add(StaticItem.find("Screwdriver"), 1)
    StaticTip.reg("Screwdriver", {
        label = Loc.new("Screwdriver", "tips"),
        parent = building,
        description_parts = {Loc.new("ScrewdriverDescription", "tips")},
        image = "Textures/Screwdriver.png",
        context = i_scr
    })

    StaticTip.reg("RotationWhileBuilding", {
        label = Loc.new("RotationWhileBuilding", "tips"),
        parent = building,
        description_parts = {Loc.new("RotationWhileBuildingDescription", "tips")},
        image = "Textures/Rotation.png"
    })

    StaticTip.reg("BlockPipette", {
        label = Loc.new("BlockPipette", "tips"),
        parent = building,
        description_parts = {Loc.new("BlockPipetteDescription", "tips")},
        image = "Textures/Pipette.png"
    })

    StaticTip.reg("StackTransfers", {
        label = Loc.new("StackTransfers", "tips"),
        parent = interface,
        description_parts = {Loc.new("StackTransfersDescription", "tips")},
        image = "Textures/StackTransfers.png"
    })

    local i_db = AutosizeInventory.new_simple()
    i_db.draggable = false
    i_db:add(StaticItem.find("StoneFurnace"), 1)
    i_db:add(StaticItem.find("StoneSmelter"), 1)
    StaticTip.reg("ItemDatabase", {
        label = Loc.new("ItemDatabase", "tips"),
        parent = interface,
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
    i_recipes.draggable = false
    i_recipes:add(StaticItem.find("CopperPlate"), 1)
    i_recipes:add(StaticItem.find("StoneSmelter"), 1)
    i_recipes:add(StaticItem.find("CopperStirlingEngine"), 1)
    StaticTip.reg("Recipes", {
        label = Loc.new("Recipes", "tips"),
        parent = interface,
        description_parts = {
            Loc.new("RecipesDescription1", "tips"),
            Loc.new("RecipesDescription2", "tips")
        },
        context = i_recipes
    })

    StaticTip.reg("CraftQueue", {
        label = Loc.new("CraftQueue", "tips"),
        parent = interface,
        description_parts = {
            Loc.new("CraftQueueDescription1", "tips"),
            Loc.new("CraftQueueDescription2", "tips")
        }
    })

    local i_energy = AutosizeInventory.new_simple()
    i_energy.draggable = false
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
    local energy = StaticTip.reg("Energy", {
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
    i_power.draggable = false
    i_power:add(StaticItem.find("StoneFurnace"), 1)
    i_power:add(StaticItem.find("CopperComputer"), 1)
    StaticTip.reg("NoPower", {
        label = Loc.new("NoPower", "tips"),
        parent = energy,
        description_parts = {
            Loc.new("NoPowerDescription1", "tips"),
            Loc.new("NoPowerDescription2", "tips"),
            Loc.new("NoPowerDescription3", "tips")
        },
        context = i_power
    })

    local i_ctor = AutosizeInventory.new_simple()
    i_ctor.draggable = false
    i_ctor:add(StaticItem.find("CopperConstructor"), 1)
    i_ctor:add(StaticItem.find("CopperRobotArm"), 1)
    i_ctor:add(StaticItem.find("CopperWire"), 1)
    i_ctor:add(StaticItem.find("Triod"), 1)
    i_ctor:add(StaticItem.find("CircuitBoard"), 1)
    i_ctor:add(StaticItem.find("Circuit"), 1)
    StaticTip.reg("Constructor", {
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

    local i_trains = AutosizeInventory.new_simple()
    i_trains.draggable = false
    i_trains:add(StaticItem.find("SteelRail"), 1)
    i_trains:add(StaticItem.find("RailStation"), 1)
    i_trains:add(StaticItem.find("Locomotive"), 1)
    i_trains:add(StaticItem.find("CargoWagon"), 1)
    i_trains:add(StaticItem.find("TankWagon"), 1)
    i_trains:add(StaticItem.find("RailSignal"), 1)
    i_trains:add(StaticItem.find("RailChainSignal"), 1)
    local trains = StaticTip.reg("Trains", {
        label = Loc.new("Trains", "tips"),
        description_parts = {
            Loc.new("TrainsDescription1", "tips"),
            Loc.new("TrainsDescription2", "tips"),
            Loc.new("TrainsDescription3", "tips")
        },
        image = "Textures/Trains.png",
        context = i_trains
    })

    local i_rails = AutosizeInventory.new_simple()
    i_rails.draggable = false
    i_rails:add(StaticItem.find("SteelRail"), 1)
    StaticTip.reg("TrainsRails", {
        label = Loc.new("TrainsRails", "tips"),
        parent = trains,
        description_parts = {
            Loc.new("TrainsRailsDescription1", "tips"),
            Loc.new("TrainsRailsDescription2", "tips"),
            Loc.new("TrainsRailsDescription3", "tips"),
            Loc.new("TrainsRailsDescription4", "tips"),
            Loc.new("TrainsRailsDescription5", "tips"),
            Loc.new("TrainsRailsDescription6", "tips")
        },
        image = "Textures/TrainsRails.png",
        context = i_rails
    })

    local i_stations = AutosizeInventory.new_simple()
    i_stations.draggable = false
    i_stations:add(StaticItem.find("RailStation"), 1)
    i_stations:add(StaticItem.find("CopperLoader"), 1)
    i_stations:add(StaticItem.find("CopperRobotArm"), 1)
    i_stations:add(StaticItem.find("CopperPump"), 1)
    StaticTip.reg("TrainsStations", {
        label = Loc.new("TrainsStations", "tips"),
        parent = trains,
        description_parts = {
            Loc.new("TrainsStationsDescription1", "tips"),
            Loc.new("TrainsStationsDescription2", "tips"),
            Loc.new("TrainsStationsDescription3", "tips"),
            Loc.new("TrainsStationsDescription4", "tips"),
            Loc.new("TrainsStationsDescription5", "tips"),
            Loc.new("TrainsStationsDescription6", "tips"),
            Loc.new("TrainsStationsDescription7", "tips"),
            Loc.new("TrainsStationsDescription8", "tips"),
            Loc.new("TrainsStationsDescription9", "tips"),
            Loc.new("TrainsStationsDescription10", "tips")
        },
        image = "Textures/TrainsStations.png",
        context = i_stations
    })

    local i_consist = AutosizeInventory.new_simple()
    i_consist.draggable = false
    i_consist:add(StaticItem.find("Locomotive"), 1)
    i_consist:add(StaticItem.find("CargoWagon"), 1)
    i_consist:add(StaticItem.find("TankWagon"), 1)
    StaticTip.reg("TrainsConsist", {
        label = Loc.new("TrainsConsist", "tips"),
        parent = trains,
        description_parts = {
            Loc.new("TrainsConsistDescription1", "tips"),
            Loc.new("TrainsConsistDescription2", "tips"),
            Loc.new("TrainsConsistDescription3", "tips"),
            Loc.new("TrainsConsistDescription4", "tips"),
            Loc.new("TrainsConsistDescription5", "tips"),
            Loc.new("TrainsConsistDescription6", "tips"),
            Loc.new("TrainsConsistDescription7", "tips"),
            Loc.new("TrainsConsistDescription8", "tips"),
            Loc.new("TrainsConsistDescription9", "tips"),
            Loc.new("TrainsConsistDescription10", "tips")
        },
        image = "Textures/TrainsConsist.png",
        context = i_consist
    })

    StaticTip.reg("TrainsSchedule", {
        label = Loc.new("TrainsSchedule", "tips"),
        parent = trains,
        description_parts = {
            Loc.new("TrainsScheduleDescription1", "tips"),
            Loc.new("TrainsScheduleDescription2", "tips"),
            Loc.new("TrainsScheduleDescription3", "tips"),
            Loc.new("TrainsScheduleDescription4", "tips"),
            Loc.new("TrainsScheduleDescription5", "tips"),
            Loc.new("TrainsScheduleDescription6", "tips"),
            Loc.new("TrainsScheduleDescription7", "tips"),
            Loc.new("TrainsScheduleDescription8", "tips"),
            Loc.new("TrainsScheduleDescription9", "tips"),
            Loc.new("TrainsScheduleDescription10", "tips"),
            Loc.new("TrainsScheduleDescription11", "tips")
        },
        image = "Textures/TrainsSchedule.png"
    })

    StaticTip.reg("TrainsConditions", {
        label = Loc.new("TrainsConditions", "tips"),
        parent = trains,
        description_parts = {
            Loc.new("TrainsConditionsDescription1", "tips"),
            Loc.new("TrainsConditionsDescription2", "tips"),
            Loc.new("TrainsConditionsDescription3", "tips"),
            Loc.new("TrainsConditionsDescription4", "tips"),
            Loc.new("TrainsConditionsDescription5", "tips"),
            Loc.new("TrainsConditionsDescription6", "tips"),
            Loc.new("TrainsConditionsDescription7", "tips"),
            Loc.new("TrainsConditionsDescription8", "tips"),
            Loc.new("TrainsConditionsDescription9", "tips")
        },
        image = "Textures/TrainsConditions.png"
    })

    local i_signals = AutosizeInventory.new_simple()
    i_signals.draggable = false
    i_signals:add(StaticItem.find("RailSignal"), 1)
    i_signals:add(StaticItem.find("RailChainSignal"), 1)
    StaticTip.reg("TrainsSignals", {
        label = Loc.new("TrainsSignals", "tips"),
        parent = trains,
        description_parts = {
            Loc.new("TrainsSignalsDescription1", "tips"),
            Loc.new("TrainsSignalsDescription2", "tips"),
            Loc.new("TrainsSignalsDescription3", "tips"),
            Loc.new("TrainsSignalsDescription4", "tips"),
            Loc.new("TrainsSignalsDescription5", "tips"),
            Loc.new("TrainsSignalsDescription6", "tips"),
            Loc.new("TrainsSignalsDescription7", "tips")
        },
        image = "Textures/TrainsSignals.png",
        context = i_signals
    })

    StaticTip.reg("TrainsWaiting", {
        label = Loc.new("TrainsWaiting", "tips"),
        parent = trains,
        description_parts = {
            Loc.new("TrainsWaitingDescription1", "tips"),
            Loc.new("TrainsWaitingDescription2", "tips"),
            Loc.new("TrainsWaitingDescription3", "tips"),
            Loc.new("TrainsWaitingDescription4", "tips")
        },
        image = "Textures/TrainsWaiting.png"
    })
end

function VanillaTipsMod.pre_init()
end

function VanillaTipsMod.post_init()
end

db:mod(VanillaTipsMod)