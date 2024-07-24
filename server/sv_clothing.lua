RegisterServerEvent('rsg-appearance:server:saveOutfit', function(clothes, price, outfitName)
    local src = source
    local Player = RSGCore.Functions.GetPlayer(src)
    if not Player then return end
    if clothes ~= nil then
        local cashBalance = Player.PlayerData.money['cash']
        if cashBalance < price then
            TriggerClientEvent('ox_lib:notify', src, { title = 'Insufficient Funds', description = 'you don\'t have enough cash', type = 'error', duration = 5000 })
            return
        end

        Player.Functions.RemoveMoney('cash', price, 'buy-clothes')

        MySQL.execute('UPDATE playerskins SET clothes = @clothes WHERE citizenid = @citizenid', {
            ['@citizenid'] = Player.PlayerData.citizenid,
            ['@clothes'] = json.encode(clothes),
        })
        if outfitName then
            MySQL.query.await('INSERT INTO playeroutfit (citizenid, name, clothes) VALUES (@citizenid, @name, @clothes)', {
                ['@citizenid'] = Player.PlayerData.citizenid,
                ['@name'] = outfitName,
                ['@clothes'] = json.encode(clothes),
            })
        end
    end
end)

RegisterNetEvent('rsg-appearance:server:saveUseOutfit', function(clothes)
    local src = source
    local Player = RSGCore.Functions.GetPlayer(src)
    if not Player then return end
    if clothes ~= nil then
        MySQL.execute('UPDATE playerskins SET clothes = @clothes WHERE citizenid = @citizenid', {
            ['@citizenid'] = Player.PlayerData.citizenid,
            ['@clothes'] = json.encode(clothes),
        })
    end
end)

RegisterServerEvent('rsg-appearance:server:DeleteOutfit')
AddEventHandler('rsg-appearance:server:DeleteOutfit', function(name)
    local src = source
    local _name = name
    local Player = RSGCore.Functions.GetPlayer(src)
    local citizenid = Player.PlayerData.citizenid
    MySQL.Async.fetchAll('DELETE FROM playeroutfit WHERE citizenid = ? AND name =  ?', {citizenid, _name})
end)

lib.callback.register('rsg-appearance:server:LoadClothes', function(source)
    local Player = RSGCore.Functions.GetPlayer(source)
    local citizenid = Player.PlayerData.citizenid
    local clothes = {}
    local Result = MySQL.query.await('SELECT clothes FROM playerskins WHERE citizenid = ?', { citizenid })

    if Result[1] ~= nil and Result[1].clothes ~= nil then
        clothes = json.decode(Result[1].clothes)
    end

    return clothes
end)

lib.callback.register('rsg-appearance:server:getOutfits', function(source)
    local Player = RSGCore.Functions.GetPlayer(source)
    local outfit = {}
    local Result = MySQL.query.await('SELECT * FROM playeroutfit WHERE citizenid=@citizenid', {['@citizenid'] = Player.PlayerData.citizenid})

    for i = 1, #Result do
        Result[i].clothes = json.decode(Result[i].clothes)
        Result[i].name = Result[i].name
        outfit[#outfit+1] = Result[i]
    end

    return outfit
end)