local function OpenBossMenuMoney()
    lib.registerContext({
        id = 'ledjo_gang_boss_money',
        title = L('boss.title'),
        menu = 'ledjo_gang_boss',
        options = {
            {
                title = L('boss.withdraw.title'),
                onSelect = function()
                    local input = lib.inputDialog(L('boss.deposit.howmuch'), {L('boss.deposit.amount')})
                    if not input then return end
                    TriggerServerEvent('ledjo_gang:withdraw', tonumber(input[1]))
                end
            },

            {
                title = L('boss.deposit.title'),
                onSelect = function()
                    local input = lib.inputDialog(L('boss.deposit.howmuch'), {L('boss.deposit.amount')})
                    if not input then return end
                    TriggerServerEvent('ledjo_gang:deposit', tonumber(input[1]))
                end
            }
        }
    })
    return lib.showContext('ledjo_gang_boss_money')
end

local function OpenBossMenuPlayers()
    lib.registerContext({
        id = 'ledjo_gang_boss_people',
        title = L('boss.players'),
        menu = 'ledjo_gang_boss',
        options = {
            {
                title = L('boss.players.hire'),
                onSelect = function()
                    local id, ped = lib.getClosestPlayer(GetEntityCoords(cache.ped), 3.5, false)

                    if id then
                        local data = lib.callback.await('ledjo_gang:fetchPlayerData', 100, GetPlayerServerId(id))

                        if data then
                            if data.job == GetGang() then
                                sendNotify('', L('boss.players.hire.samejob'))
                                return
                            end

                            lib.registerContext({
                                id = 'ledjo_gang_boss_hire',
                                title = L('boss.players'),
                                menu = 'ledjo_gang_boss_people',
                                options = {
                                    {
                                        title = data.name,
                                        onSelect = function (args)
                                            TriggerServerEvent('ledjo_gang:hirePlayer', data.id)
                                        end
                                    }

                                }
                            })

                            lib.showContext('ledjo_gang_boss_hire')
                        end
                    else
                        sendNotify('', L('boss.nonearby'), 'error')
                    end
                end
            },
            {
                title = L('boss.players.members'),
                onSelect = function()
                    lib.registerContext({
                        id = 'ledjo_gang_boss_players_handlers',
                        title = L('boss.players.chose'),
                        menu = 'ledjo_gang_boss_people',
                        options = {
                            {
                                title = L('boss.players.online'),
                                onSelect = function()
                                    local players = lib.callback.await('ledjo_gang:fetchPlayers', false, 'online')
                                    local options = {}

                                    for i = 1, #players do
                                        local data = players[i]
                                    
                                        options[#options + 1] = {
                                            title = data.name,
                                            arrow = true,
                                            description = L('boss.players.description'):format(data.job),
                                            identifier = data.identifier,
                                            onSelect = function()
                                                lib.registerContext({
                                                    id = 'ledjo_gang_boss_dghdi',
                                                    title = L('boss.title'),
                                                    menu = 'ledjo_gang_boss_players',
                                                    options = {
                                                        {
                                                            title = L('boss.players.grade'),
                                                            onSelect = function()
                                                                local grades, jobName = lib.callback.await('ledjo_gang:fetchGrades', false)
                                                                local optins = {}

                                                                if IsQBCore() then
                                                                    for _, info in pairs(grades.grades) do
                                                                        optins[#optins + 1] = {
                                                                            title = info.name,
                                                                            serverEvent = 'ledjo_gang:setjob',
                                                                            args = {
                                                                                identifier = data.identifier,
                                                                                job = jobName,
                                                                                grade = _,
                                                                            }
                                                                        }
                                                                    end
    
    
                                                                    table.sort(optins, function (a, b)
                                                                        return a.args.grade < b.args.grade
                                                                    end)
                                                                else
                                                                    for _, info in pairs(grades) do
                                                                        optins[#optins + 1] = {
                                                                            title = info.label,
                                                                            serverEvent = 'ledjo_gang:setjob',
                                                                            args = {
                                                                                identifier = data.identifier,
                                                                                job = info.job_name,
                                                                                grade = info.grade,
                                                                            }
                                                                        }
                                                                    end
    
    
                                                                    table.sort(optins, function (a, b)
                                                                        return a.args.grade < b.args.grade
                                                                    end)
                                                                end
                
                                                                lib.registerContext({
                                                                    id = 'ledjo_gang_boss_players_grades',
                                                                    menu = 'ledjo_gang_boss_dghdi',
                                                                    title = 'Update Grade',
                                                                    options = optins
                                                                    
                                                                })

                                                                lib.showContext('ledjo_gang_boss_players_grades')
                                                            end
                                                        },
                                                        {
                                                            title = L('boss.players.grade.derank'),
                                                            serverEvent = 'ledjo_gang:firePlayer',
                                                            args = { identifier = data.identifier }
                                                        }
                                                    }
                                                })


                                                lib.showContext('ledjo_gang_boss_dghdi')
                                            end
                                        }
                                    end


                                    lib.registerContext({
                                        id = 'ledjo_gang_boss_players',
                                        title = L('boss.players.list'):format(#options),
                                        menu = 'ledjo_gang_boss_players_handlers',
                                        options = options
                                        
                                    })

                                    lib.showContext('ledjo_gang_boss_players')
                                end
                            },

                            {
                                title = L('boss.players.offline'),
                                onSelect = function ()
                                    local players = lib.callback.await('ledjo_gang:fetchPlayers', false, 'offline')
                                    if #players == 0 then
                                        return sendNotify('', L('boss.no.players.offline', 'error'))
                                    end
                                    local xyz = {}

                                    for i = 1, #players do
                                        local data = players[i]
                                    
                                        xyz[#xyz + 1] = {
                                            title = data.name,
                                            arrow = true,
                                            description = L('boss.players.description'):format(data.job),
                                            onSelect = function()
                                                lib.registerContext({
                                                    id = 'ledjo_gang_boss_dghdi',
                                                    title = L('boss.title'),
                                                    menu = 'ledjo_gang_boss_players',
                                                    options = {
                                                        {
                                                            title = L('boss.players.grade'),
                                                            onSelect = function()
                                                                local grades = lib.callback.await('ledjo_gang:fetchGrades', false)
                                                                local optins = {}

                                                                for _, info in pairs(grades) do
                                                                    optins[#optins + 1] = {
                                                                        title = info.label,
                                                                        serverEvent = 'ledjo_gang:setjob',
                                                                        args = {
                                                                            identifier = data.identifier,
                                                                            job = info.job_name,
                                                                            grade = info.grade,
                                                                        }
                                                                    }
                                                                end


                                                                table.sort(optins, function (a, b)
                                                                    return a.args.grade < b.args.grade
                                                                end)
                
                                                                lib.registerContext({
                                                                    id = 'ledjo_gang_boss_players_grades',
                                                                    title = 'Update Grade',
                                                                    menu = 'ledjo_gang_boss_dghdi',
                                                                    options = optins
                                                                    
                                                                })

                                                                lib.showContext('ledjo_gang_boss_players_grades')
                                                            end
                                                        },
                                                        {
                                                            title = L('boss.players.grade.derank'),
                                                            serverEvent = 'ledjo_gang:firePlayer',
                                                            args = { identifier = data.identifier }
                                                        }
                                                    }
                                                })


                                                lib.showContext('ledjo_gang_boss_dghdi')
                                            end
                                        }
                                    end

                                    lib.registerContext({
                                        id = 'ledjo_gang_boss_players',
                                        title = L('boss.players.list'):format(#xyz),
                                        menu = 'ledjo_gang_boss_players_handlers',
                                        options = xyz
                                        
                                    })

                                    lib.showContext('ledjo_gang_boss_players')
                                end
                            }
                        }
                    })

                    lib.showContext('ledjo_gang_boss_players_handlers')
                end
            }
        }
    })

    return lib.showContext('ledjo_gang_boss_people')
end


function OpenBossMenu()
    lib.registerContext({
        id = 'ledjo_gang_boss',
        title = L('boss.title'),
        options = {
            {
                title = L('boss.balance'):format(Mafia[GetGang()].money),
                icon = 'dollar-sign'
            },
            {
                title = L('boss.players.moneyhandler'),
                icon = 'dollar-sign',
                onSelect = function()
                    OpenBossMenuMoney()
                end

            },
            {
                title = L('boss.players'),
                icon = 'fa-user',
                onSelect = function()
                    OpenBossMenuPlayers()
                end
            },
        }
    })

    return lib.showContext('ledjo_gang_boss')
end