local QBCore = exports['qb-core']:GetCoreObject()

local function RandomPlate()
    local plate = lib.string.random('AAAA1111', 8)
    local result = MySQL.Sync.fetchScalar('SELECT plate FROM player_vehicles WHERE plate = ?', { plate })
    if result then
        return RandomPlate()
    else
        return plate:upper()
    end
end

lib.callback.register('uus_starterpack:claimStPack', function(source)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local cid = Player.PlayerData.citizenid
    local plate = RandomPlate()
    local vehicle = Config.Vehicle
    MySQL.Async.insert(
        'INSERT INTO player_vehicles (license, citizenid, vehicle, hash, mods, plate, garage) VALUES (?, ?, ?, ?, ?, ?, ?)',
        {
            Player.PlayerData.license,
            cid,
            vehicle,
            GetHashKey(vehicle),
            '{}',
            plate,
            Config.Garage
        })
    local success = exports.ox_inventory:RemoveItem(src, Config.Items, 1)
    if success then
        return plate
    else
        return false
    end
end)
