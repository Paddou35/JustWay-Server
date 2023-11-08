CreateThread(function()
    if Config.OldESXSyst == true then
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Wait(10)
    else
        ESX = exports["es_extended"]:getSharedObject()
    end
end)

CreateThread(function()
    for k,v in pairs(Config.Positions.PED) do
        local hash = GetHashKey("s_m_y_valet_01")
        while not HasModelLoaded(hash) do
            RequestModel(hash)
            Wait(20)
        end
        ped = CreatePed('', "s_m_y_valet_01", v.pedorient, false, true)
        SetBlockingOfNonTemporaryEvents(ped, true)
        SetEntityInvincible(ped, true)
        FreezeEntityPosition(ped, true)
    end
end)

function SpawnVehicle(vehicle, plate)
	for k, v in pairs(Config.Positions.Garage) do
		local plyCoords = GetEntityCoords(GetPlayerPed(-1), false)
		local dist = Vdist(plyCoords.x, plyCoords.y, plyCoords.z, v.spawnzone.x, v.spawnzone.y, v.spawnzone.z)

		if dist <= 20 then
			coordX = v.spawnzone.x
			coordY = v.spawnzone.y
			coordZ = v.spawnzone.z
			coordHeading = v.heading
		end
	end

	ESX.Game.SpawnVehicle(vehicle.model, vector3(coordX, coordY, coordZ), coordHeading, function(callback_vehicle)
		ESX.Game.SetVehicleProperties(callback_vehicle, vehicle)
		SetVehRadioStation(callback_vehicle, "OFF")
		SetVehicleFixed(callback_vehicle)
		SetVehicleDeformationFixed(callback_vehicle)
		SetVehicleUndriveable(callback_vehicle, false)
		SetVehicleEngineOn(callback_vehicle, true, true)
		--SetVehicleEngineHealth(callback_vehicle, 1000) -- Might not be needed
		--SetVehicleBodyHealth(callback_vehicle, 1000) -- Might not be needed
		TaskWarpPedIntoVehicle(GetPlayerPed(-1), callback_vehicle, -1)
	end)
	TriggerServerEvent('Spockee_Garage:breakVehicleSpawn', plate, false)
	
end

function ReturnVehicle()
	local playerPed  = GetPlayerPed(-1)
	if IsPedInAnyVehicle(playerPed,  false) then
		local playerPed    = GetPlayerPed(-1)
		local coords       = GetEntityCoords(playerPed)
		local vehicle      = GetVehiclePedIsIn(playerPed, false)
		local vehicleProps = ESX.Game.GetVehicleProperties(vehicle)
		local current 	   = GetPlayersLastVehicle(GetPlayerPed(-1), true)
		local engineHealth = GetVehicleEngineHealth(current)
		local plate        = vehicleProps.plate

		ESX.TriggerServerCallback('Spockee_Garage:returnVehicle', function(valid)
			if valid then
                BreakReturnVehicle(vehicle, vehicleProps)
			else
				ESX.ShowNotification('Tu ne peu pas garer ce véhicule')
			end
		end, vehicleProps)
	else
		ESX.ShowNotification('Il n y a pas de véhicule à rangé dans le garage.')
	end
end

function BreakReturnVehicle(vehicle, vehicleProps)
	ESX.Game.DeleteVehicle(vehicle)
	TriggerServerEvent('Spockee_Garage:breakVehicleSpawn', vehicleProps.plate, true)
	ESX.ShowNotification("Tu vien de ranger ton ~r~véhicule ~s~!")
end

CreateThread(function()
    if Config.Blip then
        for k, v in pairs(Config.Positions.PED) do
            local blip = AddBlipForCoord(v.pedorient.x, v.pedorient.y, v.pedorient.z)

            SetBlipSprite(blip, 473)
            SetBlipScale (blip, 0.7)
            SetBlipColour(blip, 2)
            SetBlipAsShortRange(blip, true)

            BeginTextCommandSetBlipName('STRING')
            AddTextComponentSubstringPlayerName('Garage')
            EndTextCommandSetBlipName(blip)
        end

		for k, v in pairs(Config.Positions.Pound) do
            local blip = AddBlipForCoord(v.x, v.y, v.z)

            SetBlipSprite(blip, 477)
            SetBlipScale (blip, 0.7)
            SetBlipColour(blip, 9)
            SetBlipAsShortRange(blip, true)

            BeginTextCommandSetBlipName('STRING')
            AddTextComponentSubstringPlayerName('Fourrière')
            EndTextCommandSetBlipName(blip)
        end
    end
end)