require('Blocks/common')

FillBlock("OreWasher", require('Blocks/ore_washer'))
FillBlock("Macerator", require('Blocks/macerator'))
FillBlock("CuttingMachine", require('Blocks/cutting_machine'))
FillBlock("Fermenter", require('Blocks/fermenter'))
FillBlock("AutomaticHammer", require('Blocks/automatic_hammer'))
FillBlock("StirlingEngine", require('Blocks/stirling_engine'))
FillBlock("CompactGenerator", require('Blocks/compact_generator'))
FillBlock("Smelter", require('Blocks/smelter'))
FillBlock("IndustrialSmelter", require('Blocks/industrial_smelter'))
FillBlock("Furnace", require('Blocks/furnace'))
FillBlock("FluidFurnace", require('Blocks/fluid_furnace'))
FillBlock("ElectricFurnace", require('Blocks/electric_furnace'))
FillBlock("Destroyer", require('Blocks/destroyer'))
FillBlock("Assembler", require('Blocks/assembler'))
FillBlock("Oven", require('Blocks/oven'))
FillBlock("BlastFurnace", require('Blocks/blast_furnace'))
FillBlock("AutomaticFarm", require('Blocks/automatic_farm'))
FillBlock("AtmosphericCondenser", require('Blocks/atmospheric_condenser'))
FillBlock("Boiler", require('Blocks/boiler'))
FillBlock("SteamTurbine", require('Blocks/steam_turbine'))
FillBlock("SteamEngine", require('Blocks/steam_engine'))
FillBlock("Generator", require('Blocks/generator'))
FillBlock("ElectricEngine", require('Blocks/electric_engine'))
FillBlock("Separator", require('Blocks/separator'))
FillBlock("IndustrialSeparator", require('Blocks/industrial_separator'))
FillBlock("Electrolyzer", require('Blocks/electrolyzer'))
FillBlock("ArcSmelter", require('Blocks/arc_smelter'))
FillBlock("ChemReactor", require('Blocks/chem_reactor'))
FillBlock("IndustrialChemReactor", require('Blocks/industrial_chem_reactor'))
FillBlock("Mixer", require('Blocks/mixer'))
FillBlock("PyrolysisUnit", require('Blocks/pyrolysis_unit'))
FillBlock("Constructor", require('Blocks/constructor'))
FillBlock("Computer", require('Blocks/computer'))


FillBlockCustom("Connector", require('Blocks/cable'), {"Copper"})
local cable_material = {
	"OFC",
	"G",
	"CN",
	"YBCO",
	"P",
    "TN",
	"ABCCO"
}
FillBlockCustom("Cable", require('Blocks/cable'), cable_material)