Mafia = {}
local Points = {}
local UiInterval = nil
local dealerShipPoint = nil
local dealerShipBlip
local impoundPoint = nil
local textUI = false
local hasText = false 
local hasTextImpound = false

local function nearbyVeh(point)
	if GetGang() == point.job and not cache.vehicle then
		DrawMarker(36, point.coords.x, point.coords.y, point.coords.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 1.0, 1.0, 50, 50, 204, 100, false, true, 2, true, false, false, false)

		if point.currentDistance < 1.2 then
			if IsControlJustReleased(0, 38) then
				lib.registerContext({
					id = 'ledjo_gang_car',
					title = L('vehmenu.title'),
					options = {
						{
							title = L('vehmenu.integrated'),
							description = L('vehmenu.integrated.description'),
							icon = 'car',
							event = 'ledjo_gang:integratedVehShow'
						},
					
						{
							title = L('vehmenu.ownedveh'),
							description = L('vehmenu.ownedveh.description'),
							icon = 'car',
							event = 'ledjo_gang:ownedVehShow'
						},
					}
				})

				return lib.showContext('ledjo_gang_car')
			end
		end
	end
end


local function nearbyHeli(point)
	if GetGang() == point.job and not cache.vehicle then
		DrawMarker(34, point.coords.x, point.coords.y, point.coords.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 1.0, 1.0, 50, 50, 204, 100, false, true, 2, true, false, false, false)
	
		if point.currentDistance < 1.2 and IsControlJustReleased(0, 38) then
			HelicopterMenu()
		end
	end
end


RegisterNetEvent('ledjo_gang:client:moneySync', function(job, money)
	Mafia[job].money = money
end)

local function nearbyBoss(point)
	if GetGang() == point.job and IsBoss() == true then
		DrawMarker(31, point.coords.x, point.coords.y, point.coords.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.5, 0.5, 0.5, 50, 50, 204, 100, false, true, 2, true, false, false, false)

		if point.currentDistance < 1.2 then
			if IsControlJustReleased(0, 38) then
				OpenBossMenu()
			end
		end
	end
end


local function nearbyVehDell(point)
	if GetGang() == point.job then
		if cache.vehicle then
			DrawMarker(36, point.coords.x, point.coords.y, point.coords.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.5, 0.5, 0.5, 255, 0, 0, 100, false, true, 2, true, false, false, false)

			if point.currentDistance < 1.2 then
				if IsControlJustReleased(0, 38) then
					DellVeh()
				end
			end
		end
	end
end


local function nearbyLvl(point)
	if GetGang() == point.job then
		DrawMarker(20, point.coords.x, point.coords.y, point.coords.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.5, 0.5, 0.5, 50, 50, 204, 100, false, true, 2, true, false, false, false)
		if point.currentDistance < 1.2 then
			if IsControlJustReleased(0, 38) then
				local lvl = tonumber(Mafia[point.job].level)
				local nextLvlInfo

				if lvl == 1 then
					nextLvlInfo = L('menu.lvl.2.description'):format(Config.stash[2][1], Config.stash[2][2])
				elseif lvl == 2 then
					nextLvlInfo = L('menu.lvl.3.description'):format(Config.stash[3][1], Config.stash[3][2])
				elseif lvl == 3 then
					nextLvlInfo = L('menu.lvl.4.description'):format(Config.stash[4][1], Config.stash[4][2])
				end

				if lvl == 4 then
					lib.registerContext({
						id = 'ledjo_gang_lvl',
						title = L('menu.lvl'),
						options = {
							[L('menu.maxlvl')] = {}
						}
					})
			
					return lib.showContext('ledjo_gang_lvl')
				end

				local options = {
					{
						title = L('menu.lvl.currentlvl'):format(lvl),
					},

					{
						title = L('menu.lvl.title'):format(lvl + 1),
						description = L('menu.lvl.title.description'):format(Config.Levels[lvl]),
						icon = 'fa-star',
						metadata = {nextLvlInfo},
						onSelect = function()
							TriggerServerEvent('ledjo_gang:nextLvl')
						end
					}
				}

				lib.registerContext({
					id = 'ledjo_gang_lvl',
					title = L('menu.lvl'),
					options = options
				})

				lib.showContext('ledjo_gang_lvl')
			end
		end
	end
end

