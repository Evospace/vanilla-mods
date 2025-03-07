local BasicTestsMod = {}

local passedCounter = 0
local failedCounter = 0

local function log(message)
    print("[TestLog] " .. message)
    passedCounter = passedCounter + 1
end

local function log_error(message)
    print_err("[TestLog] " .. message)
    failedCounter = failedCounter + 1
end

local function assert_eq(actual, expected, message)
    if actual == expected then
        log("PASS: " .. message)
    else
        log_error("FAIL: " .. message .. " (Expected: " .. tostring(expected) .. ", Got: " .. tostring(actual) .. ")")
    end
end

local function assert_ne(actual, expected, message)
    if actual ~= expected then
        log("PASS: " .. message)
    else
        log_error("FAIL: " .. message .. " (Expected different from: " .. tostring(expected) .. ")")
    end
end

local function assert_true(value, message)
    if value then
        log("PASS: " .. message)
    else
        log_error("FAIL: " .. message .. " (Expected true, got false)")
    end
end

local function assert_false(value, message)
    if not value then
        log("PASS: " .. message)
    else
        log_error("FAIL: " .. message .. " (Expected false, got true)")
    end
end

-- Test initialization
function BasicTestsMod.init()
    log("Initializing BasicTestsMod")
end

local function testCases1() 
    log("Pre-initialization of BasicTestsMod")

    local success, _ = pcall(function()
        db:reg(StaticItem.new("TestItem"))
    end)
    assert_true(success, "Registering TestItem")

	---@type StaticItem
	local item
	local success, _ = pcall(function()
        item = StaticItem.find("TestItem")
    end)
    assert_true(success, "Finding TestItem")
    assert_ne(item, nil, "TestItem is found")
    
	---@type AutosizeInventory
    local inv
    success, _ = pcall(function()
        inv = AutosizeInventory.new_simple()
    end)
    assert_true(success and inv ~= nil, "Creating AutosizeInventory")
    
	local itemCount = 4
    success, _ = pcall(function()
        inv:add(item, itemCount)
    end)
    assert_true(success, "Adding item to inventory")

	---@type ItemData
	local itemData
	success, _ = pcall(function()
        itemData = inv:get(0)
    end)
	assert_true(success, "Adding item to inventory")
    assert_eq(itemData.item, item, "Added item test")
	assert_eq(itemData.count, itemCount, "Added item test")

    local size
    success, _ = pcall(function()
        size = inv.size
    end)
	assert_true(success, "Inventory size call")
    assert_eq(size, 1, "Inventory size 1")
end

function BasicTestsMod.pre_init()
    testCases1()

    print("Passed: "..passedCounter)
    if failedCounter > 0 then
        print_err("Failed: "..failedCounter)
    else
        print("Nothing is faled!")
    end
end

function BasicTestsMod.post_init()
    log("Post-initialization of BasicTestsMod")
end

-- Registering mod
log("Registering BasicTestsMod")
db:mod(BasicTestsMod)
