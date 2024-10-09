local function RotationToDirection(rotation)
	local adjustedRotation =
	{
		x = (math.pi / 180) * rotation.x,
		y = (math.pi / 180) * rotation.y,
		z = (math.pi / 180) * rotation.z
	}
	local direction =
	{
		x = -math.sin(adjustedRotation.z) * math.abs(math.cos(adjustedRotation.x)),
		y = math.cos(adjustedRotation.z) * math.abs(math.cos(adjustedRotation.x)),
		z = math.sin(adjustedRotation.x)
	}
    
	return direction
end

local function RayCastGamePlayCamera(distance)
    local cameraRotation = GetGameplayCamRot()
	local cameraCoord = GetGameplayCamCoord()
	local direction = RotationToDirection(cameraRotation)
	local destination =
	{
		x = cameraCoord.x + direction.x * distance,
		y = cameraCoord.y + direction.y * distance,
		z = cameraCoord.z + direction.z * distance
	}
	local a, b, c, d, e = GetShapeTestResult(StartShapeTestRay(cameraCoord.x, cameraCoord.y, cameraCoord.z, destination.x, destination.y, destination.z, -1, cache.ped, 0))

	return b, c, e
end

RegisterNetEvent('ledjo_gang:createNew', function()
    local data = {}

    local input = lib.inputDialog(L('creator'), {
        {type = 'input', label = L('creator.name'), required = true},
        {type = 'input', label = L('creator.label'), required = true},
        {type = 'input', label = L('creator.pw'), description = L('creator.pw.description'), required = true},
        {type = 'number', label = L('creator.vehicles'), icon = 'car', description = L('creator.vehicles.description'), min = 1},
        {type = 'number', label = L('creator.heli'), icon = 'helicopter', description = L('creator.heli.description'), min = 1},
        {type = 'number', label = L('creator.grades'), icon = 'user', description = L('creator.grades.description'), min = 1, required = true}
    })

    if not input then return end

    local name = input[1]
    local label = input[2]
    local password = input[3]
    local vehicles = input[4]
    local helicopters = input[5]
    local grades = input[6]
    
    data.name = name:lower()
    data.label = label
    data.password = password

    local gradesTable = {}

    if IsQBCore() then
        if grades and grades > 0 then
            for i = 1, grades do
                local input = lib.inputDialog(L('grade'):format(i, grades), {
                    {type = 'input', label = L('grade.label'), placeholder = L('grade.label.placeholder'), required = true},
                })

                if not input then return end

                local grade = i
                local label = input[1]

                gradesTable[tostring(grade)] = {
                    name = label,
                    isboss = i == grades and true or nil
                }


            end

            data.grades = gradesTable
        end
    else
        if grades and grades > 0 then
            for i = 1, grades do
                local input = lib.inputDialog(L('grade'):format(i, grades), {
                    {type = 'input', label = L('grade.name'), placeholder = L('grade.placeholder'), required = true},
                    {type = 'input', label = L('grade.label'), placeholder = L('grade.label.placeholder'), required = true},
                    {type = 'number', label = L('grade.salary'), min = 0, required = true},
                })
    
                if not input then return end
    
                local job_name = data.name
                local grade = i
                local name = input[1]:lower()
                local label = input[2]
                local salary = input[3]
    
                if i == grades then
                    name = 'boss'
                end
    
                gradesTable[name] = {
                    job_name = job_name,
                    grade = grade,
                    name = name,
                    label = label,
                    salary = salary
                }
            end
    
            data.grades = gradesTable
        end
    end

    local veh = {}

    if vehicles and vehicles > 0 then
        for i = 1, vehicles do
            local input = lib.inputDialog(L('veh'), {
                {type = 'input', label = L('veh.label'), placeholder = L('veh.label.placeholder')},
                {type = 'input', label = L('veh.spawncode'), placeholder = L('veh.spawncode.placeholder')},
                {type = 'color', label = L('veh.color1'), description = L('veh.optional')},
                {type = 'color', label = L('veh.color2'), description = L('veh.optional')},
                {type = 'checkbox', label = L('veh.fulltune')}
            })
            if not input then return end

            local vehName = input[1]
            local vehSpawn = input[2]
            local primaryColor = input[3]
            local secondaryColor = input[4]
            local fulltune = input[5]
    
            if input then
                veh[vehName] = {
                    label = vehName,
                    model = vehSpawn,
                    primaryColor = primaryColor or false,
                    secondaryColor = secondaryColor or false,
                    fulltune = fulltune,
                }
            end
        end
    end

    local heli = {}

    if helicopters and helicopters > 0 then
        for i = 1, helicopters do
            local input = lib.inputDialog(L('heli'), {
                {type = 'input', label = L('heli.label'), placeholder = L('heli.label.placeholder'), required = true},
                {type = 'input', label = L('heli.spawncode'), placeholder = L('heli.spawncode.placeholder'), required = true},
            })
            if not input then return end

            local vehName = input[1]
            local vehSpawn = input[2]

            if input then
                heli[vehName] = vehSpawn
            end
        end
    end

    local alert = lib.alertDialog({
        header = L('alert.header'),
        content = L('alert.content'),
        centered = true,
        cancel = false
    })
    
    if alert == 'confirm' then
        lib.showTextUI(L('textui.boss'))
        
        while true do
            Wait(0)
            hit, coords, entity = RayCastGamePlayCamera(100.0)
            DrawMarker(31, coords.x, coords.y, coords.z + 0.8, 0, 0, 0, 0, 0, 0, 1.2, 1.2, 0.9,25,25,204, 255, 0, 0, 0, 0)

            if IsControlJustPressed(1, 38) then
                data.BossActions = {vec3(coords.x, coords.y, coords.z + 0.8)}
                lib.hideTextUI()
                break
            end
        end

        lib.showTextUI(L('textui.veh'))
        while true do
            Wait(0)
            hit, coords, entity = RayCastGamePlayCamera(100.0)
            DrawMarker(36, coords.x, coords.y, coords.z + 0.8, 0, 0, 0, 0, 0, 0, 1.2, 1.2, 0.9,25,25,204, 255, 0, 0, 0, 0)

            if IsControlJustPressed(1, 38) then
                data.Vehicles = {vec3(coords.x, coords.y, coords.z + 0.8)}
                lib.hideTextUI()
                break
            end
        end

        lib.showTextUI(L('textui.dellveh'))
        while true do
            Wait(0)
            hit, coords, entity = RayCastGamePlayCamera(100.0)
            DrawMarker(36, coords.x, coords.y, coords.z + 0.8, 0, 0, 0, 0, 0, 0, 1.2, 1.2, 0.9,255,0,0, 255, 0, 0, 0, 0)

            if IsControlJustPressed(1, 38) then
                data.ParkVehicle = {vec3(coords.x, coords.y, coords.z + 0.8)}
                data.VehicleList = veh
                lib.hideTextUI()
                break
            end
        end

        lib.showTextUI(L('textui.stash'))
        local triggered = false
        while true do
            Wait(0)
            local heading = GetEntityHeading(cache.ped)
            hit, coords, entity = RayCastGamePlayCamera(100.0)
            if not triggered then
                local hash = `prop_ld_int_safe_01`
                RequestModel(hash)
                while not HasModelLoaded(hash) do
                    Wait(10)
                end
                sef = CreateObject(hash, coords, false, true, false)
                SetEntityCollision(sef, false, false)
                triggered = true
            end

            SetEntityCoords(sef, coords.x, coords.y, coords.z + 0.5)
            SetEntityHeading(sef, heading)
            SetEntityAlpha(sef, 180, 0)

            if IsControlJustPressed(1, 38) then
                local c = GetEntityCoords(sef)
                DeleteEntity(sef)
                data.Stash = {vector4(coords.x, coords.y, coords.z, GetEntityHeading(cache.ped))}

                lib.hideTextUI()
                break
            end
        end

        local count = 0
        for k,v in pairs(heli) do
            count += 1
        end

        if count > 0 then
            lib.showTextUI(L('textui.heli'))
            while true do
                Wait(0)
                hit, coords, entity = RayCastGamePlayCamera(100.0)
                DrawMarker(34, coords.x, coords.y, coords.z + 0.8, 0, 0, 0, 0, 0, 0, 1.2, 1.2, 0.9,25,25,204, 255, 0, 0, 0, 0)
    
                if IsControlJustPressed(1, 38) then
                    data.Helicotper = {vec3(coords.x, coords.y, coords.z + 0.8)}
                    data.HelicotperList = heli
    
                    lib.hideTextUI()
                    break
                end
            end
        end

        lib.showTextUI(L('textui.lvl'))
        while true do
            Wait(0)
            hit, coords, entity = RayCastGamePlayCamera(100.0)
            DrawMarker(21, coords.x, coords.y, coords.z + 0.8, 0, 0, 0, 0, 0, 0, 1.2, 1.2, 0.9,25,25,204, 255, 0, 0, 0, 0)

            if IsControlJustPressed(1, 38) then
                data.Lvl = {vec3(coords.x, coords.y, coords.z + 0.8)}

                lib.hideTextUI()
                break
            end
        end

        TriggerServerEvent('ledjo_gang:createNew', data, grades)
    end
end)


