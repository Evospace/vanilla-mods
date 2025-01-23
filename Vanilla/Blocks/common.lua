local tier_material = {
	"Stone",
	"Copper",
	"Steel",
	"Aluminium",
	"StainlessSteel",
	"Titanium",
	"HardMetal",
	"Neutronium"
}

--- @param name string
--- @param table table
function FillBlock(name, table)
    for index, tier in pairs(tier_material) do
        local block = StaticBlock.find(tier..name)
        if block ~= nil then
            print(tier.." "..name.." found, registering lua table")

			for key, value in pairs(table) do
				block.lua[key] = value
			end
        end
    end
end

--- @param self BlockActor
CommonActorInit = function(self)
    local tier_material = {
        "Stone",
        "Copper",
        "Steel",
        "Aluminium",
        "StainlessSteel",
        "Titanium",
        "HardMetal",
        "Neutronium"
    }

    local mat = Material.load("/Game/Materials/"..tier_material[self.logic.static_block.tier + 1])
    Legacy.this:set_field_object("HullMaterial", mat)
end

--- @param crafter AbstractCrafter
--- @param value integer
VanillaConsumptionF = function(crafter, value)
    return math.pow(2.0, crafter.static_block.level) * value
end

--- @param crafter AbstractCrafter
VanillaSpeedF = function(crafter)
    return math.pow(1.5, crafter.static_block.level) * 100
end

--- @param self BlockLogic
CommonActorTooltip = function(self)
    local a = AbstractCrafter.cast(self)
    if a ~= nil then
        local usage = a.ticks_passed / math.max(a.real_ticks_passed, 1.0) * 100
        local t = "Speed: x"..(a.speed/100.0).."\nUsage: "..string.format("%.0f%%", usage)
        if a.energy_input_inventory ~= nil then
            t = t.."\nConsumption: "..Loc.gui_number(a.energy_input_inventory.capacity*20).."W"
        end
        if a.energy_output_inventory ~= nil then
            t = t.."\nProduction: "..Loc.gui_number(a.energy_output_inventory.capacity*20).."W"
        end
        return t
    end

    return "hello from lua"
end