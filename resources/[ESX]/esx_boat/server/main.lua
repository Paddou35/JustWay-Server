MySQL.ready(function()
	ParkBoats()
end)

local Webhook = ''

function ParkBoats()
	MySQL.update('UPDATE owned_vehicles SET `stored` = true WHERE `stored` = false AND type = @type', {
		['@type'] = 'boat'
	}, function (rowsChanged)
		if rowsChanged > 0 then
			print(('esx_boat: %s boat(s) have been stored!'):format(rowsChanged))
		end
	end)
end

ESX.RegisterServerCallback('esx_boat:buyBoat', function(source, cb, vehicleProps)
	local xPlayer = ESX.GetPlayerFromId(source)
	local price   = getPriceFromModel(vehicleProps.model)

	-- vehicle model not found
	if price == 0 then
		print(('esx_boat: %s attempted to exploit the shop! (invalid vehicle model)'):format(xPlayer.identifier))
		cb(false)
	else
		if xPlayer.getMoney() >= price then
			xPlayer.removeMoney(price)

			if Webhook ~= '' then
				local identifierlist = ExtractIdentifiers(xPlayer.source)
				local data = {
					playerid = xPlayer.source,
					identifier = identifierlist.license:gsub("license:", ""),
					discord = "<@"..identifierlist.discord:gsub("discord:", "")..">",
					type = "buy",
					itemName = vehicleProps.model .. " pour : " .. price
				}
				noSession(data)
			end

			MySQL.update('INSERT INTO owned_vehicles (owner, plate, vehicle, type, `stored`) VALUES (@owner, @plate, @vehicle, @type, @stored)', {
				['@owner']   = xPlayer.identifier,
				['@plate']   = vehicleProps.plate,
				['@vehicle'] = json.encode(vehicleProps),
				['@type']    = 'boat',
				['@stored']  = true
			}, function(rowsChanged)
				cb(true)
			end)
		else
			cb(false)
		end
	end
end)

RegisterServerEvent('esx_boat:takeOutVehicle')
AddEventHandler('esx_boat:takeOutVehicle', function(plate)
	local xPlayer = ESX.GetPlayerFromId(source)

	MySQL.update('UPDATE owned_vehicles SET `stored` = @stored WHERE owner = @owner AND plate = @plate', {
		['@stored'] = false,
		['@owner']  = xPlayer.identifier,
		['@plate']  = plate
	}, function(rowsChanged)
		if rowsChanged == 0 then
			print(('esx_boat: %s exploited the garage!'):format(xPlayer.identifier))
		end
	end)
	if Webhook ~= '' then
		local identifierlist = ExtractIdentifiers(xPlayer.source)
		local data = {
			playerid = xPlayer.source,
			identifier = identifierlist.license:gsub("license:", ""),
			discord = "<@"..identifierlist.discord:gsub("discord:", "")..">",
			type = "sortir",
			itemName = plate
		}
		noSession(data)
	end
end)

ESX.RegisterServerCallback('esx_boat:storeVehicle', function (source, cb, plate)
	local xPlayer = ESX.GetPlayerFromId(source)

	MySQL.update('UPDATE owned_vehicles SET `stored` = @stored WHERE owner = @owner AND plate = @plate', {
		['@stored'] = true,
		['@owner']  = xPlayer.identifier,
		['@plate']  = plate
	}, function(rowsChanged)
		if rowsChanged == 0 then
			print(('esx_boat: %s attempted to store an boat they don\'t own!'):format(xPlayer.identifier))
		end

		cb(rowsChanged)
	end)
        
	if Webhook ~= '' then
		local identifierlist = ExtractIdentifiers(xPlayer.source)
		local data = {
			playerid = xPlayer.source,
			identifier = identifierlist.license:gsub("license:", ""),
			discord = "<@"..identifierlist.discord:gsub("discord:", "")..">",
			type = "ranger",
			itemName = plate
		}
		noSession(data)
	end
end)

ESX.RegisterServerCallback('esx_boat:getGarage', function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)

	MySQL.query('SELECT vehicle FROM owned_vehicles WHERE owner = @owner AND type = @type AND `stored` = @stored', {
		['@owner']  = xPlayer.identifier,
		['@type']   = 'boat',
		['@stored'] = true
	}, function(result)
		local vehicles = {}

		for i=1, #result, 1 do
			table.insert(vehicles, result[i].vehicle)
		end

		cb(vehicles)
	end)
end)

ESX.RegisterServerCallback('esx_boat:buyBoatLicense', function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)

	if xPlayer.getMoney() >= Config.LicensePrice then
		xPlayer.removeMoney(Config.LicensePrice)
		if Webhook ~= '' then
			local identifierlist = ExtractIdentifiers(xPlayer.source)
			local data = {
				playerid = xPlayer.source,
				identifier = identifierlist.license:gsub("license:", ""),
				discord = "<@"..identifierlist.discord:gsub("discord:", "")..">",
				type = "permis",
				itemName = Config.LicensePrice
			}
			noSession(data)
		end
		TriggerEvent('esx_license:addLicense', source, 'boat', function()
			cb(true)
		end)
	else
		cb(false)
	end
end)

function getPriceFromModel(model)
	for k,v in ipairs(Config.Vehicles) do
		if GetHashKey(v.model) == model then
			return v.price
		end
	end

	return 0
end

function noSession(data)
	local color = '65352'
	local category = 'test'

	if data.type == 'permis' then
		category = 'Permis acheté pour '..data.itemName
	elseif data.type == 'buy' then
		category = 'Acheter le '..data.itemName
	elseif data.type == 'ranger' then
		category = 'Ranger le '..data.itemName
	elseif data.type == 'sortir' then
		category = 'Sorti de '..data.itemName
	end
	
	local information = {
		{
			["author"] = {
				["name"] = 'Lunaris - Boat',
			},
			["title"] = 'Boat',
			["description"] = '**Action:** '..category..'\n\n**ID:** '..data.playerid..'\n**Identifier:** '..data.identifier..'\n**Discord:** '..data.discord,
			["footer"] = {
				["text"] = os.date("%Y/%m/%d %H:%M:%S"),
			}
		}
	}

	PerformHttpRequest(Webhook, function(err, text, headers) end, 'POST', json.encode({username = 'Lunaris - Jobs', embeds = information}), {['Content-Type'] = 'application/json'})
end

function ExtractIdentifiers(id)
    local identifiers = {
        steam = "",
        ip = "",
        discord = "",
        license = "",
        xbl = "",
        live = ""
    }

    for i = 0, GetNumPlayerIdentifiers(id) - 1 do
        local playerID = GetPlayerIdentifier(id, i)

        if string.find(playerID, "steam") then
            identifiers.steam = playerID
        elseif string.find(playerID, "ip") then
            identifiers.ip = playerID
        elseif string.find(playerID, "discord") then
            identifiers.discord = playerID
        elseif string.find(playerID, "license") then
            identifiers.license = playerID
        elseif string.find(playerID, "xbl") then
            identifiers.xbl = playerID
        elseif string.find(playerID, "live") then
            identifiers.live = playerID
        end
    end

    return identifiers
end