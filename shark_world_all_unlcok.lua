gg.alert("🐾 Welcome to the Pet Unlocker Script 🐾")


function hide()
        if gg.isVisible(true) then
            gg.setVisible(false)
        end
end


function mainMenu()
    local menu = gg.choice({
        "🔓 Unlock All Pets",
        "❌ Exit Script"
    }, nil, "-script by skuldugery98\n\n-Choose an option:")

    if menu == 1 then
        number = gg.prompt({'Select the number of values to be edited. [-999999999; 99999999]'},nil, {'number'})
        local offstList = {
            setBuyable = {offst = 0x30, condition = 0, edit = 1, name = 'buyable'}, 
            setUnlock = {offst = 0x1C, condition = 1, edit = 0,  name = 'UnlockedLocked'},
            setPrice = {offst = 0x6C, condition = nil ,edit = number[1],  name = 'Price'}
        }
        unlockPets(offstList)
    elseif menu == 2 then
        gg.toast("Script by skuldugery98 Exiting...")
        os.exit()
    end
end

function unlockPets(offstList)
    target_adresses = {
        ['setBuyable'] = {},
        ['setUnlock'] = {},
        ['setPrice'] = {}
    }
    
    gg.setRanges(gg.REGION_C_ALLOC)
    gg.searchNumber("1;673191808:5", gg.TYPE_DWORD)
    gg.refineNumber('1')

    gg.setRanges(gg.REGION_ANONYMOUS)
    results = gg.getResults(gg.getResultCount())
    results[1].address = results[1].address - 0x8

    gg.loadResults(results)
    gg.searchPointer(0)

    results = gg.getResults(gg.getResultCount())

    -- Populate target addresses with offsets
    for i, v in ipairs(results) do
        target_adresses['setBuyable'][i] = {
            address = v.address + offstList.setBuyable.offst,
            flags = gg.TYPE_DWORD
        }

        target_adresses['setUnlock'][i] = {
            address = v.address + offstList.setUnlock.offst,
            flags = gg.TYPE_DWORD
        }

        target_adresses['setPrice'][i] = {
            address = v.address + offstList.setPrice.offst,
            flags = gg.TYPE_DWORD
        }


    end
    

    for key, addresses in pairs(target_adresses) do
        gg.loadResults(addresses)
        new_res = gg.getResults(gg.getResultCount())

        for i, v in ipairs(new_res) do
            local offstData = offstList[key]
            if offstData.condition == nil or v.value == offstData.condition then
                v.value = offstData.edit
                v.name = offstData.name
            end
        end
        
        gg.setValues(new_res)
    end

    if #results == 0 then
        gg.toast("No results found! Exiting...")
        os.exit()
    end
end

while true do
    hide()
    gg.clearResults()
    mainMenu()
    gg.sleep(1000)
end

