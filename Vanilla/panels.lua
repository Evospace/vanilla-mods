local mining_widget = "/Script/Evospace.MiningPanelWidget"
local plate_widget = "/Script/Evospace.PlatePanelWidget"

local surface_names = {
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

local function decor_items()
    local items = {}
    local seen = {}
    for _, proto in pairs(db:objects()) do
        local unlock = StaticResearchDecorationUnlock.cast(proto)
        if unlock ~= nil then
            for _, item in ipairs(unlock.decorations) do
                if not seen[item.name] then
                    seen[item.name] = true
                    table.insert(items, item)
                end
            end
        end
    end
    return items
end

local function describe_decor(items)
    for _, item in ipairs(items) do
        local parts = item.description_parts
        parts[#parts + 1] = Loc.new("DecorBuiltFrom", "common")
        item.description_parts = parts
    end
end

local function panel_line(key, value)
    return (Loc.get(key, "panels"):gsub("{0}", function() return value end))
end

local function build_decor(item, panel)
    local root = ui.VBox { gap = 8 }

    local label = panel.label:get()
    if label ~= "" then
        root:add(ui.RichText { text = label, font_size = 15 })
    end

    local block = item.block
    local material = block and block.mined_item
    if material == nil then
        return root
    end

    local token = "{item:" .. material.name .. "}"
    root:add(ui.HBox { gap = 10,
        ui.Border { style = "plate", padding = 4, valign = "top", ui.Image { image = ui.thumbnail(block) or item.image, size = 128 } },
        ui.VBox { fill = 1, valign = "top", gap = 8,
            ui.RichText { text = panel_line("DecorPanelLine", token) },
            ui.HBox { gap = 6,
                ui.Image { image = material.image, size = 32, valign = "center" },
                ui.RichText { text = "× " .. block.mined_count, font_size = 16, wrap = false, valign = "center" },
            },
        },
    })
    return root
end

local function build_text(item, panel)
    local root = ui.VBox { gap = 6 }

    local label = panel.label:get()
    if label ~= "" then
        root:add(ui.RichText { text = label, font_size = 16 })
    end

    local body = ui.VBox { gap = 8 }
    local parts = {}
    for _, part in ipairs(panel.description_parts) do
        parts[#parts + 1] = part:raw()
    end
    local text = table.concat(parts, "\n\n"):match("^%s*(.-)%s*$")
    if text ~= "" then
        body:add(ui.RichText { text = text })
    end
    if panel.context.size > 0 then
        body:add(ui.Inventory { inventory = panel.context, numbers = false })
    end
    root:add(body)

    return root
end

local function fill(panel, title, items, data)
    panel.widget = mining_widget
    panel.label = Loc.new(title, "panels")
    panel.items = items
    panel:set_number("ticks", data.ticks)
    panel:set_number("production", data.production)
    panel:set_number("productivity_per_level", data.productivity_per_level)
    panel:set_string("modifier", data.modifier)
    panel:set_string("research", data.research)
    panel:set_string("machine", data.machine)
    panel:set_string("output", data.output or "")
end

local function fill_defaults()
    for _, proto in pairs(db:objects()) do
        local panel = StaticItemPanel.cast(proto)
        if panel ~= nil and panel.widget == "" and panel.build == nil then
            panel.build = build_text
        end
    end
end

local function register()
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

    local decor = decor_items()
    describe_decor(decor)

    local decor_panel = StaticItemPanel.reg("DecorBuild")
    decor_panel.build = build_decor
    decor_panel.label = Loc.new("DecorPanelTitle", "panels")
    decor_panel.items = decor
end

return { register = register, fill_defaults = fill_defaults }
