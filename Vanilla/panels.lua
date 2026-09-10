local mining_widget = "/Script/Evospace.MiningPanelWidget"
local plate_widget = "/Script/Evospace.PlatePanelWidget"

local surface_names = {
    "Stone",
    "StoneSurface",
    "GravelSurface",
    "SandSurface",
    "DesertSandSurface",
    "DirtSurface",
    "BasaltSurface",
    "GraniteSurface",
    "LimestoneSurface",
    "SandstoneSurface",
    "DarkStoneSurface",
    "RedStoneSurface",
    "ClaySurface",
    "PeatSurface",
}

local function find_items(names)
    local items = {}
    for _, name in ipairs(names) do
        local item = StaticItem.find(name)
        if item ~= nil then
            table.insert(items, item)
        end
    end
    return items
end

local function tier_names(machine)
    local names = {}
    for _, tier in ipairs(Vlib.tier_material) do
        table.insert(names, tier..machine)
    end
    return names
end

local function deposit_items()
    local items = {}
    for _, proto in pairs(db:objects()) do
        local item = StaticItem.cast(proto)
        if item ~= nil and item.category == "Ore" and item.name:match("Ore$") ~= nil then
            table.insert(items, item)
        end
    end
    return items
end

local function fill(panel, title, items, data)
    panel.widget = mining_widget
    panel.label = Loc.new(title, "panels")
    panel.items = items
    panel:set_number("ticks", data.ticks)
    panel:set_number("production", data.production)
    panel:set_number("productivity_per_level", data.productivity_per_level)
    panel:set_number("research_bonus", data.research_bonus)
    panel:set_number("research_levels", data.research_levels)
    panel:set_string("modifier", data.modifier)
    panel:set_string("research", data.research)
    panel:set_string("machine", data.machine)
    panel:set_string("output", data.output or "")
end

return function()
    local resources = deposit_items()
    for _, item in ipairs(find_items(surface_names)) do
        table.insert(resources, item)
    end

    fill(StaticItemPanel.reg("MiningResources"), "MiningResourceTitle", resources, Vlib.mining.drill)
    fill(StaticItemPanel.reg("MiningOil"), "MiningResourceTitle", find_items({ "RawOil" }), Vlib.mining.pumpjack)
    fill(StaticItemPanel.reg("MiningDrillingRig"), "MiningRigTitle", find_items(tier_names("DrillingRig")), Vlib.mining.drill)

    fill(StaticItemPanel.reg("MiningPumpjack"), "MiningPumpjackTitle", find_items(tier_names("Pumpjack")), Vlib.mining.pumpjack)

    local plates = StaticItemPanel.reg("PlateTiers")
    plates.widget = plate_widget
    plates.category = "Plate"
    plates.label = Loc.new("PlateTierTitle", "panels")
    plates.items = find_items(tier_names("Plate"))
end
