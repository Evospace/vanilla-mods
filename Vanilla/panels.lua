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

local mining_caption = "#ced4dd"

local function gui_number(value)
    local rounded = math.floor(value + 0.5)
    if math.abs(value - rounded) <= 0.05 then
        return tostring(rounded)
    end
    return string.format("%.1f", value)
end

local function gui_power(watts)
    if watts >= 1000 then
        return gui_number(watts / 1000) .. " kW"
    end
    return gui_number(watts) .. " W"
end

local function ore_props()
    local props = {}
    for _, data in ipairs(StaticPropList.find("OreProps").data) do
        for _, prop in ipairs(data.props) do
            props[#props + 1] = prop
        end
    end
    return props
end

local function find_deposit(item)
    for _, prop in ipairs(ore_props()) do
        local result = prop.mined_item
        if result ~= nil and result.name == item.name then
            return prop
        end
    end
    return nil
end

local function deposit_results(type)
    local items = {}
    local seen = {}
    for _, prop in ipairs(ore_props()) do
        local result = prop.mined_item
        if result ~= nil and result.type == type and not seen[result.name] then
            seen[result.name] = true
            items[#items + 1] = result
        end
    end
    return items
end

local function bonus_percent(panel, block)
    local bonus = math.floor(panel:get_number("productivity_per_level", 0)) * block.level
    local modifier = panel:get_string("modifier")
    if modifier ~= "" then
        bonus = bonus + StaticModifier.find(modifier).value
    end
    return math.max(0, bonus)
end

local function mining_card(value, caption)
    local box = ui.VBox { ui.RichText { text = value, font_size = 20, wrap = false } }
    if caption ~= nil then
        box:add(ui.RichText { text = caption, font_size = 11, color = mining_caption })
    end
    return ui.Border { style = "plate", padding = { 8, 6 }, fill = 1, box }
end

local function item_row(items)
    local inventory = AutosizeInventory.new_simple()
    inventory.zero_slots = true
    for _, item in ipairs(items) do
        inventory:add(item, 0)
    end
    return ui.Inventory { inventory = inventory, numbers = false, columns = 15 }
end

local function build_mining(item, panel)
    local block = item.block
    local miner = block ~= nil and block.logic ~= nil and block.logic:is_child_of(DrillingMachineBase.get_class())
    local deposit = not miner and find_deposit(item) or nil

    local root = ui.VBox { gap = 8 }
    local lines = ui.VBox { gap = 6 }

    if not miner and deposit == nil then
        root:add(ui.RichText { text = Loc.get("MiningSurfaceTitle", "panels"), font_size = 15 })
        lines:add(ui.RichText { text = Loc.get("MiningSurface", "panels") })
        root:add(lines)
        return root
    end

    local label = panel.label:get()
    if label ~= "" then
        root:add(ui.RichText { text = label, font_size = 15 })
    end
    root:add(lines)

    local tick_rate = game.tick_rate
    local ticks = math.max(1, math.floor(panel:get_number("ticks", 0)))
    local production = math.max(1, math.floor(panel:get_number("production", 1)))
    local seconds = ticks / tick_rate
    local bonus = miner and bonus_percent(panel, block) or 0
    local output_name = panel:get_string("output")
    local output = output_name ~= "" and StaticItem.find(output_name) or nil
    local unit = output ~= nil and output.unit_mul or item.unit_mul
    local per_minute = production * unit * 60 / seconds * (1 + bonus / 100)

    local cards = ui.HBox { gap = 4 }
    cards:add(mining_card(Loc.format("MiningRateValue", "panels", { gui_number(per_minute) })))
    if bonus > 0 then
        cards:add(mining_card(Loc.format("MiningPercent", "panels", { bonus })))
    end
    cards:add(mining_card(Loc.format("MiningCycleValue", "panels", { gui_number(seconds) }), Loc.get("MiningCycleCaption", "panels")))
    if miner and block.energy_consumption_per_tick > 0 then
        cards:add(mining_card(gui_power(block.energy_consumption_per_tick * tick_rate)))
    end
    lines:add(cards)

    if miner then
        lines:add(item_row(deposit_results(output ~= nil and output.type or "solid")))
    else
        lines:add(item_row({ deposit.item }))
        local machine = panel:get_string("machine")
        if machine ~= "" then
            lines:add(ui.RichText { text = Loc.format("MiningMachineLine", "panels", { "{machine:" .. machine .. "}" }) })
        end
    end

    return root
end

local function fill(panel, title, items, data)
    panel.build = build_mining
    panel.label = Loc.new(title, "panels")
    panel.items = items
    panel:set_number("ticks", data.ticks)
    panel:set_number("production", data.production)
    panel:set_number("productivity_per_level", data.productivity_per_level)
    panel:set_string("modifier", data.modifier)
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
