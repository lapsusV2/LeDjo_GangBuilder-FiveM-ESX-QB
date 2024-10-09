if not IsESX() then return end

ESX = exports['es_extended']:getSharedObject()

function GetGang(src)
    local xPlayer = ESX.GetPlayerFromId(src)

    if xPlayer then
        if Config.setJobField == 'job' then
            return xPlayer.job.name
        else
            local gang = xPlayer.getMeta('gang')

            for k,v in pairs(gang) do
                return v.job_name
            end
        end
    end

    return false
end

function GetMoney(src)
    local xPlayer = ESX.GetPlayerFromId(src)

    if xPlayer then
        return xPlayer.getMoney()
    end

    return 0
end

function RemoveMoney(src, amount)
    local xPlayer = ESX.GetPlayerFromId(src)

    if xPlayer then
        xPlayer.removeMoney(amount)
    end
end


function SetGang(src, name, grade)
    local xPlayer = ESX.GetPlayerFromId(src)

    if xPlayer then
        if Config.setJobField == 'job' then
            xPlayer.setJob(name, grade)
        elseif Config.setJobField == 'metadata' then
            xPlayer.clearMeta('gang')
            xPlayer.setMeta('gang', name, Jobs[name].grades[tostring(grade)])
        end
    end
end

function GradeUpdateBoss(src, data)
    local xPlayer = ESX.GetPlayerFromId(src)
    local xTarget = ESX.GetPlayerFromIdentifier(data.identifier)

    if Config.setJobField == 'job' then
        if isBoss(src) then
            if xTarget then
                xTarget.setJob(data.job, data.grade)
                DiscordLog(L('discord.gradeUpdate.online.title'), L('discord.gradeUpdate.online.msg'):format(GetPlayerName(xPlayer.source), GetPlayerName(xTarget.source), data.grade), Discord.TagEveryoneFields.updateGradeOnline)
            else
                MySQL.update('UPDATE `users` SET `job` = ?, `job_grade` = ? WHERE `identifier` = ?', {data.job, data.grade, data.identifier})
                DiscordLog(L('discord.gradeUpdate.offline.title'), L('discord.gradeUpdate.offline.msg'):format(GetPlayerName(xPlayer.source), data.identifier, data.grade), Discord.TagEveryoneFields.updateGradeOnline)
            end
        else
            print( ('%s (%s) tried to update grade for %s but isnt boss'):format(GetPlayerName(xPlayer.source), xPlayer.identifier, data.identifier) )
            DiscordLog(L('discord.gradeUpdate.title.cheater'), L('discord.gradeUpdate.msg.cheater'):format(GetPlayerName(xPlayer.source), data.identifier), Discord.TagEveryoneFields.updateGradeCheater)
        end
    else
        if isBoss(src) then
            if xTarget then
                xTarget.clearMeta('gang')
                xTarget.setMeta('gang', data.job, Jobs[data.job].grades[tostring(data.grade)])
                DiscordLog(L('discord.gradeUpdate.online.title'), L('discord.gradeUpdate.online.msg'):format(GetPlayerName(xPlayer.source), GetPlayerName(xTarget.source), data.grade), Discord.TagEveryoneFields.updateGradeOnline)
            else
                local gang = {}
                gang['gang'] = table.create(0, 0)
                gang['gang'][data.job] = Jobs[data.job].grades[tostring(data.grade)]
                MySQL.update('UPDATE `users` SET `metadata` = ? WHERE `identifier` = ?', {json.encode(gang), data.identifier})
                DiscordLog(L('discord.gradeUpdate.offline.title'), L('discord.gradeUpdate.offline.msg'):format(GetPlayerName(xPlayer.source), data.identifier, data.grade), Discord.TagEveryoneFields.updateGradeOnline)
            end
        else
            print( ('%s (%s) tried to update grade for %s but isnt boss'):format(GetPlayerName(xPlayer.source), xPlayer.identifier, data.identifier) )
        end
    end
end

function AddMoney(src, amount)
    local xPlayer = ESX.GetPlayerFromId(src)

    if xPlayer then
        xPlayer.addMoney(amount)
    end
end

function isBoss(src)
    local xPlayer = ESX.GetPlayerFromId(src)

    if Config.setJobField == 'job' then
        if xPlayer then
            return xPlayer.job.grade_name == 'boss'
        end
    else
        local gang = xPlayer.getMeta('gang')

        for k, v in pairs(gang) do
            return v.name == 'boss' and true or false
        end
    end
end