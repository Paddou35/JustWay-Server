Config = {}

Config.DrawDistance               = 10.0 -- How close do you need to be in order for the markers to be drawn (in GTA units).

Config.Marker                     = {type = -1, x = 1.0, y = 1.0, z = 1.0, r = 198, g = 190, b = 179, a = 150, rotate = false}

Config.EnablePlayerManagement     = true -- Enable society managing (If you are using esx_society).

Config.OldESXSyst				  = false -- Use old ESX ShareObject system (Before version 1.9)

Config.OxInventory                = ESX.GetConfig().OxInventory

Config.Blip = vector3(438.99,-982.06,30.68)

--- PEDS ---

Config.PEDList = {
	{
		-- Accueil
		spawnpoint = vector4(442.88, -981.96, 29.68, 90),
		pedHashKey = "s_f_y_cop_01"
	},
	--[[{
		-- Saisies
		spawnpoint = vector4(-550.80, -118.40, 32.76, 100),
		pedHashKey = "s_f_y_cop_01"
	},]]
	{
		-- Garage
		spawnpoint = vector4(460.06, -986.66, 24.69, 90),
		pedHashKey = "s_m_y_cop_01"
	},
	{
		-- Armurier
		spawnpoint = vector4(480.593414,-996.567017,29.678345,102.047249),
		pedHashKey = "s_f_y_cop_01"
	},
}

--- Points d'accès au sol (Marker type 27 conseillé pour les placer) ---

Config.Pointeuse = {
	vector3(450.17, -987.61, 30.68)
}

Config.Sonette = {
	vector3(441.19, -981.84, 30.68)
}

Config.Vestiaires = {
	vector3(461.93, -996.46, 30.68),
	vector3(461.93, -999.24, 30.68)
}

--[[Config.VestHelico ={
	vector3(-553.43, -107.96, 49.39)
}]]

Config.Saisies = {
	vector3(474.83, -996.21, 25.27)
}

Config.BossMenu = {
	vector3(460.14, -985.56, 29.73)
}

Config.LSPDGarage = {
	vector3(460.06, -986.66, 24.69)
}

Config.LSPDSpawnVeh = {
	{spawnzone = vector3(-576.55, -86.85, 33.76), heading = 202.00}
}

Config.LSPDRetourVeh = {
	vector3(-583.59, -88.58, 32.76)
}

Config.LSPDHeliport = {
	vector3(442.55, -974.24, 42.70)
}

Config.Armurerie = {
	vector3(-549.00, -118.66, 36.87)
}

--- Listing matériel ---

--[[Config.Heli = {
	{buttoname = "Hélicoptère", spawnname = "polmav", spawnzone = vector3(448.99, -981.41, 43.70), heading = 269, radius = 4.0}
}

Config.ArmurerieArmes = {	
	{buttoname = "Pistolet", arme = "weapon_pistol", prix = 500},
	{buttoname = "Carabine D'assault", arme = "weapon_carbinerifle", prix = 5000},
	{buttoname = "Fusil à pompe", arme = "weapon_pumpshotgun", prix = 6000},
}]]