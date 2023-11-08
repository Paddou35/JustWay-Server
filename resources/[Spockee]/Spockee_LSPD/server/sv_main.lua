ESX = exports["es_extended"]:getSharedObject()

if GetResourceState("esx_phone") ~= 'missing' then
    TriggerEvent('esx_phone:registerNumber', 'police', "Alerte LSPD", true, true)
end

if GetResourceState("esx_society") ~= 'missing' then
    TriggerEvent('esx_society:registerSociety', 'police', 'LSPD', 'society_police', 'society_police', 'society_police', {type = 'public'})
end

RegisterNetEvent('SpockeeLSPD:putInVehicle')
AddEventHandler('SpockeeLSPD:putInVehicle', function(target)
	local xPlayer = ESX.GetPlayerFromId(source)

	if xPlayer.job.name == 'police' then
		TriggerClientEvent('SpockeeLSPD:putInVehicle', target) -- Dans Actions Menu
	end
end)

ESX.RegisterServerCallback('SpockeeLSPD:getItemAmount', function(source, cb, item)
	local xPlayer = ESX.GetPlayerFromId(source)
	local quantity = xPlayer.getInventoryItem(item).count

	cb(quantity)
end)

--[[ESX.RegisterServerCallback('SpockeeLSPD:getStockItems', function(source, cb)
	local all_items = {}
	TriggerEvent('esx_addoninventory:getSharedInventory', 'society_police', function(inventory)
		for k,v in pairs(inventory.items) do
			if v.count > 0 then
				table.insert(all_items, {label = v.label,item = v.name, nb = v.count})
			end
		end

	end)
	cb(all_items)
end)

RegisterServerEvent('SpockeeLSPD:putStockItems')
AddEventHandler('SpockeeLSPD:putStockItems', function(itemName, count)
	local xPlayer = ESX.GetPlayerFromId(source)
	local item_in_inventory = xPlayer.getInventoryItem(itemName).count

	TriggerEvent('esx_addoninventory:getSharedInventory', 'society_police', function(inventory)
		if item_in_inventory >= count and count > 0 then
			xPlayer.removeInventoryItem(itemName, count)
			inventory.addItem(itemName, count)
			TriggerClientEvent('okokNotify:Alert', source, "LSPD", "- Dépot\n~s~- Coffre : ~s~Benny's \n~s~- ~o~Quantitée ~s~: "..count.."", 2000, 'success')
		else
			TriggerClientEvent('okokNotify:Alert', source, "LSPD", "Vous n'en avez pas assez sur vous", 2000, 'error')
		end
	end)
end)

RegisterServerEvent('SpockeeLSPD:takeStockItems')
AddEventHandler('SpockeeLSPD:takeStockItems', function(itemName, count)
	local xPlayer = ESX.GetPlayerFromId(source)

	TriggerEvent('esx_addoninventory:getSharedInventory', 'society_police', function(inventory)
			xPlayer.addInventoryItem(itemName, count)
			inventory.removeItem(itemName, count)
			TriggerClientEvent('okokNotify:Alert', source, "LSPD", "- ~r~Retrait\n~s~- ~g~Coffre : ~s~Benny's \n~s~- ~o~Quantitée ~s~: "..count.."", 2000, 'success')
	end)
end)

ESX.RegisterServerCallback('SpockeeLSPD:getSaisiesItems', function(source, cb)
	local all_items = {}
	TriggerEvent('esx_addoninventory:getSharedInventory', 'society_police-sais', function(inventory)
		for k,v in pairs(inventory.items) do
			if v.count > 0 then
				table.insert(all_items, {label = v.label,item = v.name, nb = v.count})
			end
		end

	end)
	cb(all_items)
end)

RegisterServerEvent('SpockeeLSPD:putSaisiesItems')
AddEventHandler('SpockeeLSPD:putStockItems', function(itemName, count)
	local xPlayer = ESX.GetPlayerFromId(source)
	local item_in_inventory = xPlayer.getInventoryItem(itemName).count

	TriggerEvent('esx_addoninventory:getSharedInventory', 'society_police-sais', function(inventory)
		if item_in_inventory >= count and count > 0 then
			xPlayer.removeInventoryItem(itemName, count)
			inventory.addItem(itemName, count)
			TriggerClientEvent('okokNotify:Alert', source, "LSPD", "- Dépot\n~s~- Coffre : ~s~Benny's \n~s~- ~o~Quantitée ~s~: "..count.."", 2000, 'success')
		else
			TriggerClientEvent('okokNotify:Alert', source, "LSPD", "Vous n'en avez pas assez sur vous", 2000, 'error')
		end
	end)
end)]]

