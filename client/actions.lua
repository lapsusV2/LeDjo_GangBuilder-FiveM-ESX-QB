if not Config.mafiaMenu.enabled then return end

local playerState = LocalPlayer.state
local Wait = Wait
local TaskPlayAnim = TaskPlayAnim


local function cuffPlayer(ped)
    local playerId = GetPlayerServerId(NetworkGetPlayerIndexFromPed(ped))
    local state = lib.callback.await('ledjo_gang:setPlayerCuffs', 200, playerId)

    if state == nil then return end

    playerState.invBusy = true

    FreezeEntityPosition(cache.ped, true)
    SetCurrentPedWeapon(cache.ped, `WEAPON_UNARMED`, true)
    AttachEntityToEntity(cache.ped, ped, 11816, -0.07, -0.58, 0.0, 0.0, 0.0, 0.0, false, false , false, true, 2, true)

    local dict = state and 'mp_arrest_paired' or 'mp_arresting'

    if state then
        lib.requestAnimDict(dict)
        TaskPlayAnim(cache.ped, dict, 'cop_p2_back_right', 8.0, -8.0, 3750, 2, 0.0, false, false, false)
        Wait(3750)
    else
        lib.requestAnimDict(dict)
        TaskPlayAnim(cache.ped, dict, 'a_uncuff', 8.0, -8, 5500, 0, 0, false, false, false)
        Wait(5500)
    end

    DetachEntity(cache.ped, true, false)
    FreezeEntityPosition(cache.ped, false)
    RemoveAnimDict(dict)

    playerState.invBusy = false
end


local isCuffed = playerState.isCuffed
local IsEntityPlayingAnim = IsEntityPlayingAnim
local DisablePlayerFiring = DisablePlayerFiring
local DisableControlAction = DisableControlAction

local function whileCuffed()
    local dict = 'mp_arresting'

    while isCuffed do
        if not IsEntityPlayingAnim(cache.ped, dict, 'idle', 3) then
            lib.requestAnimDict(dict)
            TaskPlayAnim(cache.ped, dict, 'idle', 8.0, -8, -1, 49, 0.0, false, false, false)
        end

        DisablePlayerFiring(cache.playerId, true)
       


        DisableControlAction(0, 24, true) -- Attack
        DisableControlAction(0, 257, true) -- Attack 2
        DisableControlAction(0, 25, true) -- Aim
        DisableControlAction(0, 263, true) -- Melee Attack 1

        DisableControlAction(0, 45, true) -- Reload
        DisableControlAction(0, 22, true) -- Jump
        DisableControlAction(0, 44, true) -- Cover
        DisableControlAction(0, 37, true) -- Select Weapon
        DisableControlAction(0, 23, true) -- Also 'enter'?

        DisableControlAction(0, 288, true) -- Disable phone
        DisableControlAction(0, 289, true) -- Inventory
        DisableControlAction(0, 170, true) -- Animations
        DisableControlAction(0, 167, true) -- Job

        DisableControlAction(0, 26, true) -- Disable looking behind
        DisableControlAction(0, 73, true) -- Disable clearing animation
        DisableControlAction(2, 199, true) -- Disable pause screen

        DisableControlAction(0, 59, true) -- Disable steering in vehicle
        DisableControlAction(0, 71, true) -- Disable driving forward in vehicle
        DisableControlAction(0, 72, true) -- Disable reversing in vehicle

        DisableControlAction(2, 36, true) -- Disable going stealth

        DisableControlAction(0, 264, true) -- Disable melee
        DisableControlAction(0, 257, true) -- Disable melee
        DisableControlAction(0, 140, true) -- Disable melee
        DisableControlAction(0, 141, true) -- Disable melee
        DisableControlAction(0, 142, true) -- Disable melee
        DisableControlAction(0, 143, true) -- Disable melee
        DisableControlAction(0, 75, true)  -- Disable exit vehicle
        DisableControlAction(27, 75, true) -- Disable exit vehicle
        EnableControlAction(0, 249, true) -- Added for talking while cuffed
        EnableControlAction(0, 46, true)  -- Added for talking while cuffed
        Wait(0)
    end

    ClearPedTasks(cache.ped)
    RemoveAnimDict(dict)


    if Config.actions.freezeWhileCuffed then
        FreezeEntityPosition(cache.ped, false)
    end
end


AddStateBagChangeHandler('ledjo_gang_isCuffed', ('player:%s'):format(cache.serverId), function(_, _, value)
    local ped = cache.ped

    if isCuffed ~= value then
        SetCurrentPedWeapon(ped, `WEAPON_UNARMED`, true)
        FreezeEntityPosition(ped, true)

        if value then
            playerState.invBusy = value

            lib.requestAnimDict('mp_arrest_paired')
            TaskPlayAnim(ped, 'mp_arrest_paired', 'crook_p2_back_right', 8.0, -8, 3750, 2, 0, false, false, false)
            Wait(3750)
            RemoveAnimDict('mp_arrest_paired')
        else
            lib.requestAnimDict('mp_arresting')
            TaskPlayAnim(ped, 'mp_arresting', 'b_uncuff', 8.0, -8, 5500, 0, 0, false, false, false)
            Wait(5500)

            playerState.invBusy = value
        end

        FreezeEntityPosition(ped, false)
        isCuffed = value
    end

    if Config.actions.freezeWhileCuffed then
        FreezeEntityPosition(ped, true)
    end

    isCuffed = value

    if value then
        CreateThread(whileCuffed)
    end
end)

