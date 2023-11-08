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
local MenuPound = RageUI.CreateMenu("Fourrière", "INTERACTION")
MenuPound.Display.Header = true 
MenuPound.Closed = function()
    open = false
end

Pound = {
    poundlist = {}
}

function OpenMenuPound() 
    if open then 
        open = false
        RageUI.Visible(MenuPound, false)
        return
    else
        open = true
        RageUI.Visible(MenuPound, true)
        Citizen.CreateThread(function()
            while open do 
                RageUI.IsVisible(MenuPound, function()
                RageUI.Separator("↓     ~b~Véhicule     ~s~↓")
                for i = 1, #Pound.poundlist, 1 do
                    local hashvehicle = Pound.poundlist[i].vehicle.model
                    local modelevehiclespawn = Pound.poundlist[i].vehicle
                    local nomvehiclemodele = GetDisplayNameFromVehicleModel(hashvehicle)
                    local nomvehicletexte  = GetLabelText(nomvehiclemodele)
                    local plaque = Pound.poundlist[i].plate
        
        
                    RageUI.Button(nomvehicletexte.." | "..plaque, nil, {RightLabel = "~y~→"}, true, {
                        onSelected = function() 
                            ESX.TriggerServerCallback('Spockee_Garage:achat', function(suffisantsous)
                                if suffisantsous then
                                    SpawnVehicle(modelevehiclespawn, plaque)
                                    RageUI.CloseAll()
                                    publicfourriere = false
                                else
                                    ESX.ShowNotification('Tu n\'as pas assez d argent!')
                                end
                            end)
                        end
                    })
                end

                RageUI.Separator("↓ ~r~    Fermeture    ~s~↓")
                RageUI.Button("Fermer", nil, {Color = {BackgroundColor = {255, 0, 0, 50}}, RightLabel = "~y~→→"}, true , {
                    onSelected = function()
                        RageUI.CloseAll()
                        open = false
                    end
                })
                end)
            Wait(0)
            end
        end)
    end
end

Citizen.CreateThread(function()
    while true do
		local wait = 750

			for k in pairs(Config.Positions.Pound) do
			local plyCoords = GetEntityCoords(GetPlayerPed(-1), false)
			local pos = Config.Positions.Pound
			local dist = Vdist(plyCoords.x, plyCoords.y, plyCoords.z, pos[k].x, pos[k].y, pos[k].z)

			if dist <= Config.MarkerDistance then
				wait = 0
				DrawMarker(Config.MarkerType, pos[k].x, pos[k].y, pos[k].z, 0.0, 0.0, 0.0, 0.0,0.0,0.0, Config.MarkerSizeLargeur, Config.MarkerSizeEpaisseur, Config.MarkerSizeHauteur, 252, 157, 3, Config.MarkerOpacite, Config.MarkerSaute, true, p19, Config.MarkerTourne)  

				if dist <= 2.0 then
				wait = 0
                    Visual.FloatingHelpText("Appuyez sur ~INPUT_CONTEXT~", 1)  
					if IsControlJustPressed(1,51) then
						ESX.TriggerServerCallback('Spockee_Garage:vehiclelistfourriere', function(ownedCars)
                            Pound.poundlist = ownedCars
                        end)
						OpenMenuPound()
					end
				end
			end
    	end
	Wait(wait)
	end
end)