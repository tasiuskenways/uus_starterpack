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

local function claimStarterpack()
    local items = exports.ox_inventory:Search('count', Config.Items)
    if items > 0 then
        if lib.progressBar({
                duration = 10000,
                label = "Claiming Starterpack",
                canCancel = true,
                useWhileDead = false,
                disable = {
                    move = true,
                    car = true,
                    mouse = false,
                    combat = true
                },
                anim = {
                    dict = 'misscarsteal4@actor',
                    clip = 'actor_berating_loop',
                    flag = 1
                }
            }) then
            local vehPlate = lib.callback.await('uus_starterpack:claimStPack', false)
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
        end
    else
        lib.notify({
            title = 'Starterpack',
            description = 'Failed to claim Starterpack. You Dont Have Any ' .. Config.Items,
            type = 'error'
        })
    end
end

local function initStarterpack()
    spawnedPed = CreatePedAtCoords(Config.PedModels, Config.Position, Config.Scenario)
    exports.ox_target:addLocalEntity(spawnedPed, {
        {
            name = 'uus_starterpack:claimStPack',
            icon = 'fab fa-box',
            label = "Claim Starter Pack",
            distance = 1.6,
            items = Config.Items,
            onSelect = function()
                claimStarterpack()
            end
        }
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
