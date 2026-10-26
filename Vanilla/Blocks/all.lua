local Vlib = require('@VanillaLib')

return function()
    Vlib.FillBlock("OreWasher", require('./ore_washer'))

    Vlib.FillBlock("Macerator", require('./macerator'))

    Vlib.FillBlock("Fermenter", require('./fermenter'))

    Vlib.FillBlock("AutomaticHammer", require('./automatic_hammer'))

    Vlib.FillBlock("StirlingEngine", require('./stirling_engine'))

    Vlib.FillBlock("CompactGenerator", require('./compact_generator'))

    Vlib.FillBlock("Smelter", require('./smelter'))

    Vlib.FillBlock("IndustrialSmelter", require('./industrial_smelter'))

    Vlib.FillBlock("Furnace", require('./furnace'))

    Vlib.FillBlock("FluidFurnace", require('./fluid_furnace'))

    Vlib.FillBlock("ElectricFurnace", require('./electric_furnace'))

    Vlib.FillBlock("Destroyer", require('./destroyer'))

    Vlib.FillBlock("Assembler", require('./assembler'))

    Vlib.FillBlock("Oven", require('./oven'))

    Vlib.FillBlock("BlastFurnace", require('./blast_furnace'))

    Vlib.FillBlock("AutomaticFarm", require('./automatic_farm'))

    Vlib.FillBlock("AtmosphericCondenser", require('./atmospheric_condenser'))

    Vlib.FillBlock("Boiler", require('./boiler'))

    Vlib.FillBlock("SteamTurbine", require('./steam_turbine'))

    Vlib.FillBlock("SteamEngine", require('./steam_engine'))

    Vlib.FillBlock("Generator", require('./generator'))

    Vlib.FillBlock("ElectricEngine", require('./electric_engine'))
    Vlib.FillBlock("BiElectricEngine", require('./bi_electric_engine'))

    Vlib.FillBlock("Separator", require('./separator'))

    Vlib.FillBlock("Electrolyzer", require('./electrolyzer'))

    Vlib.FillBlock("ArcSmelter", require('./arc_smelter'))

    Vlib.FillBlock("ChemicalBath", require('./chemical_bath'))

    Vlib.FillBlock("IndustrialChemReactor", require('./industrial_chem_reactor'))

    Vlib.FillBlock("Mixer", require('./mixer'))

    Vlib.FillBlock("PyrolysisUnit", require('./pyrolysis_unit'))

    Vlib.FillBlock("FractionatingColumn", require('./fractionating_column'))

    Vlib.FillBlock("Constructor", require('./constructor'))

    Vlib.FillBlock("Sifter", require('./sifter'))

    Vlib.FillBlock("Computer", require('./computer'))

    Vlib.FillBlock("BatteryBox", require('./battery_box'))

    Vlib.FillBlockCustom({"LogicWire"}, require('./data_wire'))
    Vlib.FillBlock("Pipe", require('./pipe'))
    Vlib.FillBlock("HeatPipe", require('./heat_pipe'))
    Vlib.FillBlock("Flywheel", require('./flywheel'))

    Vlib.FillBlock("Container", require('./container'))

    Vlib.FillBlock("Chest", require('./chest'))
    Vlib.FillBlock("ItemRack", require('./item_rack'))
    Vlib.FillBlock("DeepStorage", require('./deep_storage'))

    Vlib.FillBlock("Conveyor", require('./conveyor'))
    Vlib.FillBlock("Splitter", require('./splitter'))
    Vlib.FillBlock("Sorter", require('./splitter'))

    Vlib.FillBlock("TeslaTower", require('./tesla_tower'))

    Vlib.FillBlock("KineticHeater", require('./kinetic_heater'))

    Vlib.FillBlock("FissionReactor", require('./fission_reactor'))

    Vlib.FillBlock("DrillingRig", require('./drilling_rig'))

    Vlib.FillBlock("Pumpjack", require('./pumpjack'))

    Vlib.FillBlock("CombustionEngine", require('./combustion_engine'))
    Vlib.FillBlock("IndustrialBoiler", require('./industrial_boiler'))
    Vlib.FillBlock("IndustrialSteamTurbine", require('./industrial_steam_turbine'))
    Vlib.FillBlock("IndustrialGenerator", require('./industrial_generator'))

    Vlib.FillBlock("FusionReactor", require('./fusion_reactor'))
    Vlib.FillBlock("Portal", require('./portal'))
    Vlib.FillBlock("SmallSolarPanel", require('./small_solar_panel'))
    Vlib.FillBlock("SolarPanel", require('./solar_panel'))
    Vlib.FillBlock("WindTurbine", require('./wind_turbine'))
    Vlib.FillBlock("Riteg", require('./riteg'))

    Vlib.FillBlockCustom({"CopperConnector"}, require('./cable'))

    Vlib.FillBlockCustom({"Stairs", "Corner", "Beam", "Scaffold", "Chair", "Table", "Ladder", "Fence", "Column", "Floor"}, require('./designable'))
end