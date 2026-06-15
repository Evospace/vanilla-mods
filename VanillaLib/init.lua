local VanillaLib = {}

function VanillaLib.init()
end

function VanillaLib.pre_init()
end

function VanillaLib.post_init()
end

Vlib = {
    ---Create count inventories
    ---@param parent Object
    ---@param name string
    ---@param count integer
    ---@return SingleSlotInventory[]
    single_slot_invs = function(parent, name, count)
        local inventories = {}
        for i = 1, count do
            local inv = SingleSlotInventory.new(parent, name..i)
            Vlib.verbose("Creating "..tostring(inv))
            inventories[i] = inv
        end
        return inventories
    end,

    ---Create count inventories
    ---@param inventory_container InventoryContainer
    ---@param parent Object
    ---@param name string
    ---@param count integer
    ---@return SingleSlotInventory[]
    add_single_slot_invs = function(inventory_container, parent, name, count)
        local inventories = {}
        for i = 1, count do
            local inv = SingleSlotInventory.new(parent, name..i)
            Vlib.verbose("Binding "..tostring(inv).." to "..tostring(inventory_container))
            inventories[i] = inv
            inventory_container:bind(inv)
        end
        return inventories
    end,

    dump = function (o)
        if type(o) == 'table' then
            local s = '('
            for k,v in pairs(o) do
                if type(k) ~= 'userdata' then
                    s = s .. k ..' = ' .. Vlib.dump(v) .. ','
                end
                
            end
            return s .. ')'
        elseif type(o) == 'userdata' then
            return tostring(o)
        else
            return tostring(o)
        end
    end,
     
    verbose = function (str)
        if LuaLogFlag then print(str) end
    end,

    --- Build localized tooltip lines from StaticBlock prototype data (energy).
    --- Optional extra_lines: array of already-localized strings (e.g. crafter runtime stats), shown first.
    --- @param sb StaticBlock|nil
    --- @param extra_lines string[]|nil
    --- @return string
    static_block_tooltip = function(sb, extra_lines)
        local lines = {}
        extra_lines = extra_lines or {}
        for _, l in ipairs(extra_lines) do
            if l ~= nil and l ~= "" then
                table.insert(lines, l)
            end
        end
        if sb == nil then
            return table.concat(lines, "\n")
        end

        local con = sb.energy_consumption_per_tick or 0
        local prod = sb.energy_production_per_tick or 0

        if con > 0 then
            local w = Loc.gui_number(con * 20)
            table.insert(lines, string.format(Loc.get("TooltipBlockEnergyConsumption", "ui"), w))
        end
        if prod > 0 then
            local w = Loc.gui_number(prod * 20)
            table.insert(lines, string.format(Loc.get("TooltipBlockEnergyProduction", "ui"), w))
        end
        if con > 0 and prod > 0 then
            local net_w = Loc.gui_number((prod - con) * 20)
            table.insert(lines, string.format(Loc.get("TooltipBlockEnergyNet", "ui"), net_w))
        end

        return table.concat(lines, "\n")
    end,

    --- @param self BlockLogic
    CommonActorTooltip = function(self)
        local a = AbstractCrafter.cast(self)
        if a ~= nil then
            local usage = a.ticks_passed / math.max(a.real_ticks_passed, 1.0) * 100
            local speed_str = Loc.gui_number(a.speed / 100.0)
            local extra = {
                string.format(Loc.get("TooltipCrafterSpeed", "ui"), speed_str),
                string.format(Loc.get("TooltipCrafterUsage", "ui"), string.format("%.0f", usage)),
            }
            if a.total_production > 0 then
                table.insert(extra, string.format(Loc.get("TooltipCrafterTotalProduction", "ui"), a.total_production))
            end
            return Vlib.static_block_tooltip(a.static_block, extra)
        end

        return Loc.get("TooltipBlockNoLogic", "ui")
    end,

    tier_material = {
        "Stone",
        "Copper",
        "Steel",
        "Aluminium",
        "StainlessSteel",
        "Titanium",
        "Composite",
        "Neutronium"
    },

    cable_array = {
        "CopperConnector",
        "OFCCable",
        "SCable",
        "GCable",
        "ACable",
        "YBCOCable",
        "PCable",
        "TNCable",
        "ABCCOCable",
    },

    sides = {
        Vec3i.back, Vec3i.front, Vec3i.right, Vec3i.left, Vec3i.down, Vec3i.up
    },

    --- @param names string[]
    --- @param register_fn function
    FillBlockCustom = function(names, register_fn)
        local first_tier = nil
        for index, name in pairs(names) do
            local block = StaticBlock.find(name)
            if block ~= nil then
                if first_tier == nil then
                    first_tier = index - 1
                end
                print("Logic set: "..name)

                local table = register_fn(name, index - 1, index - first_tier)

                for key, value in pairs(table) do
                    block.lua[key] = value
                end
            end
        end
    end,

    --- @param name string
    --- @param register_fn function
    FillBlock = function(name, register_fn)
        local first_tier = nil
        for index, tier in pairs(Vlib.tier_material) do
            local block = StaticBlock.find(tier..name)
            if block ~= nil then
                if first_tier == nil then
                    first_tier = index - 1
                end
                print("Logic set: "..tier..name)

                local table = register_fn(tier..name, index - 1, index - first_tier - 1)

                for key, value in pairs(table) do
                    block.lua[key] = value
                end
            end
        end
    end,

    --- @param self BlockActor
    CommonActorInit = function(self)
        local mat = Material.load("/Game/Materials/"..Vlib.tier_material[self.logic.static_block.tier + 1])
        self.hull_material = mat
        --Legacy.this:set_field_object("HullMaterial", mat)
    end,

    --- @param crafter AbstractCrafter
    get_speed = function(crafter)
        return math.pow(2.0, crafter.static_block.level) * 100
    end
}

db:mod(VanillaLib)