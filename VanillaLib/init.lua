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
    ---@return table
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
    ---@return table
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
    end
}

db:mod(VanillaLib)