local function onEnterStash(point)
	if not point.entity then
		local model = lib.requestModel(point.model)
		local stash = CreateObject(model, point.coords.x, point.coords.y, point.coords.z, false, true, false)
		
		SetModelAsNoLongerNeeded(model)
		FreezeEntityPosition(stash, true)
		SetEntityInvincible(stash, true)

		exports.qtarget:RemoveTargetModel(point.model, {L('menu.openstash')})
		exports.qtarget:AddTargetModel({point.model}, {
			options = {
				{
					icon = L('target.openstash.icon'),
					label = L('target.openstash'),
					canInteract = function()
						if Config.stashAccessEveryone then
							return true
						else
							if GetGang() == point.job then
								return true
							end

							return false
						end
					end,
					action = function()
						local data = lib.points.getClosestPoint()
					
						local pw = Mafia[data.job].password

						local input = lib.inputDialog(L('stash.dialog'), {
							{type = 'input', label = L('stash.dialog.pw'), password = true}
						})
						if not input then return end

						if input[1] == pw then
							if Config.OxInventory then
								exports.ox_inventory:openInventory('stash', ('%s-%s'):format(data.stashId, data.job))
							elseif Config.QSInventory then
								TriggerServerEvent(Config.InventoryPrefix..":server:OpenInventory", "stash", ('%s_%s'):format(data.job, data.stashId), {
									maxweight = Config.stash[Mafia[data.job].level][2] * 1000,
									slots = Config.stash[Mafia[data.job].level][2],
								})
								TriggerEvent(Config.InventoryPrefix..":client:SetCurrentStash", ('%s_%s'):format(data.job, data.stashId))
							elseif Config.QBInventory then
								TriggerServerEvent("inventory:server:OpenInventory", "stash", ('%s_%s'):format(data.job, data.stashId), {
									maxweight = Config.stash[Mafia[data.job].level][2] * 1000,
									slots = Config.stash[Mafia[data.job].level][2],
								})
								TriggerEvent("inventory:client:SetCurrentStash", ('%s_%s'):format(data.job, data.stashId))
							end
						else
							sendNotify('', L('stash.wrong.pw'), 'error')
						end
					end
				},
			},
			distance = 2.0
		})

		point.entity = stash
	end
end

local function onExitStash(point)
	local entity = point.entity

	if not entity then return end

	exports.qtarget:RemoveTargetEntity(entity, L('target.openstash'))

	SetEntityAsMissionEntity(entity, false, true)
	DeleteObject(entity)

	point.entity = nil
end

local function onEnterDealer(point)
	if Mafia[GetGang()] then
		DrawMarker(36, point.coords.x, point.coords.y, point.coords.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.8, 0.8, 0.8, 30, 150, 30, 222, false, false, 0, true, false, false, false)

		if point.currentDistance < 1.2 then
			if not hasText then
				hasText = true
				lib.showTextUI('Appuie sur [E] pour Ouvrir Concession illégal')
			end

			if IsControlJustReleased(0, 38) then
				OpenDealerShip()
			end
		elseif hasText then
			hasText = false
			lib.hideTextUI()
		end
	end
end


local function blipHandler()
	if Mafia[GetGang()] then
		if dealerShipBlip then return end
		dealerShipBlip = AddBlipForCoord(Config.dealership.coords.x, Config.dealership.coords.y, Config.dealership.coords.z)

		SetBlipSprite(dealerShipBlip, Config.dealership.blip.type)
		SetBlipDisplay(dealerShipBlip, 4)
		SetBlipScale(dealerShipBlip, Config.dealership.blip.scale)
		SetBlipColour(dealerShipBlip, Config.dealership.blip.colour)
		SetBlipAsShortRange(dealerShipBlip, true)
		BeginTextCommandSetBlipName('STRING')
		AddTextComponentSubstringPlayerName(Config.dealership.blip.text)
		EndTextCommandSetBlipName(dealerShipBlip)


		impoundBlip = AddBlipForCoord(Config.impound.coords.x, Config.impound.coords.y, Config.impound.coords.z)
		SetBlipSprite(impoundBlip, Config.impound.blip.type)
		SetBlipDisplay(impoundBlip, 4)
		SetBlipScale(impoundBlip, Config.impound.blip.scale)
		SetBlipColour(impoundBlip, Config.impound.blip.colour)
		SetBlipAsShortRange(impoundBlip, true)
		BeginTextCommandSetBlipName('STRING')
		AddTextComponentSubstringPlayerName(Config.impound.blip.text)
		EndTextCommandSetBlipName(impoundBlip)
	else
		RemoveBlip(dealerShipBlip)
		dealerShipBlip = nil

		RemoveBlip(impoundBlip)
		impoundBlip = nil
	end
end


local function setupDealer()
	if not Mafia[GetGang()] then return end

	dealerShipPoint = lib.points.new({
        coords = Config.dealership.coords,
        distance = 11,
        nearby = onEnterDealer,
    })
end

local function onEnterImpound(point)
	if Mafia[GetGang()] then
		DrawMarker(36, point.coords.x, point.coords.y, point.coords.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.8, 0.8, 0.8, 30, 150, 30, 255, false, false, 0, true, false, false, false)

		if point.isClosest and point.currentDistance < 1.2 then
			if not hasTextImpound then
				hasTextImpound = true
				lib.showTextUI('Appuie sur [E] pour Ouvir Fourriere')
			end

			if IsControlJustReleased(0, 38) then
				OpenImpoundw()
			end
		elseif hasTextImpound then
			hasTextImpound = false
			lib.hideTextUI()
		end
	end
end

local function setupImpound()
	if not Mafia[GetGang()] then return end

	impoundPoint = lib.points.new({
        coords = Config.impound.coords,
        distance = 11,
        nearby = onEnterImpound,
    })
end