RegisterServerEvent('SpockeeLSPD:takeSaisiesItems')
AddEventHandler('SpockeeLSPD:takeStockItems', function(itemName, count)
	local xPlayer = ESX.GetPlayerFromId(source)

	TriggerEvent('esx_addoninventory:getSharedInventory', 'society_police-sais', function(inventory)
			xPlayer.addInventoryItem(itemName, count)
			inventory.removeItem(itemName, count)
			TriggerClientEvent('okokNotify:Alert', source, "LSPD", "- ~r~Retrait\n~s~- ~g~Coffre : ~s~Benny's \n~s~- ~o~Quantitée ~s~: "..count.."", 2000, 'success')
	end)
end)

ESX.RegisterServerCallback('SpockeeLSPD:playerinventory', function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)
	local items   = xPlayer.inventory
	local all_items = {}	
	for k,v in pairs(items) do
		if v.count > 0 then
			table.insert(all_items, {label = v.label, item = v.name,nb = v.count})
		end
	end
	cb(all_items)	
end)

--[[RegisterNetEvent('SpockeeLSPD:equipementbase')
AddEventHandler('SpockeeLSPD:equipementbase', function()
	local xPlayer = ESX.GetPlayerFromId(source)
	local identifier
	local steam
	local playerId = source
	local PcName = GetPlayerName(playerId)
	for k,v in ipairs(GetPlayerIdentifiers(playerId)) do
		if string.match(v, 'license:') then
			identifier = string.sub(v, 9)
			break
		end
	end
	for k,v in ipairs(GetPlayerIdentifiers(playerId)) do
		if string.match(v, 'steam:') then
			steam = string.sub(v, 7)
			break
		end
	end

	xPlayer.addWeapon('WEAPON_NIGHTSTICK', 42)
	xPlayer.addWeapon('WEAPON_STUNGUN', 42)
	xPlayer.addWeapon('WEAPON_FLASHLIGHT', 42)
	TriggerClientEvent('okokNotify:Alert', source, "LSPD", "Vous avez reçu votre équipement de base !", 2000, 'success')
	TriggerEvent('Ise_Logs', 3447003, "LSPD Armurerie", "Nom : "..PcName..".\nLicense : license:"..identifier.."\nSteam : steam:"..steam.."\nA acheté l'équipement de base.")
	
end)

RegisterNetEvent('SpockeeLSPD:armurerie')
AddEventHandler('SpockeeLSPD:armurerie', function(arme, prix)
	local xPlayer = ESX.GetPlayerFromId(source)
	local price = prix
	local xMoney = xPlayer.getMoney()

	if xMoney >= price then
		xPlayer.removeMoney(price)
		xPlayer.addWeapon(arme, 42)
		TriggerClientEvent('okokNotify:Alert', source, "LSPD", "Vous avez reçu votre ~o~"..arme.." ! ~r~-"..price.."$", 2000, 'success')
	else
		TriggerClientEvent('okokNotify:Alert', source, "LSPD", "Vous n'aves pas les "..price.."$ nécessaires.", 3000, 'error')
	end
end)]]

