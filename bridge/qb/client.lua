if not IsQBCore() then return end

local QBCore = exports['qb-core']:GetCoreObject()

AddEventHandler('QBCore:Client:OnPlayerLoaded', function()
    PlayerData = QBCore.Functions.GetPlayerData()
    PlayerLoaded = true

    Wait(250)
	SetUpMafia()
end)

RegisterNetEvent('QBCore:Client:OnPlayerUnload', function()
    PlayerData = {}
    PlayerLoaded = false
end)

RegisterNetEvent('QBCore:Player:SetPlayerData', function(val)
    PlayerData = val
end)

RegisterNetEvent('QBCore:Client:OnGangUpdate', function(JobInfo)
	PlayerData.gang = JobInfo

    OnGangUpdate()
end)

function IsBoss()
    return PlayerData.gang.isboss
end

function GetGang()
    return PlayerData.gang.name
end


AddEventHandler('onResourceStart', function(resource)
	if resource == cache.resource then
		Wait(1500)
		PlayerData = QBCore.Functions.GetPlayerData()
		SetUpMafia()
	end
end)