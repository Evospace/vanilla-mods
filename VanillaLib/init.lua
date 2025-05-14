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

    --- @param self BlockLogic
    CommonActorTooltip = function(self)
        local a = AbstractCrafter.cast(self)
        if a ~= nil then
            local usage = a.ticks_passed / math.max(a.real_ticks_passed, 1.0) * 100
            local t = "Speed: x"..(a.speed/100.0).."\nUsage: "..string.format("%.0f%%", usage)
            --local t = "Usage: "..string.format("%.0f%%", usage)
            if a.energy_input_inventory ~= nil then
                t = t.."\nConsumption: "..Loc.gui_number(a.energy_input_inventory.capacity*20).."W"
            end
            if a.energy_output_inventory ~= nil then
                t = t.."\nProduction: "..Loc.gui_number(a.energy_output_inventory.capacity*20).."W"
            end
            return t
        end

        return "hello from lua"
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

    transformer_array = {
        "TransformerLVMV",
        "TransformerMVLV",
        "AdvancedTransformerLVMV",
        "AdvancedTransformerMVLV",
    },

    sides = {
        Vec3i.back, Vec3i.front, Vec3i.right, Vec3i.left, Vec3i.down, Vec3i.up
    },

    --- @param names string[]
    --- @param table table
    FillBlockCustom = function(names, table)
        for index, name in pairs(names) do
            local block = StaticBlock.find(name)
            if block ~= nil then
                print(name.." found, registering lua table")

                for key, value in pairs(table) do
                    block.lua[key] = value
                end
            end
        end
    end,

    --- @param name string
    --- @param table table
    FillBlock = function(name, table)
        for index, tier in pairs(Vlib.tier_material) do
            local block = StaticBlock.find(tier..name)
            if block ~= nil then
                print(tier..name.." found, registering lua table")

                for key, value in pairs(table) do
                    block.lua[key] = value
                end
            end
        end
    end,

    --- @param self BlockActor
    CommonActorInit = function(self)
        local mat = Material.load("/Game/Materials/"..Vlib.tier_material[self.logic.static_block.tier + 1])
        Legacy.this:set_field_object("HullMaterial", mat)
    end,

    --- @param crafter BlockLogic
    --- @param value integer
    get_consumption = function(crafter, value)
        return math.pow(2.0, crafter.static_block.level) * value
    end,

    --- @param crafter AbstractCrafter
    get_speed = function(crafter)
        return math.pow(2.0, crafter.static_block.level) * 100
    end
}

db:mod(VanillaLib)