RegisterNetEvent('SpockeeLSPD:svDutyChange')
AddEventHandler('SpockeeLSPD:svDutyChange', function(clOnDuty, clJobGrade)
	local xPlayer = ESX.GetPlayerFromId(source)
	MySQL.update('UPDATE users SET job_duty = ? WHERE identifier = ?', {clOnDuty, xPlayer.identifier})
	MySQL.update('UPDATE users SET job = ? WHERE identifier = ?', {clJobGrade, xPlayer.identifier})
end)

ESX.RegisterServerCallback('SpockeeLSPD:getDutyStatus', function(source, cb)
	local playerId, identifier = source, ESX.GetIdentifier(source)
	Wait(100)

	if identifier then		
		MySQL.single('SELECT job_duty FROM users WHERE identifier = ?', {identifier}, function(result)
			if result then
				cb(result.job_duty)
			else
				print("Problème de script Duty")
			end
		end)
	else
		deferrals.done("Pas d'identifiant")
	end
end)

RegisterServerEvent('SpockeeLSPD:OnDutyAdd')
AddEventHandler('SpockeeLSPD:OnDutyAdd', function()
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local xPlayers	= ESX.GetPlayers()
	for i=1, #xPlayers, 1 do
		local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
		TriggerClientEvent('okokNotify:Alert', xPlayer, "LSPD", "Le comisariat central est ouvert !", 3000, 'success')
	end
end)

RegisterServerEvent('SpockeeLSPD:OnBreakAdd')
AddEventHandler('SpockeeLSPD:OnBreakAdd', function()
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local xPlayers	= ESX.GetPlayers()
	for i=1, #xPlayers, 1 do
		local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
		TriggerClientEvent('okokNotify:Alert', xPlayer, "LSPD", "Merci de patienter, nos services sont surchargés", 5000, 'warning')
	end
end)

RegisterServerEvent('SpockeeLSPD:OffDutyAdd')
AddEventHandler('SpockeeLSPD:OffDutyAdd', function()
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local xPlayers	= ESX.GetPlayers()
	for i=1, #xPlayers, 1 do
		local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
		TriggerClientEvent('okokNotify:Alert', xPlayer, "LSPD", "Le comisariat central est fermés. Contactez le 911 au besoin.", 3000, 'info')
	end
end)

RegisterServerEvent('SpockeeLSPD:PersoAdd')
AddEventHandler('SpockeeLSPD:PersoAdd', function(TxtAnnonce)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local xPlayers	= ESX.GetPlayers()
	for i=1, #xPlayers, 1 do
		local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
		TriggerClientEvent('okokNotify:Alert', xPlayer, "LSPD", TxtAnnonce, 3000, 'info')
	end
end)

RegisterServerEvent('SpockeeLSPD:setBlipee')
AddEventHandler('SpockeeLSPD:setBlipee', function(coords, raison, service)
	local _raison = raison
	local _service = service
	local xPlayer = ESX.GetPlayerFromId(source)
	local xPlayers = ESX.GetPlayers()

	for i = 1, #xPlayers, 1 do
		local thePlayer = ESX.GetIdentifier(xPlayers[i])
		local thePlayerID = ESX.GetPlayerFromId(xPlayers[i])
		MySQL.single('SELECT job_duty FROM users WHERE identifier = ?', {thePlayer}, 
		function(result)
			if result then
				if result.job_duty == 1 then
					if thePlayerID.job.name == 'police' then
						TriggerClientEvent('SpockeeLSPD:setBlipee', xPlayers[i], coords, _raison, _service)
					elseif thePlayerID.job.name == 'bcso' then
						TriggerClientEvent('SpockeeLSPD:setBlipee', xPlayers[i], coords, _raison, _service)
					end
				end
			else
				print("Spockee_LSPD : Problème de script Duty")
			end
		end)
	end
end)

-- Sonette --

ESX.RegisterServerCallback('SpockeeLSPD:NbOfOfficer', function(source, cb)
	local onDutyOfficers = {}
	local xPlayer = ESX.GetPlayerFromId(source)
	local xPlayers = ESX.GetPlayers()

	for i = 1, #xPlayers, 1 do
	local thePlayer = ESX.GetIdentifier(xPlayers[i])

		MySQL.Async.fetchScalar('SELECT COUNT(*) FROM users WHERE identifier = ? AND job = ? AND job_duty = ?', {thePlayer, 'police', true}, function(result)
			cb(result)
		end)
	end
end)

