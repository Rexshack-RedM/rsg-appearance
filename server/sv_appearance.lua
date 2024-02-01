RSGCore = exports['rsg-core']:GetCoreObject()

-----------------------------------------------------------------------
-- version checker
-----------------------------------------------------------------------
local function versionCheckPrint(_type, log)
    local color = _type == 'success' and '^2' or '^1'

    print(('^5['..GetCurrentResourceName()..']%s %s^7'):format(color, log))
end

local function CheckVersion()
    PerformHttpRequest('https://raw.githubusercontent.com/Rexshack-RedM/rsg-appearance/main/version.txt', function(err, text, headers)
        local currentVersion = GetResourceMetadata(GetCurrentResourceName(), 'version')

        if not text then 
            versionCheckPrint('error', 'Currently unable to run a version check.')
            return 
        end

        --versionCheckPrint('success', ('Current Version: %s'):format(currentVersion))
        --versionCheckPrint('success', ('Latest Version: %s'):format(text))
        
        if text == currentVersion then
            versionCheckPrint('success', 'You are running the latest version.')
        else
            versionCheckPrint('error', ('You are currently running an outdated version, please update to version %s'):format(text))
        end
    end)
end

-----------------------------------------------------------------------

RegisterServerEvent('rsg-appearance:SaveSkin')
AddEventHandler('rsg-appearance:SaveSkin', function(skin, clothes, oldplayer)
    local encode = json.encode(skin)
    local encode2 = json.encode(clothes)
    local Player = RSGCore.Functions.GetPlayer(source)
    local citizenid = Player.PlayerData.citizenid

    if oldplayer then
        local result = MySQL.Sync.fetchAll('SELECT * FROM playerskins WHERE citizenid = ?', {citizenid})

        if result and #result > 0 then
            local existingSkin = json.decode(result[1].skin)
            local existingClothes = json.decode(result[1].clothes)

            for k, v in pairs(skin) do
                existingSkin[k] = v
            end

            for k, v in pairs(clothes) do
                existingClothes[k] = v
            end

            local encodedSkin = json.encode(existingSkin)
            local encodedclothes = json.encode(existingClothes)
            MySQL.Async.execute('UPDATE playerskins SET skin = @skin, clothes = @clothes WHERE citizenid = @citizenid',
            {
                ['citizenid'] = citizenid,
                ['skin'] = encodedSkin,
                ['clothes'] = encodedclothes,
            }, function(rowsChanged)
            end)
        end
    else
        MySQL.Async.insert('INSERT INTO playerskins (citizenid, skin, clothes) VALUES (?, ?, ?);', { citizenid, encode, encode2 })
        TriggerClientEvent('rsg-spawn:client:setupSpawnUI', source, encode, true)
    end
end)

RegisterServerEvent('rsg-appearance:SetPlayerBucket')
AddEventHandler('rsg-appearance:SetPlayerBucket', function(b, random)
    if random then
        local BucketID = RSGCore.Shared.RandomInt(1000, 9999)
        SetRoutingBucketPopulationEnabled(BucketID, false)
        SetPlayerRoutingBucket(source, BucketID)
    else
        SetPlayerRoutingBucket(source, b)
    end
end)

RegisterServerEvent('rsg-appearance:LoadSkin')
AddEventHandler('rsg-appearance:LoadSkin', function()
    local _source = source
    local User = RSGCore.Functions.GetPlayer(source)
    local citizenid = User.PlayerData.citizenid
    local skins = MySQL.Sync.fetchAll('SELECT * FROM playerskins WHERE citizenid = ?', {citizenid})
    if skins[1] then
        local skin = skins[1].skin
        local clothes = skins[1].clothes  -- Assuming you have a 'clothes' column in your table
        local decodedSkin = json.decode(skin)
        local decodedClothes = json.decode(clothes)
        TriggerClientEvent("rsg-appearance:ApplySkin", _source, decodedSkin, decodedClothes)
    else
        TriggerClientEvent("rsg-appearance:OpenCreator", _source)
    end
end)


RegisterServerEvent("rsg-appearance:deleteSkin")
AddEventHandler("rsg-appearance:deleteSkin", function(license, Callback)
    local _source = source
    local id
    for k, v in ipairs(GetPlayerIdentifiers(_source)) do
        if string.sub(v, 1, string.len("steam:")) == "steam:" then
            id = v
            break
        end
    end
    local Callback = callback
    MySQL.Async.fetchAll('DELETE FROM playerskins WHERE `citizenid`= ? AND`license`= ?;', {id, license})
end)

RegisterServerEvent('rsg-appearance:updategender', function(gender)
    local Player = RSGCore.Functions.GetPlayer(source)
    local citizenid = Player.PlayerData.citizenid
    local license = RSGCore.Functions.GetIdentifier(source, 'license')

    local result = MySQL.Sync.fetchAll('SELECT * FROM players WHERE citizenid = ? AND license = ?', {citizenid, license})
    local Charinfo = json.decode(result[1].charinfo)
    Charinfo.gender = gender
    MySQL.Async.execute("UPDATE players SET `charinfo` = ? WHERE `citizenid`= ? AND `license`= ?", {json.encode(Charinfo), citizenid, license})
    Player.Functions.Save()
end)

--------------------------------------------------------------------------------------------------
-- start version check
--------------------------------------------------------------------------------------------------
CheckVersion()
