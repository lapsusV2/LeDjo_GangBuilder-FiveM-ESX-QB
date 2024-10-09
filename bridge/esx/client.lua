if not IsESX() then return end

local ESX = exports['es_extended']:getSharedObject()

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
	PlayerData = xPlayer
	PlayerLoaded = true
	while not PlayerLoaded do Wait(100) end
	SetUpMafia()
end)


RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	PlayerData.job = job

    SetUpMafia()
end)

RegisterNetEvent('esx:onPlayerLogout', function()
    table.wipe(PlayerData)
    PlayerLoaded = false
end)

RegisterNetEvent('esx:updatePlayerData', function(key, val)
    if key == 'metadata' then
        PlayerData.metadata = val
    end
end)


function IsBoss()
    if Config.setJobField == 'job2' then
        return PlayerData.job.grade_name == 'boss'
    else
        for k,v in pairs(PlayerData.metadata.gang) do
            return v.name == 'boss'
        end
    end
end


function GetGang()
    if Config.setJobField == 'job2' then
        return PlayerData.job.name
    else
        if PlayerData.metadata and PlayerData.metadata.gang then
            for k,v in pairs(PlayerData.metadata.gang) do
                return v.job_name
            end
        end

        return nil
    end
end

AddEventHandler('onResourceStart', function(resource)
    if cache.resource == resource then
        Wait(500)
        PlayerData = ESX.GetPlayerData()
        PlayerLoaded = true
        SetUpMafia()
    end
end)