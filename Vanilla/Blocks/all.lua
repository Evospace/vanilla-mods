

local checkAndSet = function(name, start_tier)
	local dict = RecipeDictionary.find(name.."RecipeDictionary")
	if dict == nil then
		print_err(name.."RecipeDictionary not found for start tier")
		return
	end
	dict.start_tier = start_tier
end

checkAndSet("OreWasher", 2)
Vlib.FillBlock("OreWasher", require('Blocks/ore_washer'))

checkAndSet("Macerator", 1)
Vlib.FillBlock("Macerator", require('Blocks/macerator'))

checkAndSet("Fermenter", 2)
Vlib.FillBlock("Fermenter", require('Blocks/fermenter'))

checkAndSet("AutomaticHammer", 1)
Vlib.FillBlock("AutomaticHammer", require('Blocks/automatic_hammer'))

Vlib.FillBlock("StirlingEngine", require('Blocks/stirling_engine'))

Vlib.FillBlock("CompactGenerator", require('Blocks/compact_generator'))

checkAndSet("Smelter", 0)
Vlib.FillBlock("Smelter", require('Blocks/smelter'))

checkAndSet("IndustrialSmelter", 4)
Vlib.FillBlock("IndustrialSmelter", require('Blocks/industrial_smelter'))

checkAndSet("Furnace", 0)
Vlib.FillBlock("Furnace", require('Blocks/furnace'))

checkAndSet("FluidFurnace", 1)
Vlib.FillBlock("FluidFurnace", require('Blocks/fluid_furnace'))

Vlib.FillBlock("ElectricFurnace", require('Blocks/electric_furnace'))

Vlib.FillBlock("Destroyer", require('Blocks/destroyer'))

checkAndSet("Assembler", 3)
Vlib.FillBlock("Assembler", require('Blocks/assembler'))

checkAndSet("Oven", 1)
Vlib.FillBlock("Oven", require('Blocks/oven'))

checkAndSet("BlastFurnace", 1)
Vlib.FillBlock("BlastFurnace", require('Blocks/blast_furnace'))

checkAndSet("AutomaticFarm", 1)
Vlib.FillBlock("AutomaticFarm", require('Blocks/automatic_farm'))

checkAndSet("AtmosphericCondenser", 1)
Vlib.FillBlock("AtmosphericCondenser", require('Blocks/atmospheric_condenser'))

Vlib.FillBlock("Boiler", require('Blocks/boiler'))

Vlib.FillBlock("SteamTurbine", require('Blocks/steam_turbine'))

Vlib.FillBlock("SteamEngine", require('Blocks/steam_engine'))

Vlib.FillBlock("Generator", require('Blocks/generator'))

Vlib.FillBlock("ElectricEngine", require('Blocks/electric_engine'))
Vlib.FillBlock("BiElectricEngine", require('Blocks/bi_electric_engine'))

checkAndSet("Separator", 2)
Vlib.FillBlock("Separator", require('Blocks/separator'))

checkAndSet("IndustrialSeparator", 2)
Vlib.FillBlock("IndustrialSeparator", require('Blocks/industrial_separator'))

checkAndSet("Electrolyzer", 2)
Vlib.FillBlock("Electrolyzer", require('Blocks/electrolyzer'))

checkAndSet("ArcSmelter", 2)
Vlib.FillBlock("ArcSmelter", require('Blocks/arc_smelter'))

checkAndSet("ChemReactor", 2)
Vlib.FillBlock("ChemReactor", require('Blocks/chem_reactor'))

checkAndSet("ChemicalBath", 3)
Vlib.FillBlock("ChemicalBath", require('Blocks/chemical_bath'))

checkAndSet("IndustrialChemReactor", 3)
Vlib.FillBlock("IndustrialChemReactor", require('Blocks/industrial_chem_reactor'))

checkAndSet("Mixer", 2)
Vlib.FillBlock("Mixer", require('Blocks/mixer'))

checkAndSet("PyrolysisUnit", 4)
Vlib.FillBlock("PyrolysisUnit", require('Blocks/pyrolysis_unit'))

checkAndSet("Constructor", 1)
Vlib.FillBlock("Constructor", require('Blocks/constructor'))

checkAndSet("Constructor", 3)
Vlib.FillBlock("Sifter", require('Blocks/sifter'))

Vlib.FillBlock("Computer", require('Blocks/computer'))

Vlib.FillBlock("BatteryBox", require('Blocks/battery_box'))

Vlib.FillBlock("Pipe", require('Blocks/pipe'))

Vlib.FillBlock("Container", require('Blocks/container'))

Vlib.FillBlock("Chest", require('Blocks/chest'))

Vlib.FillBlockCustom(Vlib.cable_array, require('Blocks/cable'))