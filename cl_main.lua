local spawnedPed = nil
local QBCore = exports['qb-core']:GetCoreObject()


local function CreatePedAtCoords(pedModel, coords, scenario)
    pedModel = type(pedModel) == "string" and joaat(pedModel) or pedModel
    lib.requestModel(pedModel)
    local ped = CreatePed(0, pedModel, coords.x, coords.y, coords.z - 0.98, coords.w, false, false)
    TaskStartScenarioInPlace(ped, scenario, true)
    FreezeEntityPosition(ped, true)
    SetEntityVisible(ped, true)
    SetEntityInvincible(ped, true)
    PlaceObjectOnGroundProperly(ped)
    SetBlockingOfNonTemporaryEvents(ped, true)
    return ped
end

local function claimItemStarterpack()
   -- local items = exports.ox_inventory:Search('count', Config.Items)
    ExecuteCommand('e clipboard')
    QBCore.Functions.Progressbar("Claim_staterpack", Lang:t('claimst.claim_progress'), 5000, false, true, {
        disableMovement = false,
        disableCarMovement = false,
        disableMouse = false,
        disableCombat = true,
    }, {}, {}, {}, function() -- Done
        -- Check genre/kelamin
        local player = QBCore.Functions.GetPlayerData()
        local gender = player.charinfo.gender or 0
       -- local playergen = ''
        ExecuteCommand('e c')
        if gender == 0 then
            --playergen = 'kuruma'
            local vehPlate = lib.callback.await('uussam_starterpack:claimStPack', false)
            if vehPlate then
                QBCore.Functions.TriggerCallback('QBCore:Server:SpawnVehicle', function(netId)
                    local veh = NetToVeh(netId)
                    SetVehicleNumberPlateText(veh, vehPlate)
                    SetEntityHeading(veh, Config.VehicleSpawn.w)
                    exports['cdn-fuel']:SetFuel(veh, 100.0)
                    TaskWarpPedIntoVehicle(cache.ped, veh, -1)
                    TriggerEvent("vehiclekeys:client:SetOwner", QBCore.Functions.GetPlate(veh))
                    SetVehicleEngineOn(veh, true, true)
                end, Config.Vehicle, Config.VehicleSpawn, true)
            end
        else
            --playergen = 'e89'
            local vehPlate = lib.callback.await('uussam_starterpack:claimStPackW', false)
            if vehPlate then
                QBCore.Functions.TriggerCallback('QBCore:Server:SpawnVehicle', function(netId)
                    local veh = NetToVeh(netId)
                    SetVehicleNumberPlateText(veh, vehPlate)
                    SetEntityHeading(veh, Config.VehicleSpawn.w)
                    exports['cdn-fuel']:SetFuel(veh, 100.0)
                    TaskWarpPedIntoVehicle(cache.ped, veh, -1)
                    TriggerEvent("vehiclekeys:client:SetOwner", QBCore.Functions.GetPlate(veh))
                    SetVehicleEngineOn(veh, true, true)
                end, Config.VehicleW, Config.VehicleSpawn, true)
            end
        end
        print(gender)

    end)
end

local function initStarterpack()
    spawnedPed = CreatePedAtCoords(Config.PedModels, Config.Position, Config.Scenario)
    exports.ox_target:addLocalEntity(spawnedPed, {
        {
            name = 'uussam_claimitembygender:claimItemByGender',
            icon = 'fab fa-box',
            label = "Claim Starterpack",
            distance = 1.6,
          --  items = Config.Items,
            onSelect = function()
                claimItemStarterpack()
            end
        },

    })
end

AddEventHandler('onResourceStart', function(resource)
    if not cache.resource then return end
    initStarterpack()
end)

RegisterNetEvent('QBCore:Client:OnPlayerLoaded', function()
    initStarterpack()
end)

RegisterNetEvent('QBCore:Client:OnPlayerUnload', function()
    DeleteEntity(spawnedPed)
end)

AddEventHandler('onResourceStop', function(resource)
    if not cache.resource then return end
    DeleteEntity(spawnedPed)
end)
