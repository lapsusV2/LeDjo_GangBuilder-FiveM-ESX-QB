if not IsQBCore() then return end
QBCore = exports['qb-core']:GetCoreObject()


function GetGang(src)
    local Player = QBCore.Functions.GetPlayer(src)

    if Player then
        return Player.PlayerData.gang.name
    end

    return false
end

function GetMoney(src)
    local Player = QBCore.Functions.GetPlayer(src)

    if Player then
        return Player.PlayerData.money['cash']
    end

    return 0
end

function GradeUpdateBoss(src, data)
    local xPlayer = QBCore.Functions.GetPlayer(src)
    local xTarget = QBCore.Functions.GetPlayerByCitizenId(data.identifier)

    if xPlayer.PlayerData.gang.isboss == true then
        if xTarget then
            xTarget.Functions.SetGang(data.job, data.grade)
            DiscordLog(L('discord.gradeUpdate.online.title'), L('discord.gradeUpdate.online.msg'):format(GetPlayerName(xPlayer.PlayerData.source), GetPlayerName(xTarget.PlayerData.source), data.grade), Discord.TagEveryoneFields.updateGradeOnline)
        end
    else
        print( ('%s (%s) tried to update grade for %s but isnt boss'):format(GetPlayerName(xPlayer.PlayerData.source), xPlayer.identifier, data.identifier) )
        DiscordLog(L('discord.gradeUpdate.title.cheater'), L('discord.gradeUpdate.msg.cheater'):format(GetPlayerName(xPlayer.PlayerData.source), data.identifier), Discord.TagEveryoneFields.updateGradeCheater)
    end
end

function RemoveMoney(src, amount)
    local Player = QBCore.Functions.GetPlayer(src)

    if Player then
        Player.Functions.RemoveMoney('cash', amount)
    end
end

function isBoss(src)
    local Player = QBCore.Functions.GetPlayer(src)

    if Player then
        return Player.PlayerData.gang.isboss
    end

    return false
end

function AddMoney(src, amount)
    local Player = QBCore.Functions.GetPlayer(src)

    if Player then
        Player.Functions.AddMoney('cash', amount)
    end
end

function SetGang(src, name, grade)
    local Player = QBCore.Functions.GetPlayer(src)

    if Player then
        Player.Functions.SetGang(name, tostring(grade))
    end
end