RegisterNetEvent('ledjo_gang:updateMarker', function(info)
    local options = {}

    for k,v in pairs(info) do
        options[#options + 1] = {
            label = v.label, value = v.value
        }
    end

    local input = lib.inputDialog('', {
        {type = 'select', label = L('update.marker.label'), options = options},
        {type = 'select', label = L('update.marker.action'), options = {
            {label = L('update.marker.boss'), value = 'boss'},
            {label = L('update.marker.vehicle'), value = 'vm'},
            {label = L('update.marker.delete'), value = 'dvm'},
            {label = L('update.marker.heli'), value = 'heli'},
            {label = L('update.marker.level'), value = 'lvl'},
            {label = L('update.marker.stash'), value = 'stash'},
        }
    }})

    if not input then return end
    local name = input[1]
    local type = input[2]

    local data = {}

    if Mafia[name] then
        if type == 'boss' then
            lib.showTextUI(L('textui.boss'))
            
            while true do
                Wait(0)
                hit, coords, entity = RayCastGamePlayCamera(100.0)
                DrawMarker(31, coords.x, coords.y, coords.z + 0.8, 0, 0, 0, 0, 0, 0, 1.2, 1.2, 0.9,25,25,204, 255, 0, 0, 0, 0)
    
                if IsControlJustPressed(1, 38) then
                    data = {vec3(coords.x, coords.y, coords.z + 0.8)}
                    lib.hideTextUI()
                    TriggerServerEvent('ledjo_gang:updateMarker', name, type, data)
                    break
                end
            end
        elseif type == 'vm' then
            lib.showTextUI(L('textui.veh'))

            while true do
                Wait(0)
                hit, coords, entity = RayCastGamePlayCamera(100.0)
                DrawMarker(36, coords.x, coords.y, coords.z + 0.8, 0, 0, 0, 0, 0, 0, 1.2, 1.2, 0.9,25,25,204, 255, 0, 0, 0, 0)
    
                if IsControlJustPressed(1, 38) then
                    data = {vec3(coords.x, coords.y, coords.z + 0.8)}
                    lib.hideTextUI()
                    TriggerServerEvent('ledjo_gang:updateMarker', name, type, data)
                    break
                end
            end
        elseif type == 'dvm' then
            lib.showTextUI(L('textui.dellveh'))
            while true do
                Wait(0)
                hit, coords, entity = RayCastGamePlayCamera(100.0)
                DrawMarker(36, coords.x, coords.y, coords.z + 0.8, 0, 0, 0, 0, 0, 0, 1.2, 1.2, 0.9,255,0,0, 255, 0, 0, 0, 0)
    
                if IsControlJustPressed(1, 38) then
                    data = {vec3(coords.x, coords.y, coords.z + 0.8)}
                    lib.hideTextUI()
                    TriggerServerEvent('ledjo_gang:updateMarker', name, type, data)
                    break
                end
            end
        elseif type == 'heli' then
            if not Mafia[name].helicotper then
            else
                lib.showTextUI(L('textui.heli'))
                while true do
                    Wait(0)
                    hit, coords, entity = RayCastGamePlayCamera(100.0)
                    DrawMarker(34, coords.x, coords.y, coords.z + 0.8, 0, 0, 0, 0, 0, 0, 1.2, 1.2, 0.9,25,25,204, 255, 0, 0, 0, 0)
        
                    if IsControlJustPressed(1, 38) then
                        data.Helicotper = {vec3(coords.x, coords.y, coords.z + 0.8)}
                        TriggerServerEvent('ledjo_gang:updateMarker', name, type, data)
                        lib.hideTextUI()
                        break
                    end
                end
            end
        elseif type == 'lvl' then
            lib.showTextUI(L('textui.lvl'))
            while true do
                Wait(0)
                hit, coords, entity = RayCastGamePlayCamera(100.0)
                DrawMarker(21, coords.x, coords.y, coords.z + 0.8, 0, 0, 0, 0, 0, 0, 1.2, 1.2, 0.9,25,25,204, 255, 0, 0, 0, 0)
    
                if IsControlJustPressed(1, 38) then
                    data = {vec3(coords.x, coords.y, coords.z + 0.8)}
                    TriggerServerEvent('ledjo_gang:updateMarker', name, type, data)
                    lib.hideTextUI()
                    break
                end
            end
        elseif type == 'stash' then
            lib.showTextUI(L('textui.stash'))
            local triggered = false
            while true do
                Wait(0)
                local heading = GetEntityHeading(cache.ped)
                hit, coords, entity = RayCastGamePlayCamera(100.0)
                if not triggered then
                    local hash = `prop_ld_int_safe_01`
                    RequestModel(hash)
                    while not HasModelLoaded(hash) do
                        Wait(10)
                    end
                    sef = CreateObject(hash, coords, false, true, false)
                    SetEntityCollision(sef, false, false)
                    triggered = true
                end
    
                SetEntityCoords(sef, coords.x, coords.y, coords.z + 0.5)
                SetEntityHeading(sef, heading)
                SetEntityAlpha(sef, 180, 0)
    
                if IsControlJustPressed(1, 38) then
                    local c = GetEntityCoords(sef)
                    DeleteEntity(sef)
                    data = {vec4(coords.x, coords.y, coords.z, GetEntityHeading(cache.ped))}
                    TriggerServerEvent('ledjo_gang:updateMarker', name, type, data)
                    lib.hideTextUI()
                    break
                end
            end
        end
    else
        sendNotify('', L('update.marker.pickmafia'), 'erorr')
    end
end)


