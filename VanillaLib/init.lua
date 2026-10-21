local Vlib

Vlib = {
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

    --- @param self BlockLogic
    CommonActorTooltip = function(self)
        local a = AbstractCrafter.cast(self)
        if a ~= nil then
            local usage = a.ticks_passed / math.max(a.real_ticks_passed, 1.0) * 100
            local speed_str = Loc.gui_number(a.speed / 100.0)
            local lines = {
                string.format(Loc.get("TooltipCrafterSpeed", "ui"), speed_str),
                string.format(Loc.get("TooltipCrafterUsage", "ui"), string.format("%.0f", usage)),
            }
            if a.total_production > 0 then
                table.insert(lines, string.format(Loc.get("TooltipCrafterTotalProduction", "ui"), a.total_production))
            end
            if a.static_block.energy_tooltip ~= "" then
                table.insert(lines, a.static_block.energy_tooltip)
            end
            return table.concat(lines, "\n")
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

    sides = {
        Vec3i.back, Vec3i.front, Vec3i.right, Vec3i.left, Vec3i.down, Vec3i.up
    },

    mining = {
        drill = {
            ticks = 60,
            production = 1,
            productivity_per_level = 15,
            modifier = "DrillingRigProductivity",
            research = "DrillingRigProductivity",
            research_bonus = 5,
            research_levels = 8,
            machine = "DrillingRig",
        },
        pumpjack = {
            ticks = 100,
            production = 500,
            output = "RawOil",
            productivity_per_level = 20,
            modifier = "PumpjackProductivity",
            research = "PumpjackProductivity",
            research_bonus = 5,
            research_levels = 8,
            machine = "Pumpjack",
        },
    },

    conveyor_ticks_per_item = { 12, 8, 6, 4, 3, 2, 1 },

    --- @param level integer
    --- @return integer
    conveyor_ticks = function(level)
        local ticks = Vlib.conveyor_ticks_per_item
        return ticks[math.min(level + 1, #ticks)]
    end,

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
                    block[key] = value
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
                    block[key] = value
                end
            end
        end
    end,

    --- @param self BlockActor
    CommonActorInit = function(self)
        local mat = Material.load("/Game/Materials/"..Vlib.tier_material[self.logic.static_block.tier + 1])
        self.hull_material = mat
    end,

    --- @param crafter AbstractCrafter
    get_speed = function(crafter)
        return math.pow(2.0, crafter.static_block.level) * 100
    end
}

db:mod({})

return Vlib