local function escortPlayer(id, ped)
    if not id then
        id = NetworkGetPlayerIndexFromPed(ped)
    end

    TriggerServerEvent('ledjo_gang:setPlayerEscort', GetPlayerServerId(id), not IsEntityAttachedToEntity(ped, cache.ped))
end

local isEscorted = playerState.isEscorted

local function setEscorted(serverId)
    local dict = 'anim@move_m@prisoner_cuffed'
    local dict2 = 'anim@move_m@trash'

    while isEscorted do
        local player = GetPlayerFromServerId(serverId)
        local ped = player > 0 and GetPlayerPed(player)

        if not ped then break end

        if not IsEntityAttachedToEntity(cache.ped, ped) then
            AttachEntityToEntity(cache.ped, ped, 11816, 0.54, 0.54, 0.0, 0.0, 0.0, 0.0, false, false, true, true, 2, true)
        end

        if IsPedWalking(ped) then
            if not IsEntityPlayingAnim(cache.ped, dict, 'walk', 3) then
                lib.requestAnimDict(dict)
                TaskPlayAnim(cache.ped, dict, 'walk', 8.0, -8, -1, 1, 0.0, false, false, false)
            end
        elseif IsPedRunning(ped) or IsPedSprinting(ped) then
            if not IsEntityPlayingAnim(cache.ped, dict2, 'run', 3) then
                lib.requestAnimDict(dict2)
                TaskPlayAnim(cache.ped, dict2, 'run', 8.0, -8, -1, 1, 0.0, false, false, false)
            end
        else
            StopAnimTask(cache.ped, dict, 'walk', -8.0)
            StopAnimTask(cache.ped, dict2, 'run', -8.0)
        end

        Wait(0)
    end

    RemoveAnimDict(dict)
    RemoveAnimDict(dict2)
    playerState:set('ledjo_gang_isEscorted', false, true)
end

AddStateBagChangeHandler('ledjo_gang_isEscorted', ('player:%s'):format(cache.serverId), function(_, _, value)
    isEscorted = value

    if IsEntityAttached(cache.ped) then
        DetachEntity(cache.ped, true, false)
    end

    if value then setEscorted(value) end
end)


lib.registerMenu({
    id = 'ledjo_gang:actionsMenu',
    title = L('actions.menu.title'),
    position = Config.mafiaMenu.position,
    options = {
        {label = L('actions.menu.cuff'), args = {value = 'cuff'}, close = false},
        {label = L('actions.menu.escort'), args = {value = 'escort'}, close = false},
        {label = L('actions.menu.vehicle'), values = {L('actions.menu.vehicle.put'), L('actions.menu.vehicle.takeout')}, args = {value = 'veh'}, close = false}
    }
}, function(selected, scrollIndex, args)
    if isCuffed then return end
    if isEscorted then return end
    if args.value == 'cuff' then
        local id, ped = lib.getClosestPlayer(GetEntityCoords(cache.ped), 3.0, false)
        if not id then return end
        cuffPlayer(ped)
    elseif args.value == 'escort' then
        local id, ped = lib.getClosestPlayer(GetEntityCoords(cache.ped), 3.0, false)
        if not ped then return end
        escortPlayer(id, ped)
    elseif args.value == 'veh' then
        if scrollIndex == 1 then
            local id, ped = lib.getClosestPlayer(GetEntityCoords(cache.ped), 3.0, false)
            if not id then return end
            TriggerServerEvent('ledjo_gang:putCar', GetPlayerServerId(id))
        else
            local id, ped = lib.getClosestPlayer(GetEntityCoords(cache.ped), 3.0, false)
            if not id then return end
            TriggerServerEvent('ledjo_gang:OutVehicle', GetPlayerServerId(id))
        end
    end
end)


RegisterNetEvent('ledjo_gang:ledjo_gang:putCar', function()
    local vehicle = lib.getClosestVehicle(GetEntityCoords(cache.ped), 4.0, false)

    if vehicle then
        local maxSeats, freeSeat = GetVehicleMaxNumberOfPassengers(vehicle)

        for i = maxSeats - 1, 0, -1 do
            if IsVehicleSeatFree(vehicle, i) then
                freeSeat = i
                break
            end
        end


        if freeSeat then
            TaskWarpPedIntoVehicle(cache.ped, vehicle, freeSeat)
            isEscorted = false
        end
    end
end)


RegisterNetEvent('ledjo_gang:OutVehicle', function()
    if cache.vehicle then
        if IsPedSittingInAnyVehicle(cache.ped) then
            TaskLeaveVehicle(cache.ped, cache.vehicle, 64)
        end
    end
end)


local keybind = lib.addKeybind({
    name = 'mafiamenu',
    description = L('actions.keymaping.description'),
    defaultKey = Config.mafiaMenu.defaultKey,
    onPressed = function(self)
        if isCuffed then return end
        if isEscorted then return end
        if Mafia[GetGang()] then
            lib.showMenu('ledjo_gang:actionsMenu')
        end
    end
})