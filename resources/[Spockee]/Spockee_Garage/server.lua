ESX = exports["es_extended"]:getSharedObject()
--[[ESX = nil

CreateThread(function()
	if Config.OldESXSyst == true then
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Wait(10)
	else
		ESX = exports["es_extended"]:getSharedObject()
	end
end)]]

ESX.RegisterServerCallback('Spockee_Garage:vehiclelistfourriere', function(source, cb)
	local ownedCars = {}
	local xPlayer = ESX.GetPlayerFromId(source)
		MySQL.Async.fetchAll('SELECT * FROM owned_vehicles WHERE owner = @owner AND Type = @Type AND `stored` = @stored AND job = @job', {
			['@owner'] = xPlayer.identifier,
			['@Type'] = 'car',
			['@stored'] = false,
			['@job'] = '0'
		}, function(data)
			for _,v in pairs(data) do
				local vehicle = json.decode(v.vehicle)
				table.insert(ownedCars, {vehicle = vehicle, stored = v.stored, plate = v.plate})
			end
			cb(ownedCars)
		end)
end)

ESX.RegisterServerCallback('Spockee_Garage:vehiclelist', function(source, cb)
	local ownedCars = {}
	local xPlayer = ESX.GetPlayerFromId(source)

	local ped = GetPlayerPed(source)
	local playerCoords = GetEntityCoords(ped)
	
	for k, v in pairs(Config.Positions.PED) do
		local CoordsX = v.spawnpoint.x - playerCoords.x
		if CoordsX <= 2.0 and CoordsX >= -2.0 then
			local CoordsY = v.spawnpoint.y - playerCoords.y
			if CoordsY <= 2.0 and CoordsY >= -2.0 then
				local CoordsZ = v.spawnpoint.z - playerCoords.z
				if CoordsZ <= 2.0 and CoordsZ >= -2.0 then
					GarageName = v.garageID
				end
			end
		end
	end

	MySQL.Async.fetchAll('SELECT * FROM owned_vehicles WHERE owner = @owner AND Type = @Type AND `stored` = @stored AND garage = @garage_id AND job = @job', {
		['@owner'] = xPlayer.identifier,
		['@Type'] = 'car',
		['@stored'] = true,
		['@garage_id'] = GarageName,
		['@job'] = '0'
	}, function(data)
		for _,v in pairs(data) do
			local vehicle = json.decode(v.vehicle)
			table.insert(ownedCars, {vehicle = vehicle, stored = v.stored, plate = v.plate})
		end
		cb(ownedCars)
	end)
end)

RegisterServerEvent('Spockee_Garage:breakVehicleSpawn')
AddEventHandler('Spockee_Garage:breakVehicleSpawn', function(plate, state)
	local xPlayer = ESX.GetPlayerFromId(source)

	MySQL.Async.execute('UPDATE owned_vehicles SET `stored` = @stored WHERE plate = @plate', {
		['@stored'] = state,
		['@plate'] = plate
	}, function(rowsChanged)
		if rowsChanged == 0 then
			print(('esx_advancedgarage: %s exploited the garage!'):format(xPlayer.identifier))
		end
	end)
end)

ESX.RegisterServerCallback('Spockee_Garage:returnVehicle', function (source, cb, vehicleProps)
	local ownedCars = {}
	local vehplate = vehicleProps.plate:match("^%s*(.-)%s*$")
	local vehiclemodel = vehicleProps.model
	local xPlayer = ESX.GetPlayerFromId(source)
	local GarageID = ""

	local ped = GetPlayerPed(source)
	local playerCoords = GetEntityCoords(ped)
	
	for k, v in pairs(Config.Positions.Return) do
		local CoordsX = v.returnzone.x - playerCoords.x
		if CoordsX <= 2.0 and CoordsX >= -2.0 then
			local CoordsY = v.returnzone.y - playerCoords.y
			if CoordsY <= 2.0 and CoordsY >= -2.0 then
				local CoordsZ = v.returnzone.z - playerCoords.z
				if CoordsZ <= 2.0 and CoordsZ >= -2.0 then
					GarageID = v.garageID
				end
			end
		end
	end

	MySQL.Async.fetchAll('SELECT * FROM owned_vehicles WHERE owner = @owner AND @plate = plate', {
		['@owner'] = xPlayer.identifier,
		['@plate'] = vehicleProps.plate
	}, function (result)
		if result[1] ~= nil then
			local originalvehprops = json.decode(result[1].vehicle)
			if originalvehprops.model == vehiclemodel then
				MySQL.Async.execute('UPDATE owned_vehicles SET vehicle = @vehicle WHERE owner = @owner AND plate = @plate', {
					['@owner'] = xPlayer.identifier,
					['@vehicle'] = json.encode(vehicleProps),
					['@plate'] = vehicleProps.plate
				}, function (rowsChanged)
					if rowsChanged == 0 then
						print(('Spockee_Garage : tente de ranger un véhicule non à lui '):format(xPlayer.identifier))
					end
				end)
				MySQL.Async.execute('UPDATE owned_vehicles SET garage = @garage_id WHERE owner = @owner AND plate = @plate', {
					['@owner'] = xPlayer.identifier,
					['@garage_id'] = GarageID,
					['@plate'] = vehicleProps.plate
				}, function (rowsChanged)
					if rowsChanged == 0 then
						print(('Spockee_Garage : tente de ranger un véhicule dans le mauvais garage '):format(xPlayer.identifier))
					end
					cb(true)
				end)
			else
				cb(false)
			end
		else
			cb(false)
		end
	end)
end)

ESX.RegisterServerCallback('Spockee_Garage:achat', function(source, cb)
    local _src = source
	local xPlayer = ESX.GetPlayerFromId(source)

    if xPlayer.getMoney() >= 500 then
        xPlayer.removeMoney(500)
        TriggerClientEvent('esx:showNotification', _src, "Vous avez payer ~r~500$ ~s~!")
        cb(true)
    else
        TriggerClientEvent('esx:showNotification', _src, "~r~Vous n'avez pas suffisament d'argent !")
        cb(false)
    end
end)

RegisterNetEvent("myCoordinates")
AddEventHandler("myCoordinates", ShowCoordinates)