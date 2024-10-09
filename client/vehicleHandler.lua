local function WaitFor(cb, timeout)
	local hasValue = cb()
	local i = 0

	while not hasValue do
		if timeout then
			i += 1

			if i > timeout then return end
		end

		Wait(0)
		hasValue = cb()
	end

	return hasValue
end

local function GetEntityAndNetIdFromBagName(bagName)
	local netId = tonumber(bagName:gsub('entity:', ''), 10)

	if not WaitFor(function()
		return NetworkDoesEntityExistWithNetworkId(netId)
	end, 10000) then
		print(('statebag timed out while awaiting entity creation! (%s)'):format(bagName))
		return 0, 0
	end

	local entity = NetworkDoesEntityExistWithNetworkId(netId) and NetworkGetEntityFromNetworkId(netId) or 0

	if entity == 0 then
		print(('statebag received invalid entity! (%s)'):format(bagName))
		return 0, 0
	end

	return entity, netId
end

local function EntityStateHandler(keyFilter, cb)
	return AddStateBagChangeHandler(keyFilter, '', function(bagName, _, value)
		local entity, netId = GetEntityAndNetIdFromBagName(bagName)

		if entity then
			cb(entity, netId, value, bagName)
		end
	end)
end


EntityStateHandler('initVehicleInit', function(entity, _, value)
    if not value then return end

    for i = -1, 0 do
        local ped = GetPedInVehicleSeat(entity, i)

        if ped ~= cache.ped and ped > 0 and NetworkGetEntityOwner(ped) == cache.playerId then
            DeleteEntity(ped)
        end
    end

    if NetworkGetEntityOwner(entity) ~= cache.playerId then return end
    SetVehicleNeedsToBeHotwired(entity, false)
    SetVehRadioStation(entity, 'OFF')
    SetVehicleFuelLevel(entity, 100.0)
    SetVehicleDirtLevel(entity, 0.0)

	if value.fulltune then
		lib.setVehicleProperties(entity, Config.TuneOptions)
	end

	if value.primaryColor then
		local r, g, b = hex2rgb(value.primaryColor)
		SetVehicleCustomPrimaryColour(entity, r or 255, g or 0, b or 0)
	end

	if value.secondaryColor then
		local r, g, b = hex2rgb(value.secondaryColor)
		SetVehicleCustomSecondaryColour(entity, r or 255, g or 0, b or 0)
	end

    Entity(entity).state:set('initVehicleInit', nil, true)
end)


EntityStateHandler('initVehicle', function(entity, _, value)
    if not value then return end

    for i = -1, 0 do
        local ped = GetPedInVehicleSeat(entity, i)

        if ped ~= cache.ped and ped > 0 and NetworkGetEntityOwner(ped) == cache.playerId then
            DeleteEntity(ped)
        end
    end

    if NetworkGetEntityOwner(entity) ~= cache.playerId then return end
    SetVehicleNeedsToBeHotwired(entity, false)
    SetVehRadioStation(entity, 'OFF')
    SetVehicleFuelLevel(entity, 100.0)
    SetVehicleDirtLevel(entity, 0.0)
	lib.setVehicleProperties(entity, value)
    Entity(entity).state:set('initVehicle', nil, true)
	TriggerServerEvent('ledjo_gang:changeStored', 0, value.plate)
end)



function DellVeh()
	if cache.vehicle then
		local veh = cache.vehicle
		local props = lib.getVehicleProperties(veh)
		local net = VehToNet(veh)

		local owner = lib.callback.await('ledjo_gang:checkOwnership', false, props.plate)

		if owner then
			TriggerServerEvent('ledjo_gang:dellOwned', net, props)
		else
			TriggerServerEvent('ledjo_gang:dellNPC', net)
		end
	end
end


RegisterNetEvent('ledjo_gang:integratedVehShow', function()
	local options = {}
	local job = GetGang()

	if Mafia[job] then
		if not Mafia[job].vehicleList then
			lib.registerContext({
				id = 'ledjo_gang_car_int',
				title = L('vehmenu.integrated'),
				menu = 'ledjo_gang_car',
				options = {
					[L('vehmenu.noveh')] = {}
				}
			})
	
			return lib.showContext('ledjo_gang_car_int')
		end

		for k,v in pairs(Mafia[job].vehicleList) do
			options[#options + 1] = {
				title = k,
				serverEvent = 'ledjo_gang:spawnCarInt',
				args = v
			}
		end

		lib.registerContext({
			id = 'ledjo_gang_car_int',
			title = L('vehmenu.integrated'),
			menu = 'ledjo_gang_car',
			options = options
		})

		lib.showContext('ledjo_gang_car_int')
	end
end)

local function inGarage(stored)
	if stored == 1 then
		return true
	end

	return false
end

RegisterNetEvent('ledjo_gang:ownedVehShow', function()
	local options = {}

	local vehs = lib.callback.await('ledjo_gang:fetchOwned', false)

	if not vehs or #vehs == 0 then
		lib.registerContext({
            id = 'ledjo_gang_owned_garage',
            title = L('vehmenu.garage.title'),
			menu = 'ledjo_gang_car',
            options = {
                [L('vehmenu.noveh')] = {}
            }
        })

        return lib.showContext('ledjo_gang_owned_garage')
	end

	for i = 1, #vehs do
		local data = vehs[i]
		local stored = inGarage(data.stored)

		options[#options + 1] = {
			title = data.label,
			serverEvent = stored and 'ledjo_gang:spawnVeh' or nil,
			description = data.plate,
			arrow = stored and true or false,
			args = data
		}
	end

	lib.registerContext({
		id = 'ledjo_gang_car_own',
		title = L('vehmenu.ownedveh'),
		options = options
	})

	lib.showContext('ledjo_gang_car_own')
end)


function OpenImpoundw()
	local vehs = lib.callback.await('ledjo_gang:fetchImpound', false)

	if not vehs or #vehs == 0 then
		return sendNotify('', L('impound.noveh'), 'inform')
	end

	local options = {}

	for i = 1, #vehs do
		local data = vehs[i]
		local price = Config.ImpoundPrices[GetVehicleClassFromName(data.vehicle.model)]

		options[i] = {
			title = data.label,
			description = data.plate,
			arrow = true,
			onSelect = function()
				local alert = lib.alertDialog({
					header = '',
					content = L('impound.alert'):format(data.label, price),
					centered = true,
					cancel = true
				})

				if alert == 'cancel' then
					return lib.showContext('ledjo_gang:ImpoundMenu')
				end

				if alert == 'confirm' then
					TriggerServerEvent('ledjo_gang:impoundVeh', data.vehicle.model, price, data.vehicle)
				end
			end
		}
	end


	lib.registerContext({
		id = 'ledjo_gang:ImpoundMenu',
		title = L('impound.title'),
		options = options
	})

	lib.showContext('ledjo_gang:ImpoundMenu')
end


function HelicopterMenu()
	local options = {}
	local job = GetGang()

	if Mafia[job] then
		for k,v in pairs(Mafia[job].helicotperList) do
			options[#options + 1] = {
				title = k,
				serverEvent = 'ledjo_gang:CreateHeli',
				args = {model = v}
			}
		end

		lib.registerContext({
			id = 'ledjo_gang_heli',
			title = L('vehmenu.heli'),
			menu = 'ledjo_gang_car',
			options = options
		})

		lib.showContext('ledjo_gang_heli')
	end
end