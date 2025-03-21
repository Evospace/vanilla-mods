require('Blocks/common')

local checkAndSet = function(name, start_tier)
	local dict = RecipeDictionary.find(name.."RecipeDictionary")
	if dict == nil then
		print_err(name.."RecipeDictionary not found for start tier")
		return
	end
	dict.start_tier = start_tier
end

checkAndSet("OreWasher", 2)
FillBlock("OreWasher", require('Blocks/ore_washer'))

checkAndSet("Macerator", 1)
FillBlock("Macerator", require('Blocks/macerator'))

checkAndSet("CuttingMachine", 1)
FillBlock("CuttingMachine", require('Blocks/cutting_machine'))

checkAndSet("Fermenter", 2)
FillBlock("Fermenter", require('Blocks/fermenter'))

checkAndSet("AutomaticHammer", 1)
FillBlock("AutomaticHammer", require('Blocks/automatic_hammer'))

FillBlock("StirlingEngine", require('Blocks/stirling_engine'))

FillBlock("CompactGenerator", require('Blocks/compact_generator'))

checkAndSet("Smelter", 0)
FillBlock("Smelter", require('Blocks/smelter'))

checkAndSet("IndustrialSmelter", 4)
FillBlock("IndustrialSmelter", require('Blocks/industrial_smelter'))

checkAndSet("Furnace", 0)
FillBlock("Furnace", require('Blocks/furnace'))

checkAndSet("FluidFurnace", 1)
FillBlock("FluidFurnace", require('Blocks/fluid_furnace'))

FillBlock("ElectricFurnace", require('Blocks/electric_furnace'))

FillBlock("Destroyer", require('Blocks/destroyer'))

checkAndSet("Assembler", 3)
FillBlock("Assembler", require('Blocks/assembler'))

checkAndSet("Oven", 1)
FillBlock("Oven", require('Blocks/oven'))

checkAndSet("BlastFurnace", 1)
FillBlock("BlastFurnace", require('Blocks/blast_furnace'))

checkAndSet("AutomaticFarm", 1)
FillBlock("AutomaticFarm", require('Blocks/automatic_farm'))

checkAndSet("AtmosphericCondenser", 1)
FillBlock("AtmosphericCondenser", require('Blocks/atmospheric_condenser'))

FillBlock("Boiler", require('Blocks/boiler'))

FillBlock("SteamTurbine", require('Blocks/steam_turbine'))

FillBlock("SteamEngine", require('Blocks/steam_engine'))

FillBlock("Generator", require('Blocks/generator'))

FillBlock("ElectricEngine", require('Blocks/electric_engine'))

checkAndSet("Separator", 2)
FillBlock("Separator", require('Blocks/separator'))

checkAndSet("IndustrialSeparator", 2)
FillBlock("IndustrialSeparator", require('Blocks/industrial_separator'))

checkAndSet("Electrolyzer", 2)
FillBlock("Electrolyzer", require('Blocks/electrolyzer'))

checkAndSet("ArcSmelter", 2)
FillBlock("ArcSmelter", require('Blocks/arc_smelter'))

checkAndSet("ChemReactor", 2)
FillBlock("ChemReactor", require('Blocks/chem_reactor'))

checkAndSet("IndustrialChemReactor", 3)
FillBlock("IndustrialChemReactor", require('Blocks/industrial_chem_reactor'))

checkAndSet("Mixer", 2)
FillBlock("Mixer", require('Blocks/mixer'))

checkAndSet("PyrolysisUnit", 4)
FillBlock("PyrolysisUnit", require('Blocks/pyrolysis_unit'))

checkAndSet("Constructor", 1)
FillBlock("Constructor", require('Blocks/constructor'))

FillBlock("Computer", require('Blocks/computer'))

FillBlock("BatteryBox", require('Blocks/battery_box'))


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