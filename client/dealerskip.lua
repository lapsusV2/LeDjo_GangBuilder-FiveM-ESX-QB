local veh = Vehicles
local previewVeh = nil
local lastCoords = nil


function hex2rgb(hex)
    local hex = hex:gsub("#","")
    return tonumber("0x"..hex:sub(1,2)), tonumber("0x"..hex:sub(3,4)), tonumber("0x"..hex:sub(5,6))
end

local function dellVeh()
    if previewVeh then
        SetVehicleAsNoLongerNeeded(previewVeh)
        SetEntityAsMissionEntity(previewVeh)
        DeleteVehicle(previewVeh)
        previewVeh = nil
    end
end


local function groupDigs(price)
	local left,num,right = string.match(price,'^([^%d]*%d)(%d*)(.-)$')

	return left..(num:reverse():gsub('(%d%d%d)','%1' .. ','):reverse())..right
end

local function VehSpeedCalculator(model)
    if Config.dealership.unitCalculator == 'kmh' then
        return ('%.2f KMH'):format(GetVehicleModelEstimatedMaxSpeed(model) * 3.6)
    elseif Config.dealership.unitCalculator == 'mph' then
        return ('%.2f MPH'):format(GetVehicleModelEstimatedMaxSpeed(model) * 2.236936)
    else
        return ('%.2f KMH'):format(GetVehicleModelEstimatedMaxSpeed(model) * 3.6)
    end
end

local function spawnVeh(model)
    dellVeh()
    if not IsModelInCdimage(model) then return end
    RequestModel(model)
    while not HasModelLoaded(model) do
        Wait(50)
    end

    previewVeh = CreateVehicle(model, Config.dealership.vehiclePreview.x, Config.dealership.vehiclePreview.y, Config.dealership.vehiclePreview.z, Config.dealership.vehiclePreview.w, false,false)

    SetVehicleEngineOn(previewVeh, false, false, true)
    SetVehicleHandbrake(previewVeh, true)
    SetVehicleInteriorlight(previewVeh, true)
    FreezeEntityPosition(previewVeh, true)

    if GetVehicleDoorLockStatus(previewVeh) ~= 4 then
        SetVehicleDoorsLocked(previewVeh, 4)
    end

    TaskWarpPedIntoVehicle(cache.ped, previewVeh, -1)
end


function OpenDealerShip()
    if veh then
        local options = {}
        lastCoords = GetEntityCoords(cache.ped)

        for k,v in pairs(veh) do
            for i = 1, #v[1].values do
                local data = v[1].values[i]
                data.description = L('dealership.description.info'):format(groupDigs(data.price), VehSpeedCalculator(data.model))
            end

            options[#options + 1] = {
                label = v[1].label,
                values = v[1].values,
                icon = 'car',
                args = {type = k}
            }
        end

        lib.registerMenu({
            id = 'ledjo_gang:dealership',
            title = L('dealership.title'),
            position = 'top-right',
            onSideScroll = function(selected, scrollIndex, args)
                spawnVeh(veh[args.type][1].values[scrollIndex].model)
            end,
            onSelected = function(selected, scrollIndex, args)
                spawnVeh(veh[args.type][1].values[scrollIndex].model)
            end,
            onClose = function(keyPressed)
                if DoesEntityExist(previewVeh) then
                    dellVeh()
                end

                SetEntityCoords(cache.ped, lastCoords.x, lastCoords.y, lastCoords.z)

                Player(cache.serverId).state:set('inDealership', nil, true)
            end,
            options = options,
        }, function(selected, scrollIndex, args)
            local price = veh[args.type][1].values[scrollIndex].price
            local model = veh[args.type][1].values[scrollIndex].model
            local label = veh[args.type][1].values[scrollIndex].label

            local options = {
                {close = false, label = L('dealership.primaryColor'), menuArg = 'primary'},
                {close = false, label = L('dealership.secondaryColor'), menuArg = 'secondary'},
                {label = L('dealership.buy'), menuArg = 'buy', values = {
                    {label = L('dealership.money'), type = 'cash'},
                    {label = L('dealership.bank'), type = 'bank'}
                }},
            }

            lib.registerMenu({
                id = 'ledjo_gang:dealership:sub',
                title = L('dealership.title'),
                position = 'top-right',
                onClose = function(keyPressed)
                    lib.showMenu('ledjo_gang:dealership')
                    Player(cache.serverId).state:set('inDealership', nil, true)
                end,
                options = options
            }, function (selected, scrollIndex)
                if not selected then return end

                if options[selected].menuArg == 'primary' or options[selected].menuArg == 'secondary' then
                    lib.hideMenu(false)
                    Wait(100)
                    local input = lib.inputDialog(L('dealership.pickcolor'), { {type = 'color'} })
                    if not input then
                        return lib.showMenu('ledjo_gang:dealership:sub')
                    end
                    local r, g, b = hex2rgb(input[1])

                    if options[selected].menuArg == 'primary' then
                        SetVehicleCustomPrimaryColour(previewVeh, r or 255, g or 0, b or 0)
                    else
                        SetVehicleCustomSecondaryColour(previewVeh, r or 255, g or 0, b or 0)
                    end

                    lib.showMenu('ledjo_gang:dealership:sub')
                elseif options[selected].menuArg == 'buy' then
                    local moneyType = options[selected].values[scrollIndex].type
                    local money = lib.callback.await('ledjo_gang:fetchMoney', false, moneyType)
                    
                    if money >= price then
                        local props = lib.getVehicleProperties(previewVeh)
                        TriggerServerEvent('ledjo_gang:buyVeh', moneyType, label, price, model, props)
                        Player(cache.serverId).state:set('inDealership', nil, true)

                        if DoesEntityExist(previewVeh) then
                            dellVeh()
                        end
                    else
                        sendNotify('', L('dealership.nomoney'), 'error')
                        lib.showMenu('ledjo_gang:dealership:sub')
                    end
                end
            end)

            lib.showMenu('ledjo_gang:dealership:sub')
        end)

        lib.showMenu('ledjo_gang:dealership')


        Player(cache.serverId).state:set('inDealership', true, true)
    end
end


AddEventHandler('onResourceStop', function(resource)
	if resource == cache.resource then
        Player(cache.serverId).state:set('inDealership', nil, true)
		if DoesEntityExist(previewVeh) then
            dellVeh()
        end
	end
end)