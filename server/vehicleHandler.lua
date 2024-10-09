function SpawnCar(ped, coords, spawn, type, value)
    local model = joaat(spawn)

    if not CreateVehicleServerSetter then
		print('^1CreateVehicleServerSetter is not available on your artifact, please use artifact 5904 or above to be able to use this^0')
		return
	end

    local tempVehicle = CreateVehicle(model, 0, 0, 0, 0, true, true)

    while not DoesEntityExist(tempVehicle) do
		Wait(0)
	end

    local vehicleType = GetVehicleType(tempVehicle)
	DeleteEntity(tempVehicle)

    local veh = CreateVehicleServerSetter(model, vehicleType, coords.x, coords.y, coords.z, coords.w)

	while not DoesEntityExist(veh) do
		Wait(0)
	end

	while GetVehicleNumberPlateText(veh) == "" do
		Wait(0)
	end

	SetPedIntoVehicle(ped, veh, -1)

    if type == 'owner' then
        Entity(veh).state:set('initVehicle', value, true)
    elseif type == 'normal' then
        Entity(veh).state:set('initVehicleInit', value, true)
    elseif type == 'int' then
        Entity(veh).state:set('initVehicleInit', value, true)
    end
end