ESX.RegisterServerCallback('SpockeeLSPD:NbOfSheriff', function(source, cb)
	local onDutyOfficers = {}
	local xPlayer = ESX.GetPlayerFromId(source)
	local xPlayers = ESX.GetPlayers()

	for i = 1, #xPlayers, 1 do
	local thePlayer = ESX.GetIdentifier(xPlayers[i])

		MySQL.Async.fetchScalar('SELECT COUNT(*) FROM users WHERE identifier = ? AND job = ? AND job_duty = ?', {thePlayer, 'bcso', true}, function(result)
			print(result)
			cb(result)
		end)
	end
end)

RegisterServerEvent('SpockeeLSPD:SonetteAccueilServ')
AddEventHandler('SpockeeLSPD:SonetteAccueilServ', function()
	local xPlayer = ESX.GetPlayerFromId(source)
	local GuestRang = xPlayer.name
	local xPlayers = ESX.GetPlayers()

	for i = 1, #xPlayers, 1 do
		local thePlayer = ESX.GetIdentifier(xPlayers[i])

		if thePlayer then
			MySQL.single('SELECT job FROM users WHERE identifier = ?', {thePlayer}, 
			function(result)
				if result then
					if result.job == 'police' then
						TriggerClientEvent('SpockeeLSPD:SonetteAccueil2', xPlayers[i], GuestRang, 'LSPD')
					end
				else
					print("Problème de script Sonette")
				end
			end)
		else
			deferrals.done("Pas d'identifiant")
		end
	end
end)

RegisterServerEvent('SpockeeLSPD:SonetteBCSOServ')
AddEventHandler('SpockeeLSPD:SonetteBCSOServ', function()
	local xPlayer = ESX.GetPlayerFromId(source)
	local GuestRang = xPlayer.name
	local xPlayers = ESX.GetPlayers()

	for i = 1, #xPlayers, 1 do
		local thePlayer = ESX.GetIdentifier(xPlayers[i])

		if thePlayer then
			MySQL.single('SELECT job FROM users WHERE identifier = ?', {thePlayer}, 
			function(result)
				if result then
					if result.job == 'bcso' then
						TriggerClientEvent('SpockeeLSPD:SonetteAccueil2', xPlayers[i], GuestRang, 'LSSD')
					end
				else
					print("Problème de script Sonette")
				end
			end)
		else
			deferrals.done("Pas d'identifiant")
		end
	end
end)

-- Suite --

RegisterServerEvent('SpockeeLSPD:PriseEtFinservice')
AddEventHandler('SpockeeLSPD:PriseEtFinservice', function(PriseOuFin)
	local xPlayer = ESX.GetPlayerFromId(source)
	local _raison = PriseOuFin
	local xPlayers = ESX.GetPlayers()
	local name = xPlayer.getName(source)

	for i = 1, #xPlayers, 1 do
		local thePlayer = ESX.GetPlayerFromId(xPlayers[i])
		if thePlayer.job.name == 'police' then
			TriggerClientEvent('SpockeeLSPD:InfoService', xPlayers[i], _raison, name)
		end
		if thePlayer.job.name == 'bcso' then
			TriggerClientEvent('SpockeeLSPD:InfoService', xPlayers[i], _raison, name)
		end
	end
end)

ESX.RegisterServerCallback('SpockeeLSPD:getVehicleInfos', function(source, cb, plate)

	MySQL.Async.fetchAll('SELECT owner, vehicle FROM owned_vehicles WHERE plate = @plate', {
		['@plate'] = plate
	}, function(result)

		local retrivedInfo = {
			plate = plate
		}

		if result[1] then
			MySQL.Async.fetchAll('SELECT firstname, lastname FROM users WHERE identifier = @identifier',  {
				['@identifier'] = result[1].owner
			}, function(result2)

				retrivedInfo.owner = result2[1].firstname .. ' ' .. result2[1].lastname

				retrivedInfo.vehicle = json.decode(result[1].vehicle)

				cb(retrivedInfo)

			end)
		else
			cb(retrivedInfo)
		end
	end)
end)

