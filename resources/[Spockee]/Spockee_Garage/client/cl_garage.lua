GaragePos = nil

CreateThread(function()
    if Config.OldESXSyst == true then
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Wait(10)
    else
        ESX = exports["es_extended"]:getSharedObject()
    end
end)

-- Menu --
local open = false 
local MenuGarage = RageUI.CreateMenu("Garage", "INTERACTION")
MenuGarage.Display.Header = true 
MenuGarage.Closed = function()
    open = false
end

Garage = {
    vehiclelist = {},
}

function OpenMenuGarage() 
    if open then 
        open = false
        RageUI.Visible(MenuGarage, false)
        return
    else
        open = true
        RageUI.Visible(MenuGarage, true)
        Citizen.CreateThread(function()
            while open do 
                RageUI.IsVisible(MenuGarage, function()

                    
                    for i = 1, #Garage.vehiclelist, 1 do
                        local hashvehicle = Garage.vehiclelist[i].vehicle.model
                        local modelevehiclespawn = Garage.vehiclelist[i].vehicle
                        local nomvehiclemodele = GetDisplayNameFromVehicleModel(hashvehicle)
                        local nomvehicletexte  = GetLabelText(nomvehiclemodele)
                        local plaque = Garage.vehiclelist[i].plate

                        RageUI.Button(nomvehicletexte.." | "..plaque, "Pour sortir votre véhicule", {RightLabel = "→→→"}, true, {onSelected = function()  
                                SpawnVehicle(modelevehiclespawn, plaque)
                                RageUI.CloseAll()
                                open = false
                        end})
                    end

                    RageUI.Button("Fermer", nil, {Color = {BackgroundColor = {255, 0, 0, 50}}, RightLabel = "→→"}, true , {onSelected = function()
                            RageUI.CloseAll()
                            open = false
                    end})

                end)
            Wait(0)
            end
        end)
    end
end

-- Sortie

CreateThread(function()
    while true do
		local wait = 750

			for k, v in pairs(Config.Positions.PED) do
			local plyCoords = GetEntityCoords(GetPlayerPed(-1), false)
			local dist = Vdist(plyCoords.x, plyCoords.y, plyCoords.z, v.spawnpoint.x, v.spawnpoint.y, v.spawnpoint.z)

			if dist <= Config.MarkerDistance then
				wait = 1
				DrawMarker(-1, v.spawnpoint.x, v.spawnpoint.y, v.spawnpoint.z, 0.0, 0.0, 0.0, 0.0,0.0,0.0, Config.MarkerSizeLargeur, Config.MarkerSizeEpaisseur, Config.MarkerSizeHauteur, 3, 252, 65, Config.MarkerOpacite, Config.MarkerSaute, true, p19, Config.MarkerTourne)  

				if dist <= 2.0 then
				wait = 1
                    Visual.FloatingHelpText("Appuyez sur ~INPUT_CONTEXT~", 1) 
					if IsControlJustPressed(1,51) then
						ESX.TriggerServerCallback('Spockee_Garage:vehiclelist', function(ownedCars)
                            Garage.vehiclelist = ownedCars
                        end)
						OpenMenuGarage()
					end
				end
			end
    	end
	Wait(wait)
	end
end)

-- Retour

CreateThread(function()
    while true do
		local wait = 750

			for k, v in pairs(Config.Positions.Return) do
			local plyCoords = GetEntityCoords(GetPlayerPed(-1), false)
			local dist = Vdist(plyCoords.x, plyCoords.y, plyCoords.z, v.returnzone.x, v.returnzone.y, v.returnzone.z)

			if dist <= Config.MarkerDistance then
                wait = 1
                if IsPedSittingInAnyVehicle(PlayerPedId()) then
                    DrawMarker(27, v.returnzone.x, v.returnzone.y, v.returnzone.z, 0.0, 0.0, 0.0, 0.0,0.0,0.0, Config.MarkerSizeLargeur, Config.MarkerSizeEpaisseur, Config.MarkerSizeHauteur, 252, 3, 3, Config.MarkerOpacite, Config.MarkerSaute, true, p19, Config.MarkerTourne)  

                    if dist <= 2.0 then
                    wait = 1
                        Visual.FloatingHelpText("Appuyez sur ~INPUT_CONTEXT~", 1) 
                        if IsControlJustPressed(1,51) then
                            ReturnVehicle()
                        end
                    end
                end
			end
    	end
	Wait(wait)
	end
end)

RegisterNetEvent("Spockee_Garage:OpenGarageMenu") AddEventHandler("Spockee_Garage:OpenGarageMenu", function() OpenMenuGarage() end)