function SetUpMafia()
	local data = lib.callback.await('ledjo_gang:fetchMafia', false, 200)
	Mafia = {}
	Mafia = data

	for k,v in pairs(data) do
		if GetGang() == v.name then
			if v.boss then
				for kk, coords in pairs(v.boss) do
					Points[#Points + 1] = lib.points.new({
						coords = vec3(coords.x, coords.y, coords.z),
						distance = 11,
						job = v.name,
						nearby = nearbyBoss,
						text = L('marker.boss')
					})
				end
			end

			if v.vehicles then
				for kk, coords in pairs(v.vehicles) do
					Points[#Points + 1] = lib.points.new({
						coords = vec3(coords.x, coords.y, coords.z),
						distance = 11,
						job = v.name,
						nearby = nearbyVeh,
						text = L('marker.veh'),
						vehType = 'in'
					})
				end
			end

			if v.parkVehicle then
				for kk, coords in pairs(v.parkVehicle) do
					Points[#Points + 1] = lib.points.new({
						coords = vec3(coords.x, coords.y, coords.z),
						distance = 11,
						job = v.name,
						nearby = nearbyVehDell,
						text = L('marker.veh.park'),
						vehType = 'out'
					})
				end
			end

			if v.lvl then
				for kk, coords in pairs(v.lvl) do
					Points[#Points + 1] = lib.points.new({
						coords = vec3(coords.x, coords.y, coords.z),
						distance = 11,
						job = v.name,
						nearby = nearbyLvl,
						text = L('marker.lvl')
					})
				end
			end

			if v.helicotper then
				for kk, coords in pairs(v.helicotper) do
					Points[#Points + 1] = lib.points.new({
						coords = vec3(coords.x, coords.y, coords.z),
						distance = 11,
						job = v.name,
						nearby = nearbyHeli,
						text = L('marker.heli'),
						vehType = 'in'
					})
				end
			end
		end


		if v.stash then
			for kk, coords in pairs(v.stash) do
				Points[#Points + 1] = lib.points.new({
					coords = vec4(coords.x, coords.y, coords.z, coords.w),
					distance = 11,
					job = v.name,
					stashId = kk,
					model = `prop_ld_int_safe_01`,
					onEnter = onEnterStash,
					onExit = onExitStash,
				})
			end
		end
	end


	if Config.dealership.enable then
		setupDealer()
		setupImpound()
		blipHandler()
	end


	UiInterval = SetInterval(function()
		if Mafia[GetGang()] then
			local point = lib.points.getClosestPoint()

			if hasText then goto skipLoop end
			if hasTextImpound then goto skipLoop end

			if point and point.currentDistance < 3.0 and point.vehType == 'in' and cache.vehicle then
				if textUI then
					lib.hideTextUI()
					textUI = false
				end

				goto skipLoop
			end

			if point and point.currentDistance < 3.0 and point.vehType == 'out' and not cache.vehicle then
				if textUI then
					lib.hideTextUI()
					textUI = false
				end

				goto skipLoop
			end
			
			if point and point.currentDistance < 1.4 then
				if not textUI then
					textUI = true
					lib.showTextUI(point.text)
				end
			else
				if textUI then
					lib.hideTextUI()
					textUI = false
				end
			end

			::skipLoop::
		end
	end, 250)
end


function OnGangUpdate()
	if textUI then
		lib.hideTextUI()
		textUI = false
	end

	if Config.dealership.enable then
		blipHandler()
	end

	for k, v in pairs(Points) do
		if v.entity then onExitStash(v) end
		v:remove()
	end

	Points = {}
	if UiInterval then ClearInterval(UiInterval) UiInterval = nil end
	lib.hideTextUI()

	SetUpMafia()
end

RegisterNetEvent('ledjo_gang:setup', function()
	for k, v in pairs(Points) do
		if v.entity then onExitStash(v) end
		v:remove()
	end

	Points = {}
	if UiInterval then ClearInterval(UiInterval) UiInterval = nil end
	lib.hideTextUI()

	OnGangUpdate()
end)


RegisterNetEvent('ledjo_gang:client:sync', function(data)
	Mafia = {}
	Mafia = data
end)

RegisterNetEvent('ledjo_gang:setGPS', function(coords)
	SetNewWaypoint(coords[1].x, coords[1].y)
end)


RegisterNetEvent('ledjo_gang:tptobase', function(data)
	local options = {}

    for k,v in pairs(data) do
        options[#options + 1] = {
            label = v.label, value = v.value
        }
    end

    local input = lib.inputDialog('', {
        {type = 'select', label = L('veh.update.name'), required = true, options = options
    }})

	if not input then return end

	local name = input[1]
	local coords = Mafia[name].boss[1]

	SetEntityCoords(cache.ped, coords.x, coords.y, coords.z, false, false, false, false)
end)


AddEventHandler('onResourceStop', function(resource)
	if resource == cache.resource then
		for k,v in pairs(Points) do
			if v.entity then onExitStash(v) end
			v:remove()
		end

		if UiInterval then ClearInterval(UiInterval) end
		lib.hideTextUI()
	end
end)