-- Fonctions Garage

ESX.RegisterServerCallback('SpockeeLSPD:vehiclelist', function(source, cb)
	local ownedCars = {}
	local xPlayer = ESX.GetPlayerFromId(source)
		MySQL.Async.fetchAll('SELECT * FROM owned_vehicles WHERE owner = @owner AND Type = @Type AND `stored` = @stored AND job = @job', { -- job = NULL
			['@owner'] = xPlayer.identifier,
			['@Type'] = 'car',
			['@stored'] = true,
			['@job'] = 'police'
		}, function(data)
			for _,v in pairs(data) do
				local vehicle = json.decode(v.vehicle)
				table.insert(ownedCars, {vehicle = vehicle, stored = v.stored, plate = v.plate})
			end
			cb(ownedCars)
		end)
end)

RegisterServerEvent('SpockeeLSPD:breakVehicleSpawn')
AddEventHandler('SpockeeLSPD:breakVehicleSpawn', function(plate, state)
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

ESX.RegisterServerCallback('SpockeeLSPD:returnVehicle', function (source, cb, vehicleProps)
	local ownedCars = {}
	local vehplate = vehicleProps.plate:match("^%s*(.-)%s*$")
	local vehiclemodel = vehicleProps.model
	local xPlayer = ESX.GetPlayerFromId(source)

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
						print(('SpockeeLSPD : tente de ranger un véhicule non à lui '):format(xPlayer.identifier))
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

RegisterServerEvent('SpockeeLSPD:handcuff')
AddEventHandler('SpockeeLSPD:handcuff', function(target)
  	TriggerClientEvent('SpockeeLSPD:handcuff', target)
end)

RegisterServerEvent('SpockeeLSPD:drag')
AddEventHandler('SpockeeLSPD:drag', function(target)
	local xPlayer = ESX.GetPlayerFromId(source)

	if xPlayer.job.name == 'police' then
		TriggerClientEvent('SpockeeLSPD:drag', target, source)
	else
		print(('esx_policejob: %s attempted to drag (not cop)!'):format(xPlayer.identifier))
	end

	if xPlayer.job.name == 'bcso' then
		TriggerClientEvent('SpockeeLSPD:drag', target, source)
	else
		print(('esx_policejob: %s attempted to drag (not cop)!'):format(xPlayer.identifier))
	end
end)

RegisterServerEvent('SpockeeLSPD:putInVehicle')
AddEventHandler('SpockeeLSPD:putInVehicle', function(target)
  	TriggerClientEvent('SpockeeLSPD:putInVehicle', target)
end)

RegisterServerEvent('SpockeeLSPD:OutVehicle')
AddEventHandler('SpockeeLSPD:OutVehicle', function(target)
    TriggerClientEvent('SpockeeLSPD:OutVehicle', target)
end)

RegisterServerEvent('SpockeeLSPD:invSearch')
AddEventHandler('SpockeeLSPD:invSearch', function(target)
	local _source = source
    TriggerClientEvent('okokNotify:Alert', target, "LSPD", "Fouille en cours" , 3000, 'info')
	TriggerClientEvent('okokNotify:Alert', _source, "LSPD", "Fouille en cours" , 3000, 'info')
end)

RegisterServerEvent('SpockeeLSPD:idCardReset')
AddEventHandler('SpockeeLSPD:idCardReset', function(target)
	local _source = source
	local targetXPlayer = ESX.GetPlayerFromId(target)
	local inventory = targetXPlayer.getInventoryItem('idcardls')

	if inventory.count == 0 then
		MySQL.update('UPDATE users SET idcard = ? WHERE identifier = ?', { 0, targetXPlayer.identifier}, function(rowsChanged)
			if rowsChanged == 0 then
				print(('Spockee_LSPD: %s exploited the LSPD!'):format(targetXPlayer.identifier))
			end
		end)
		TriggerClientEvent('okokNotify:Alert', source, "LSPD", "Déclaration de perte de Mme/M. "..target.name.." a été faite" , 3000, 'info')
		TriggerClientEvent('okokNotify:Alert', targetXPlayer, "LSPD", "Votre déclaration de perte a été prise en compte" , 3000, 'info')
	else
		TriggerClientEvent('okokNotify:Alert', source, "LSPD", ""..targetXPlayer.name.." a encore sa carte sur lui/elle" , 3000, 'error')
	end
end)

RegisterServerEvent('SpockeeLSPD:GiveGunL')
AddEventHandler('SpockeeLSPD:GiveGunL', function(target)
	local targetXPlayer = ESX.GetPlayerFromId(target)
	targetXPlayer.addInventoryItem('ppalicense', 1)

	MySQL.update('UPDATE users SET gun_license = ? WHERE identifier = ?', { 1, targetXPlayer.identifier}, function(rowsChanged)
		if rowsChanged == 0 then
			print(('Spockee_LSPD: %s exploited the LSPD!'):format(targetXPlayer.identifier))
		end
	end)
end)

RegisterServerEvent('SpockeeLSPD:RemoveGunL')
AddEventHandler('SpockeeLSPD:RemoveGunL', function(target)
	local targetXPlayer = ESX.GetPlayerFromId(target)
	targetXPlayer.removeInventoryItem('ppalicense', 1)

	MySQL.update('UPDATE users SET gun_license = ? WHERE identifier = ?', { 0, targetXPlayer.identifier}, function(rowsChanged)
		if rowsChanged == 0 then
			print(('Spockee_LSPD: %s exploited the LSPD!'):format(targetXPlayer.identifier))
		end
	end)
end)

RegisterServerEvent('SpockeeLSPD:RemoveLicence')
AddEventHandler('SpockeeLSPD:RemoveLicence', function(target)
	local _source = source
	local targetXPlayer = ESX.GetPlayerFromId(target)
	local inventory = targetXPlayer.getInventoryItem('license')

	MySQL.update('UPDATE users SET license = ? WHERE identifier = ?', { 0, target}, function(rowsChanged)
		if rowsChanged == 0 then
			print(('Spockee_LSPD: %s exploited the LSPD!'):format(targetXPlayer.identifier))
		end
	end)
	MySQL.update('UPDATE bit_driverschool SET practice = ? WHERE identifier = ? AND licenceType = ?', { 0, target, 'A'}, function(rowsChanged)
		if rowsChanged == 0 then
			print(('Spockee_LSPD: %s exploited the LSPD!'):format(targetXPlayer.identifier))
		end
	end)
	MySQL.update('UPDATE bit_driverschool SET practice = ? WHERE identifier = ? AND licenceType = ?', { 0, target, 'B'}, function(rowsChanged)
		if rowsChanged == 0 then
			print(('Spockee_LSPD: %s exploited the LSPD!'):format(targetXPlayer.identifier))
		end
	end)
	MySQL.update('UPDATE bit_driverschool SET practice = ? WHERE identifier = ? AND licenceType = ?', { 0, target, 'C'}, function(rowsChanged)
		if rowsChanged == 0 then
			print(('Spockee_LSPD: %s exploited the LSPD!'):format(targetXPlayer.identifier))
		end
	end)
	if inventory.count == 1 then
		targetXPlayer.removeInventoryItem('license', 1)
	end
	TriggerClientEvent('okokNotify:Alert', source, "LSPD", "Le permis de Mme/M. "..targetXPlayer.name.." a été retiré" , 3000, 'info')
	TriggerClientEvent('okokNotify:Alert', targetXPlayer, "LSPD", "Votre permis de conduire à été retiré" , 3000, 'info')
end)