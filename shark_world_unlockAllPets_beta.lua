gg.alert("🐾 Welcome to the Pet Unlocker Script 🐾")

function mainMenu()
    local menu = gg.choice({
        "🔓 Unlock All Pets",
        "❌ Exit Script"
    }, nil, "Choose an option:")

    if menu == 1 then
        unlockPets()
    elseif menu == 2 then
        gg.toast("Exiting script... Bye! 👋")
        os.exit()
    end
end

function unlockPets()
    -- Step 1: Search in the C_ALLOC region for the initial value '1'
    gg.setRanges(gg.REGION_C_ALLOC)
    gg.searchNumber("1;673191808:5", gg.TYPE_DWORD)  -- Adjusted to remove commas for better compatibility
    gg.refineNumber('1')

    -- Step 2: Retrieve results and apply offset subtraction
    local results = gg.getResults(gg.getResultCount())
    if #results == 0 then
        gg.toast("No results found! Exiting...")
        os.exit()
    end

    -- Subtract 0x8 from the address to get to the class pointer
    for i, v in ipairs(results) do
        v.address = v.address - 0x8
        v.flags = 32
        print("Address after offset: " .. string.format("%x", v.address))
    end
    -- gg.setValues(results)
    print(results)

    -- Step 3: Clear previous results and switch to ANONYMOUS for pointer search
    gg.clearResults()
    gg.setRanges(gg.REGION_ANONYMOUS)
    
    -- Use the address from the class pointer and search for pointers in the ANONYMOUS region
    gg.searchPointer(0)  -- Searching pointers from the adjusted address
    print(results)

    -- Step 4: Retrieve all pointer results
    local pointerResults = gg.getResults(1000)
    if #pointerResults == 0 then
        gg.toast("No pointers found! Exiting...")
        os.exit()
    end

    -- Step 5: Apply the 0x30 offset to each found pointer
    for i, v in ipairs(pointerResults) do
        v.address = v.address + 0x30
    end

    print(pointerResults)
    -- Step 6: Save the modified addresses
    gg.addListItems(pointerResults)
    gg.toast("All pets unlocked! 🎉🐾")
end

while true do
    mainMenu()
    gg.sleep(1000)
end
