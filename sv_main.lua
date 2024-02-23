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

local function checkEligible(cid)
    local result = MySQL.Sync.fetchScalar('SELECT starterpack FROM players WHERE citizenid = ?', { cid })
    -- print(result)
    if result == 0 then
        return true
    else
        return false
    end
end

lib.callback.register('uussam_starterpack:claimStPack', function(source)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local cid = Player.PlayerData.citizenid
    local iseligible = checkEligible(cid)
    local plate = RandomPlate()
    local vehicle = Config.Vehicle
    -- print(iseligible)
   
    if iseligible then
        exports.ox_inventory:AddItem(source, 'nasikikil', 5)
        exports.ox_inventory:AddItem(source, 'esteh', 5)
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
        local affectedRows = MySQL.update.await('UPDATE players SET starterpack = ? WHERE citizenid = ?', {
            1, cid
        })
        return plate
    else
        return false
    end
end)

lib.callback.register('uussam_starterpack:claimStPackW', function(source)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local cid = Player.PlayerData.citizenid
    local iseligible = checkEligible(cid)
    local plate = RandomPlate()
    local vehicle = Config.VehicleW
    -- print(iseligible)
   
    if iseligible then
        exports.ox_inventory:AddItem(source, 'nasikikil', 5)
        exports.ox_inventory:AddItem(source, 'esteh', 5)
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
        local affectedRows = MySQL.update.await('UPDATE players SET starterpack = ? WHERE citizenid = ?', {
            1, cid
        })
        return plate
    else
        return false
    end
end)

