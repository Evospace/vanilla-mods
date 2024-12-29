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

common_actor_init = function(self)
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