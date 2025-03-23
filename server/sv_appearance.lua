RSGCore = exports['rsg-core']:GetCoreObject()

-- Begin conversion commands & events
-- These three commands &  events are to convert beards, hair & teeth indexes in your database into hashes. Remove them & their accompanying client events if you do not intend to convert them. They are optional and exist only to make other creators lives a little easier when making character creation scripts.
RegisterCommand("fixOldBeards", function(src, args, raw)
    MySQL.query("SELECT * FROM skins", {}, function(results)
        TriggerClientEvent("fixOldBeards:doConversion", src, results)
    end)
end)

RegisterNetEvent("fixOldBeards:saveConverted")
AddEventHandler("fixOldBeards:saveConverted", function(updates)
    for _, record in ipairs(updates) do
        MySQL.update("UPDATE skins SET skin = ? WHERE id = ?", { record.json, record.id })
    end
    print("Fix Old Beards Complete")
end)

RegisterCommand("fixOldHair", function(src, args, raw)
    MySQL.query("SELECT * FROM skins", {}, function(results)
        TriggerClientEvent("fixOldHair:doConversion", src, results)
    end)
end)

RegisterNetEvent("fixOldHair:saveConverted")
AddEventHandler("fixOldHair:saveConverted", function(updates)
    for _, record in ipairs(updates) do
        MySQL.update("UPDATE skins SET skin = ? WHERE id = ?", { record.json, record.id })
    end
    print("Fix Old Hair Complete")
end)

RegisterCommand("fixOldTeeth", function(src, args, raw)
    MySQL.query("SELECT * FROM skins", {}, function(results)
        TriggerClientEvent("fixOldTeeth:doConversion", src, results)
    end)
end)

RegisterNetEvent("fixOldTeeth:saveConverted")
AddEventHandler("fixOldTeeth:saveConverted", function(updates)
    for _, record in ipairs(updates) do
        MySQL.update("UPDATE skins SET skin = ? WHERE id = ?", { record.json, record.id })
    end
    print("Fix Old Teeth Complete")
end)
-- End Conversion Commands

RegisterServerEvent('rsg-appearance:server:SaveSkin')
AddEventHandler('rsg-appearance:server:SaveSkin', function(skin, clothes, oldplayer)
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

RegisterServerEvent('rsg-appearance:server:SetPlayerBucket')
AddEventHandler('rsg-appearance:server:SetPlayerBucket', function(b, random)
    if random then
        local BucketID = RSGCore.Shared.RandomInt(1000, 9999)
        SetRoutingBucketPopulationEnabled(BucketID, false)
        SetPlayerRoutingBucket(source, BucketID)
    else
        SetPlayerRoutingBucket(source, b)
    end
end)

RegisterServerEvent('rsg-appearance:server:LoadSkin')
AddEventHandler('rsg-appearance:server:LoadSkin', function()
    local _source = source
    local User = RSGCore.Functions.GetPlayer(source)
    local citizenid = User.PlayerData.citizenid
    local skins = MySQL.Sync.fetchAll('SELECT * FROM playerskins WHERE citizenid = ?', {citizenid})
    if skins[1] then
        local skin = skins[1].skin
        local clothes = skins[1].clothes  -- Assuming you have a 'clothes' column in your table
        local decodedSkin = json.decode(skin)
        local decodedClothes = json.decode(clothes)
        TriggerClientEvent('rsg-appearance:client:ApplySkin', _source, decodedSkin, decodedClothes)
    else
        TriggerClientEvent('rsg-appearance:client:OpenCreator', _source)
    end
end)


RegisterServerEvent('rsg-appearance:server:deleteSkin')
AddEventHandler('rsg-appearance:server:deleteSkin', function(license, Callback)
    local _source = source
    local id
    for k, v in ipairs(GetPlayerIdentifiers(_source)) do
        if string.sub(v, 1, string.len('steam:')) == 'steam:' then
            id = v
            break
        end
    end
    local Callback = callback
    MySQL.Async.fetchAll('DELETE FROM playerskins WHERE `citizenid`= ? AND`license`= ?;', {id, license})
end)

RegisterServerEvent('rsg-appearance:server:updategender', function(gender)
    local Player = RSGCore.Functions.GetPlayer(source)
    local citizenid = Player.PlayerData.citizenid
    local license = RSGCore.Functions.GetIdentifier(source, 'license')

    local result = MySQL.Sync.fetchAll('SELECT * FROM players WHERE citizenid = ? AND license = ?', {citizenid, license})
    local Charinfo = json.decode(result[1].charinfo)
    Charinfo.gender = gender
    MySQL.Async.execute('UPDATE players SET `charinfo` = ? WHERE `citizenid`= ? AND `license`= ?', {json.encode(Charinfo), citizenid, license})
    Player.Functions.Save()
end)