lib.callback.register('ledjo_gang:dellMafia', function(data)
    local options = {}

    for k,v in pairs(data) do
        options[#options + 1] = {
            label = v.label, value = v.value
        }
    end

    local input = lib.inputDialog('', { {type = 'select', label = L('veh.update.name'), options = options, required = true} })

    if not input or not input[1] then
        sendNotify('', L('command.dellorg.canceled'), 'inform')
        return false
    end

    return input[1]
end)

RegisterNetEvent('ledjo_gang:updateVehicles', function(data)
    local options = {}

    for k,v in pairs(data) do
        options[#options + 1] = {
            label = v.label, value = v.value
        }
    end

    local input = lib.inputDialog('', {
        {type = 'select', label = L('veh.update.name'), options = options, required = true},
        {type = 'select', label = L('veh.update.action'), required = true, options = {
            {label = L('veh.options.add'), value = 'new'},
            {label = L('veh.options.update'), value = 'curr'},
            {label = L('veh.options.delete'), value = 'dell'}
        }
    }})

    if not input then return end

    local name = input[1]
    local type = input[2]

    if type == 'new' then
        local carInput = lib.inputDialog(L('creator'), {
            {type = 'number', label = L('creator.vehicles'), icon = 'car', description = L('creator.vehicles.description'), min = 1, required = true},
        })

        if not carInput then return end

        local vehicles = carInput[1]

        if vehicles and vehicles > 0 then
            for i = 1, vehicles do
                local input = lib.inputDialog(L('veh'), {
                    {type = 'input', label = L('veh.label'), placeholder = L('veh.label.placeholder')},
                    {type = 'input', label = L('veh.spawncode'), placeholder = L('veh.spawncode.placeholder')},
                    {type = 'color', label = L('veh.color1'), description = L('veh.optional')},
                    {type = 'color', label = L('veh.color2'), description = L('veh.optional')},
                    {type = 'checkbox', label = L('veh.fulltune')},
                })
                if not input then return end

                local vehName = input[1]
                local vehSpawn = input[2]
                local primaryColor = input[3]
                local secondaryColor = input[4]
                local fulltune = input[5]
        
                if input then
                    local veh = {}
                    
                    veh[#veh + 1] = {
                        label = vehName,
                        model = vehSpawn,
                        primaryColor = primaryColor or false,
                        secondaryColor = secondaryColor or false,
                        fulltune = fulltune,
                    }

                    TriggerServerEvent('ledjo_gang:updateVehicles:server', name, type, veh)
                end
            end

        end
    elseif type == 'curr' then
        local options = {}

        for k,v in pairs(Mafia[name].vehicleList) do
            options[#options + 1] = {label = v.label, value = v.label}
        end

        local currentVehs = lib.inputDialog('', {
            {type = 'select', label = L('veh.options.update.name'), options = options},
        })

        if not currentVehs then return end 
        
        local veh = currentVehs[1]
        local vehToEdit = Mafia[name].vehicleList[veh]

        local newVehData = lib.inputDialog(L('veh'), {
            {type = 'color', label = L('veh.color1'), description = L('veh.optional'), default = vehToEdit.primaryColor or nil},
            {type = 'color', label = L('veh.color2'), description = L('veh.optional'), default = vehToEdit.secondaryColor or nil},
            {type = 'checkbox', label = L('veh.fulltune'), checked = vehToEdit.fulltune},
        })

        if not newVehData then return end

        local vehName = vehToEdit.label
        local vehSpawn = vehToEdit.model
        local primaryColor = newVehData[1]
        local secondaryColor = newVehData[2]
        local fulltune = newVehData[3]

        if newVehData then
            local veh = {}

            veh[#veh + 1] = {
                label = vehName,
                model = vehSpawn,
                primaryColor = primaryColor or false,
                secondaryColor = secondaryColor or false,
                fulltune = fulltune,
            }

            TriggerServerEvent('ledjo_gang:updateVehicles:server', name, type, veh)
        end
    elseif type == 'dell' then
        local options = {}

        for k,v in pairs(Mafia[name].vehicleList) do
            options[#options + 1] = {label = v.label, value = v.label}
        end

        local input = lib.inputDialog('', {
            {type = 'select', label = L('veh.options.update.name'), options = options},
        })

        if not input then return end

        local chosen = input[1]

        TriggerServerEvent('ledjo_gang:updateVehicles:server', name, type, chosen)
    end
end)

RegisterNetEvent('ledjo_gang:newMarker', function(info)
    local options = {}
    for k,v in pairs(info) do
        options[#options + 1] = {
            label = v.label, value = v.value
        }
    end

    local input = lib.inputDialog('', {
        {type = 'select', label = L('update.marker.label'), options = options},
        {type = 'select', label = L('update.marker.action'), options = {
            {label = L('update.marker.boss'), value = 'boss'},
            {label = L('update.marker.vehicle'), value = 'vm'},
            {label = L('update.marker.delete'), value = 'dvm'},
            {label = L('update.marker.heli'), value = 'heli'},
            {label = L('update.marker.level'), value = 'lvl'},
            {label = L('update.marker.stash'), value = 'stash'},
        }
    }})

    if not input then return end
    local name = input[1]
    local type = input[2]

    local data = {}

    if Mafia[name] then
        if type == 'boss' then
            lib.showTextUI(L('textui.boss'))
            
            while true do
                Wait(0)
                hit, coords, entity = RayCastGamePlayCamera(100.0)
                DrawMarker(31, coords.x, coords.y, coords.z + 0.8, 0, 0, 0, 0, 0, 0, 1.2, 1.2, 0.9,25,25,204, 255, 0, 0, 0, 0)
    
                if IsControlJustPressed(1, 38) then
                    data = {vec3(coords.x, coords.y, coords.z + 0.8)}
                    lib.hideTextUI()
                    TriggerServerEvent('ledjo_gang:newMarker', name, type, data)
                    break
                end
            end
        elseif type == 'vm' then
            lib.showTextUI(L('textui.veh'))

            while true do
                Wait(0)
                hit, coords, entity = RayCastGamePlayCamera(100.0)
                DrawMarker(36, coords.x, coords.y, coords.z + 0.8, 0, 0, 0, 0, 0, 0, 1.2, 1.2, 0.9,25,25,204, 255, 0, 0, 0, 0)
    
                if IsControlJustPressed(1, 38) then
                    data = {vec3(coords.x, coords.y, coords.z + 0.8)}
                    lib.hideTextUI()
                    TriggerServerEvent('ledjo_gang:newMarker', name, type, data)
                    break
                end
            end
        elseif type == 'dvm' then
            lib.showTextUI(L('textui.dellveh'))
            while true do
                Wait(0)
                hit, coords, entity = RayCastGamePlayCamera(100.0)
                DrawMarker(36, coords.x, coords.y, coords.z + 0.8, 0, 0, 0, 0, 0, 0, 1.2, 1.2, 0.9,255,0,0, 255, 0, 0, 0, 0)
    
                if IsControlJustPressed(1, 38) then
                    data = {vec3(coords.x, coords.y, coords.z + 0.8)}
                    lib.hideTextUI()
                    TriggerServerEvent('ledjo_gang:newMarker', name, type, data)
                    break
                end
            end
        elseif type == 'heli' then
            if not Mafia[name].helicotper then
                local alert = lib.alertDialog({
                    header = '',
                    content = L('update.marker.noheli'),
                    centered = true,
                    cancel = true
                })

                if alert == 'confirm' then
                    local input = lib.inputDialog('', {
                        {type = 'number', label = L('creator.heli'), icon = 'helicopter', description = L('creator.heli.description'), min = 1},
                    })

                    if not input then return end

                    local helicopters = input[1]


                    if helicopters > 0 then
                        local heli = {}

                        for i = 1, helicopters do
                            local input = lib.inputDialog(L('heli'), {
                                {type = 'input', label = L('heli.label'), placeholder = L('heli.label.placeholder'), required = true},
                                {type = 'input', label = L('heli.spawncode'), placeholder = L('heli.spawncode.placeholder'), required = true},
                            })
                            if not input then return end
            
                            local vehName = input[1]
                            local vehSpawn = input[2]
                
                            if input then
                                heli[vehName] = vehSpawn
                            end
                        end

                        lib.showTextUI(L('textui.heli'))
                        while true do
                            Wait(0)
                            hit, coords, entity = RayCastGamePlayCamera(100.0)
                            DrawMarker(34, coords.x, coords.y, coords.z + 0.8, 0, 0, 0, 0, 0, 0, 1.2, 1.2, 0.9,25,25,204, 255, 0, 0, 0, 0)
                
                            if IsControlJustPressed(1, 38) then
                                data.Helicotper = {vec3(coords.x, coords.y, coords.z + 0.8)}
                                data.HelicotperList = heli
                                lib.hideTextUI()
                                TriggerServerEvent('ledjo_gang:newMarker', name, type, data)
                                break
                            end
                        end
                    end
                end
            else
                lib.showTextUI(L('textui.heli'))
                while true do
                    Wait(0)
                    hit, coords, entity = RayCastGamePlayCamera(100.0)
                    DrawMarker(34, coords.x, coords.y, coords.z + 0.8, 0, 0, 0, 0, 0, 0, 1.2, 1.2, 0.9,25,25,204, 255, 0, 0, 0, 0)
        
                    if IsControlJustPressed(1, 38) then
                        data.Helicotper = {vec3(coords.x, coords.y, coords.z + 0.8)}
                        TriggerServerEvent('ledjo_gang:newMarker', name, type, data)
                        lib.hideTextUI()
                        break
                    end
                end
            end
        elseif type == 'lvl' then
            lib.showTextUI(L('textui.lvl'))
            while true do
                Wait(0)
                hit, coords, entity = RayCastGamePlayCamera(100.0)
                DrawMarker(21, coords.x, coords.y, coords.z + 0.8, 0, 0, 0, 0, 0, 0, 1.2, 1.2, 0.9,25,25,204, 255, 0, 0, 0, 0)
    
                if IsControlJustPressed(1, 38) then
                    data = {vec3(coords.x, coords.y, coords.z + 0.8)}
                    TriggerServerEvent('ledjo_gang:newMarker', name, type, data)
                    lib.hideTextUI()
                    break
                end
            end
        elseif type == 'stash' then
            lib.showTextUI(L('textui.stash'))
            local triggered = false
            while true do
                Wait(0)
                local heading = GetEntityHeading(cache.ped)
                hit, coords, entity = RayCastGamePlayCamera(100.0)
                if not triggered then
                    local hash = `prop_ld_int_safe_01`
                    RequestModel(hash)
                    while not HasModelLoaded(hash) do
                        Wait(10)
                    end
                    sef = CreateObject(hash, coords, false, true, false)
                    SetEntityCollision(sef, false, false)
                    triggered = true
                end
    
                SetEntityCoords(sef, coords.x, coords.y, coords.z + 0.5)
                SetEntityHeading(sef, heading)
                SetEntityAlpha(sef, 180, 0)
    
                if IsControlJustPressed(1, 38) then
                    local c = GetEntityCoords(sef)
                    DeleteEntity(sef)
                    data = {vec4(coords.x, coords.y, coords.z, GetEntityHeading(cache.ped))}
                    TriggerServerEvent('ledjo_gang:newMarker', name, type, data)
                    lib.hideTextUI()
                    break
                end
            end
        end
    else
        sendNotify('', L('update.marker.pickmafia'), 'erorr')
    end
end)