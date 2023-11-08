Config               = {}

Config.Locale        = 'fr'

Config.LicenseEnable = true -- enable boat license? Requires esx_license
Config.LicensePrice  = 5000

Config.MarkerType    = 1
Config.DrawDistance  = 10.0

Config.Marker = {
	r = 100, g = 204, b = 100, -- blue-ish color
	x = 1.5, y = 1.5, z = 1.0  -- standard size circle
}

Config.StoreMarker = {
	r = 255, g = 0, b = 0,     -- red color
	x = 5.0, y = 5.0, z = 1.0  -- big circle for storing boat
}

Config.Zones = {

	Garages = {

		{ -- Shank St, nearby campaign boat garage
			GaragePos  = vector3(-772.4, -1430.9, 0.5),
			SpawnPoint = vector4(-785.39, -1426.3, 0.0, 146.0),
			StorePos   = vector3(-798.4, -1456.0, 0.0),
			StoreTP    = vector4(-791.4, -1452.5, 1.5, 318.9)
		},

		{ -- Catfish View
			GaragePos  = vector3(3864.9, 4463.9, 1.6),
			SpawnPoint = vector4(3854.4, 4477.2, 0.0, 273.0),
			StorePos   = vector3(3857.0, 4446.9, 0.0),
			StoreTP    = vector4(3854.7, 4458.6, 1.8, 355.3)
		},

		{ -- Great Ocean Highway
			GaragePos  = vector3(-1614.0, 5260.1, 2.8),
			SpawnPoint = vector4(-1622.5, 5247.1, 0.0, 21.0),
			StorePos   = vector3(-1600.3, 5261.9, 0.0),
			StoreTP    = vector4(-1605.7, 5259.0, 2.0, 25.0)
		},

		{ -- North Calafia Way
			GaragePos  = vector3(712.6, 4093.3, 33.7),
			SpawnPoint = vector4(712.8, 4080.2, 29.3, 181.0),
			StorePos   = vector3(705.1, 4110.1, 30.2),
			StoreTP    = vector4(711.9, 4110.5, 31.3, 180.0)
		},

		{ -- Elysian Fields, nearby the airport
			GaragePos  = vector3(23.8, -2806.8, 4.8),
			SpawnPoint = vector4(23.3, -2828.6, 0.8, 181.0),
			StorePos   = vector3(-1.0, -2799.2, 0.5),
			StoreTP    = vector4(12.6, -2793.8, 2.5, 355.2)
		},

		{ -- Barbareno Rd
			GaragePos  = vector3(-3427.3, 956.9, 7.3),
			SpawnPoint = vector4(-3448.9, 953.8, 0.0, 75.0),
			StorePos   = vector3(-3436.5, 946.6, 0.3),
			StoreTP    = vector4(-3427.0, 952.6, 8.3, 0.0)
		},

	},

	BoatShops = {

		{ -- Shank St, nearby campaign boat garage
			Outside = vector3(-773.7, -1495.2, 1.6),
			Inside = vector4(-798.5, -1503.1, -0.4, 120.0)
		}

	}

}

Config.Vehicles = {
	{model = 'dinghy', label = 'Dinghy', price = 60000},
	{model = 'jetmax', label = 'JetMax', price = 120000},
	{model = 'marquis', label = 'Marquis', price = 160000},
	{model = 'seashark', label = 'Seashark', price = 10000},
	{model = 'speeder', label = 'Speeder', price = 90000},
	{model = 'speeder2', label = 'Speeder 2', price = 95000},
	{model = 'squalo', label = 'Squalo', price = 100000},
	{model = 'suntrap', label = 'Suntrap', price = 70000},
	{model = 'toro', label = 'Toro', price = 130000},
	{model = 'toro2', label = 'Toro 2', price = 140000},
	{model = 'submersible', label = 'Submersible', price = 750000},
	{model = 'avisa', label = 'Avisa', price = 1000000},
	{model = 'tropic', label = 'Tropic', price = 80000},
	{model = 'tropic2', label = 'Tropic 2', price = 85000},
	{model = 'longfin', label = 'Longfin', price = 160000}
}

Config.WebhookURL = ""
Config.DateFormat = '%d/%m/%Y [%X]'