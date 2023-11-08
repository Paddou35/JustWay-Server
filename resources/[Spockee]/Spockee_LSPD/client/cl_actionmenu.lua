ServiceName = {}

CreateThread(function()
    if Config.OldESXSyst == true then
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Wait(10)
    else
        ESX = exports["es_extended"]:getSharedObject()
    end
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
	ESX.PlayerData = xPlayer
end)

function KeyboardInput(TextEntry, ExampleText, MaxStringLenght)

    AddTextEntry('FMMC_KEY_TIP1', TextEntry) 
    
    blockinput = true 
    DisplayOnscreenKeyboard(1, "FMMC_KEY_TIP1", "Somme", ExampleText, "", "", "", MaxStringLenght) 
    while UpdateOnscreenKeyboard() ~= 1 and UpdateOnscreenKeyboard() ~= 2 do 
        Citizen.Wait(0)
    end 
         
    if UpdateOnscreenKeyboard() ~= 2 then
        local result = GetOnscreenKeyboardResult()
        Citizen.Wait(500) 
        blockinput = false
        return result 
    else
        Citizen.Wait(500) 
        blockinput = false 
        return nil 
    end
end

local open = false 
local ActionMenuLSPD = RageUI.CreateMenu('', 'Faites votre choix ?')
local RenfortsMenu = RageUI.CreateSubMenu(ActionMenuLSPD,"", "Annonces possibles :")
local InformationsMenu = RageUI.CreateSubMenu(ActionMenuLSPD,"", "Annonces possibles :")
local PlaqueMenu = RageUI.CreateSubMenu(ActionMenuLSPD,"", "Informations :")
local InteractionMenu = RageUI.CreateSubMenu(ActionMenuLSPD,"", "Actions possibles :")
local LicencesMenu = RageUI.CreateSubMenu(InteractionMenu,"", "Actions possibles :")
ActionMenuLSPD.Display.Header = true 
ActionMenuLSPD.Closed = function()
  open = false
end

function ActionsMenuLSPD()
    
    ESX.TriggerServerCallback('SpockeeLSPD:getDutyStatus', function(result)
        if result == 0 then
            exports['okokNotify']:Alert(ServiceName, "Tu n'es pas en service", 1000, 'warning')
        else
            if open then 
                open = false
                RageUI.Visible(ActionMenuLSPD, false)
                return
            else
                open = true 
                RageUI.Visible(ActionMenuLSPD, true)
                CreateThread(function()
                    while open do 
                        local numplaque = ""
                        local length = 0
                        RageUI.IsVisible(ActionMenuLSPD,function()
                            local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
    
                            RageUI.Separator("↓    Section Informations    ↓")
    
                            RageUI.Button("Demande de renforts", nil, {RightLabel = "→"}, true, {onSelected = function()
                            end},RenfortsMenu);
    
                            RageUI.Button("Communications Internes", nil, {RightLabel = "→"}, true, {onSelected = function()
                            end},InformationsMenu);
    
                            RageUI.Button("Droits Miranda", "Afficher les droits miranda", {RightLabel = "→"}, true, {onSelected = function()
                                exports['okokNotify']:Alert(ServiceName, "Monsieur / Madame [Inserer nom ici], je vous arrête pour [Motif de l'arrestation].", 10000, 'info')
                                Wait(2000)
                                exports['okokNotify']:Alert(ServiceName, "Vous avez le droit de garder le silence.", 10000, 'info')
                                Wait(2000)
                                exports['okokNotify']:Alert(ServiceName, "Si vous renoncez à ce droit, tout ce que vous direz pourra être et sera utilisé contre vous.", 10000, 'info')
                                Wait(2000)
                                exports['okokNotify']:Alert(ServiceName, "Vous avez le droit à un avocat, si vous n’en avez pas les moyens, un avocat vous sera fourni.", 10000, 'info')
                                Wait(2000)
                                exports['okokNotify']:Alert(ServiceName, "Vous avez le droit à une assistance médicale ainsi qu'à de la nourriture et de l'eau.", 10000, 'info')
                                Wait(2000)
                                exports['okokNotify']:Alert(ServiceName, "Avez-vous bien compris vos droits ?", 10000, 'info')
                            end});
    
                            RageUI.Separator("↓    Section Intéractions    ↓")
    
                            --[[RageUI.Button("Créer une facture", nil, {RightLabel = "→"}, true, {onSelected = function()
                                local player, distance = ESX.Game.GetClosestPlayer()
                                local raison = ""
                                local montant = 0
                                AddTextEntry("FMMC_MPM_NA", "Objet de la facture")
                                DisplayOnscreenKeyboard(1, "FMMC_MPM_NA", "Donnez le motif de la facture :", "", "", "", "", 30)
                                while (UpdateOnscreenKeyboard() == 0) do
                                    DisableAllControlActions(0)
                                    Wait(0)
                                end
                                if (GetOnscreenKeyboardResult()) then
                                    local result = GetOnscreenKeyboardResult()
                                    if result then
                                        raison = result
                                        result = nil
                                        AddTextEntry("FMMC_MPM_NA", "Montant de la facture")
                                        DisplayOnscreenKeyboard(1, "FMMC_MPM_NA", "Indiquez le montant de la facture :", "", "", "", "", 30)
                                        while (UpdateOnscreenKeyboard() == 0) do
                                            DisableAllControlActions(0)
                                            Wait(0)
                                        end
                                        if (GetOnscreenKeyboardResult()) then
                                            result = GetOnscreenKeyboardResult()
                                            if result then
                                                montant = result
                                                result = nil
                                                if player ~= -1 and distance <= 3.0 then
                                                    TriggerServerEvent('esx_billing:sendBill', GetPlayerServerId(player), 'society_police', ('LSPD'), montant)
                                                    exports['okokNotify']:Alert(ServiceName, "Vous venez de facturer : "..GetPlayerName(player).."", 2000, 'Success')
                                                    Wait(200)
                                                    exports['okokNotify']:Alert(ServiceName, "Montant de la facture : "..montant.."$", 2000, 'Success')
                                                    Wait(200)
                                                    exports['okokNotify']:Alert(ServiceName, "Raison : "..raison.."", 2000, 'Success')
                                                else
                                                    exports['okokNotify']:Alert(ServiceName, "Pas de citoyen à proximité", 2000, 'error')
                                                end
                                            end
                                        end
                                    end
                                end
                            end});]]
    
                            RageUI.Button("Interagir avec le citoyen", "Fouilles, papiers, déplacements", {RightLabel = "→"}, true, {onSelected = function()
                            end},InteractionMenu);
    
                            RageUI.Button("Mise en Fourrière", "Mettre le véhicule en fourrière", {RightLabel = "→"}, true, {onSelected = function()
                                local playerPed = PlayerPedId()    
                                if IsPedSittingInAnyVehicle(playerPed) then
                                    local vehicle = GetVehiclePedIsIn(playerPed, false)                
                                    if GetPedInVehicleSeat(vehicle, -1) == playerPed then
                                        exports['okokNotify']:Alert(ServiceName, "Véhicule correctement mis en fourrière", 2000, 'success')
                                        ESX.Game.DeleteVehicle(vehicle)                                
                                    else
                                        exports['okokNotify']:Alert(ServiceName, "Sort de la voiture pour faire cette action", 2000, 'error')
                                    end
                                else
                                    local vehicle = ESX.Game.GetVehicleInDirection()
                    
                                    if DoesEntityExist(vehicle) then
                                        exports['okokNotify']:Alert(ServiceName, "Véhicule correctement mis en fourrière", 2000, 'success')
                                        ESX.Game.DeleteVehicle(vehicle)                
                                    else
                                        exports['okokNotify']:Alert(ServiceName, "Pas de véhicule à proximité", 2000, 'error')
                                    end
                                end
                            end});
    
                            --[[RageUI.Button("Rechercher une plaque", nil, {RightLabel = "→"}, true, {onSelected = function()
                                numplaque = KeyboardInput("Numéro de la plaque ?", "", 10)
                                length = string.len(numplaque)
                                if not numplaque or length < 2 or length > 8 then
                                    exports['okokNotify']:Alert(ServiceName, "Ce n'est pas un numéro d'enregistrement valide", 2000, 'warning')
                                    RageUI.CloseAll()                                                             
                                end
                            end},PlaqueMenu);]]
    
                            RageUI.Button("Poser/Prendre Radar",nil, {RightLabel = "→"}, true, {onSelected = function()
                                RageUI.CloseAll()       
                                TriggerEvent('SpockeeLSPD:POLICE_radar')
                            end});
                        end)
    
                        RageUI.IsVisible(RenfortsMenu,function()
                            RageUI.Button("Renforts légés", nil, {RightLabel = "→"}, true, {onSelected = function()
                                local raison = 'petit'
                                local elements  = {}
                                local playerPed = PlayerPedId()
                                local coords  = GetEntityCoords(playerPed)
                                local name = GetPlayerName(PlayerId())
                                TriggerServerEvent('SpockeeLSPD:setBlipee', coords, raison, ServiceName)
                            end});
                
                            RageUI.Button("Renforts importants", nil, {RightLabel = "→"}, true, {onSelected = function()
                                local raison = 'importante'
                                local elements  = {}
                                local playerPed = PlayerPedId()
                                local coords  = GetEntityCoords(playerPed)
                                local name = GetPlayerName(PlayerId())
                                TriggerServerEvent('SpockeeLSPD:setBlipee', coords, raison, ServiceName)
                            end});
                
                            RageUI.Button("ALERTE GENERALE !!!", nil, {RightLabel = "→"}, true, {onSelected = function()
                                local raison = 'omgad'
                                local elements  = {}
                                local playerPed = PlayerPedId()
                                local coords  = GetEntityCoords(playerPed)
                                local name = GetPlayerName(PlayerId())
                                TriggerServerEvent('SpockeeLSPD:setBlipee', coords, raison, ServiceName)
                            end});
                        end)
                        
                        RageUI.IsVisible(InformationsMenu,function()    
                            RageUI.Button("Prise de service", nil, {RightLabel = "→"}, true, {onSelected = function()
                                    local info = 'prise'
                                    TriggerServerEvent('SpockeeLSPD:PriseEtFinservice', info)
                            end});
                    
                            RageUI.Button("Fin de service", nil, {RightLabel = "→"}, true, {onSelected = function()
                                    local info = 'fin'
                                    TriggerServerEvent('SpockeeLSPD:PriseEtFinservice', info)
                            end});
                    
                            RageUI.Button("Pause de service", nil, {RightLabel = "→"}, true, {onSelected = function()
                                    local info = 'pause'
                                    TriggerServerEvent('SpockeeLSPD:PriseEtFinservice', info)
                            end});
                    
                            RageUI.Button("Standby", nil, {RightLabel = "→"}, true, {onSelected = function()
                                    local info = 'standby'
                                    TriggerServerEvent('SpockeeLSPD:PriseEtFinservice', info)
                            end});
                    
                            RageUI.Button("Contrôle en cours", nil, {RightLabel = "→"}, true, {onSelected = function()
                                    local info = 'control'
                                    TriggerServerEvent('SpockeeLSPD:PriseEtFinservice', info)
                            end});
                    
                            RageUI.Button("Refus d'obtempérer", nil, {RightLabel = "→"}, true, {onSelected = function()
                                    local info = 'refus'
                                    TriggerServerEvent('SpockeeLSPD:PriseEtFinservice', info)
                            end});
                    
                            RageUI.Button("Crime en cours", nil, {RightLabel = "→"}, true, {onSelected = function()
                                    local info = 'crime'
                                    TriggerServerEvent('SpockeeLSPD:PriseEtFinservice', info)
                            end});
                        end)
    
                        --[[RageUI.IsVisible(PlaqueMenu,function()
                            RageUI.Button("Menu en developpement", nil, {RightLabel = X}, true, {onSelected = function()
                            end});
                            ESX.TriggerServerCallback('SpockeeLSPD:getVehicleInfos', function(retrivedInfo) 
                                local hashvoiture = retrivedInfo.vehicle.model
                                local nomvoituremodele = GetDisplayNameFromVehicleModel(hashvoiture)
                                local nomvoituretexte  = GetLabelText(nomvoituremodele)
                                RageUI.Button("Numéro de plaque : ", nil, {RightLabel = retrivedInfo.plate}, true, {onSelected = function()
                                end});
    
                                if not retrivedInfo.owner then
                                    RageUI.Button("Propriétaire : ", nil, {RightLabel = "Inconnu"}, true, {onSelected = function()
                                    end});
                                else
                                    RageUI.Button("Propriétaire : ", nil, {RightLabel = retrivedInfo.owner}, true, {onSelected = function()
                                    end});
                                    RageUI.Button("Modèle du véhicule : ", nil, {RightLabel = nomvoituretexte}, true, {onSelected = function()
                                    end});
                                end
                            end)
                        end)]]

                        RageUI.IsVisible(InteractionMenu,function()
                            local searchPlayerPed = GetPlayerPed(target)

                            RageUI.Button("Menotter/démenotter",nil, {RightLabel = "→"}, true, {onSelected = function()
                                local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
				                if closestPlayer ~= -1 and closestDistance <= 3.0 then 
                                    TriggerServerEvent('SpockeeLSPD:handcuff', GetPlayerServerId(closestPlayer))
                                else
                                    exports['okokNotify']:Alert(ServiceName, "Aucun joueurs à proximité", 1000, 'error')
                                end
                            end});

                            RageUI.Button("Escorter",nil, {RightLabel = "→"}, true, {onSelected = function()
                                local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
				                if closestPlayer ~= -1 and closestDistance <= 3.0 then 
                                    TriggerServerEvent('SpockeeLSPD:drag', GetPlayerServerId(closestPlayer))
                                else
                                    exports['okokNotify']:Alert(ServiceName, "Aucun joueurs à proximité", 1000, 'error')
                                end
                            end});

                            RageUI.Button("Mettre dans un véhicule",nil, {RightLabel = "→"}, true, {onSelected = function()
                                local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
				                if closestPlayer ~= -1 and closestDistance <= 3.0 then  
                                    TriggerServerEvent('SpockeeLSPD:putInVehicle', GetPlayerServerId(closestPlayer))
                                else
                                    exports['okokNotify']:Alert(ServiceName, "Aucun joueurs à proximité", 1000, 'error')
                                end
                            end});

                            RageUI.Button("Sortir du véhicule",nil, {RightLabel = "→"}, true, {onSelected = function()
                                local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
				                if closestPlayer ~= -1 and closestDistance <= 3.0 then  
                                    TriggerServerEvent('SpockeeLSPD:invSearch', GetPlayerServerId(closestPlayer))
                                else
                                    exports['okokNotify']:Alert(ServiceName, "Aucun joueurs à proximité", 1000, 'error')
                                end
                            end});

                            RageUI.Button("Fouille",nil, {RightLabel = "→"}, true, {onSelected = function()
                                local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
				                if closestPlayer ~= -1 and closestDistance <= 3.0 then  
                                    TriggerServerEvent('SpockeeLSPD:OutVehicle', GetPlayerServerId(closestPlayer))
                                    exports.ox_inventory:openNearbyInventory()
                                else
                                    exports['okokNotify']:Alert(ServiceName, "Aucun joueurs à proximité", 1000, 'error')
                                end
                            end});

                            RageUI.Button("Gestion des licences", "Documents officiels", {RightLabel = "→"}, true, {onSelected = function()
                            end},LicencesMenu);

                        end)

                        RageUI.IsVisible(LicencesMenu,function()
                            local searchPlayerPed = GetPlayerPed(target)

                            RageUI.Separator("↓  Carte d'identité  ↓")

                            RageUI.Button("Déclaration de perte",nil, {RightLabel = "→"}, true, {onSelected = function()
                                local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
				                if closestPlayer ~= -1 and closestDistance <= 3.0 then    
                                    TriggerServerEvent('SpockeeLSPD:idCardReset', GetPlayerServerId(closestPlayer))
                                else
                                    exports['okokNotify']:Alert(ServiceName, "Aucun joueurs à proximité", 1000, 'error')
                                end
                            end});

                            RageUI.Separator("↓  Permis de port d'armes  ↓")

                            RageUI.Button("Donner PPA",nil, {RightLabel = "→"}, true, {onSelected = function()
                                local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
				                if closestPlayer ~= -1 and closestDistance <= 3.0 then    
                                    TriggerServerEvent('SpockeeLSPD:GiveGunL', GetPlayerServerId(closestPlayer))
                                else
                                    exports['okokNotify']:Alert(ServiceName, "Aucun joueurs à proximité", 1000, 'error')
                                end
                            end});

                            RageUI.Button("Retirer PPA",nil, {RightLabel = "→"}, true, {onSelected = function()
                                local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
				                if closestPlayer ~= -1 and closestDistance <= 3.0 then    
                                    TriggerServerEvent('SpockeeLSPD:RemoveGunL', GetPlayerServerId(closestPlayer))
                                else
                                    exports['okokNotify']:Alert(ServiceName, "Aucun joueurs à proximité", 1000, 'error')
                                end
                            end});

                            RageUI.Separator("↓  Permis de conduire  ↓")

                            RageUI.Button("Retirer PDC",nil, {RightLabel = "→"}, true, {onSelected = function()
                                local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
				                if closestPlayer ~= -1 and closestDistance <= 3.0 then  
                                    TriggerServerEvent('SpockeeLSPD:RemoveLicence', GetPlayerServerId(closestPlayer))
                                else
                                    exports['okokNotify']:Alert(ServiceName, "Aucun joueurs à proximité", 1000, 'error')
                                end
                            end});

                        end)
    
                    Wait(0)
                    end
                end) 
            end
        end
    end)

    
end

Keys.Register('F6', 'police', 'Ouvrir le menu LSPD', function()
	if ESX.PlayerData.job and ESX.PlayerData.job.name == 'police' then
        ServiceName = "LSPD"
    	ActionsMenuLSPD()
	end
    if ESX.PlayerData.job and ESX.PlayerData.job.name == 'bcso' then
        ServiceName = "LSSD"
    	ActionsMenuLSPD()
	end
end)

RegisterNetEvent('SpockeeLSPD:setBlipee')
AddEventHandler('SpockeeLSPD:setBlipee', function(coords, raison, service)
    local ServiceName2 = service
	if raison == 'petit' then
		PlaySoundFrontend(-1, "Start_Squelch", "CB_RADIO_SFX", 1)
		PlaySoundFrontend(-1, "OOB_Start", "GTAO_FM_Events_Soundset", 1)
        exports['okokNotify']:Alert(ServiceName2, "Renforts demandés -- CODE 2 (Importance: Légère)", 1000, 'info')
        Wait(100)
		PlaySoundFrontend(-1, "End_Squelch", "CB_RADIO_SFX", 1)
		color = 2
	elseif raison == 'importante' then
		PlaySoundFrontend(-1, "Start_Squelch", "CB_RADIO_SFX", 1)
		PlaySoundFrontend(-1, "OOB_Start", "GTAO_FM_Events_Soundset", 1)
        exports['okokNotify']:Alert(ServiceName2, "Renforts demandés -- CODE 3 (Importance: Importante)", 1000, 'phonemessage')
        Wait(100)
		PlaySoundFrontend(-1, "End_Squelch", "CB_RADIO_SFX", 1)
		color = 47
	elseif raison == 'omgad' then
		PlaySoundFrontend(-1, "Start_Squelch", "CB_RADIO_SFX", 1)
		PlaySoundFrontend(-1, "OOB_Start", "GTAO_FM_Events_Soundset", 1)
		PlaySoundFrontend(-1, "FocusIn", "HintCamSounds", 1)
        exports['okokNotify']:Alert(ServiceName2, "Renforts demandés -- CODE 99 (Importance: !! URGENTE !!)", 2000, 'error')
        Wait(100)
		PlaySoundFrontend(-1, "End_Squelch", "CB_RADIO_SFX", 1)
		PlaySoundFrontend(-1, "FocusOut", "HintCamSounds", 1)
		color = 1
	end
	local blipId = AddBlipForCoord(coords)
	SetBlipSprite(blipId, 161)
	SetBlipScale(blipId, 0.8)
	SetBlipColour(blipId, 9)
	BeginTextCommandSetBlipName("STRING")
	AddTextComponentString('Demande renfort')
	EndTextCommandSetBlipName(blipId)
	Wait(80 * 1000)
	RemoveBlip(blipId)
end)

RegisterNetEvent('SpockeeLSPD:InfoService')
AddEventHandler('SpockeeLSPD:InfoService', function(service, nom)
	if service == 'prise' then
		PlaySoundFrontend(-1, "Start_Squelch", "CB_RADIO_SFX", 1)
        exports['okokNotify']:Alert(ServiceName, "Agent: "..nom.." Code: 10-8, Prise de service", 1000, 'success')
		PlaySoundFrontend(-1, "End_Squelch", "CB_RADIO_SFX", 1)
	elseif service == 'fin' then
		PlaySoundFrontend(-1, "Start_Squelch", "CB_RADIO_SFX", 1)
        exports['okokNotify']:Alert(ServiceName, "Agent: "..nom.." Code: 10-7, Fin de service", 1000, 'error')
		PlaySoundFrontend(-1, "End_Squelch", "CB_RADIO_SFX", 1)
	elseif service == 'pause' then
		PlaySoundFrontend(-1, "Start_Squelch", "CB_RADIO_SFX", 1)
        exports['okokNotify']:Alert(ServiceName, "Agent: "..nom.." 10-6, En Pause", 1000, 'warning')
		PlaySoundFrontend(-1, "End_Squelch", "CB_RADIO_SFX", 1)
	elseif service == 'standby' then
		PlaySoundFrontend(-1, "Start_Squelch", "CB_RADIO_SFX", 1)
        exports['okokNotify']:Alert(ServiceName, "Agent: "..nom.." 10-12, Standby, en attente de dispach", 1000, 'info')
		PlaySoundFrontend(-1, "End_Squelch", "CB_RADIO_SFX", 1)
	elseif service == 'control' then
		PlaySoundFrontend(-1, "Start_Squelch", "CB_RADIO_SFX", 1)
        exports['okokNotify']:Alert(ServiceName, "Agent: "..nom.." 10-48, Contrôle en cours", 1000, 'info')
		PlaySoundFrontend(-1, "End_Squelch", "CB_RADIO_SFX", 1)
	elseif service == 'refus' then
		PlaySoundFrontend(-1, "Start_Squelch", "CB_RADIO_SFX", 1)
        exports['okokNotify']:Alert(ServiceName, "Agent: "..nom.." 10-39, Refus d'obtempérer !", 1000, 'phonemessage')
		PlaySoundFrontend(-1, "End_Squelch", "CB_RADIO_SFX", 1)
	elseif service == 'crime' then
		PlaySoundFrontend(-1, "Start_Squelch", "CB_RADIO_SFX", 1)
        exports['okokNotify']:Alert(ServiceName, "Agent: "..nom.." 10-31, Activité suspecte en cours sur ma position !", 1000, 'phonemessage')
		PlaySoundFrontend(-1, "End_Squelch", "CB_RADIO_SFX", 1)
	end
end)

-- Radar
local maxSpeed = 0
-- local minSpeed = 0
local info = ""
local isRadarPlaced = false -- bolean to get radar status
local Radar -- entity object
local RadarBlip -- blip
local RadarPos = {} -- pos
local RadarAng = 0 -- angle
local LastPlate = ""
local LastVehDesc = ""
local LastSpeed = 0
local LastInfo = ""
 
function GetPlayers2()
    local players = {}
    for i = 0, 256 do
        if NetworkIsPlayerActive(i) then
            table.insert(players, i)
        end
    end
    return players
end
 
function GetClosestDrivingPlayerFromPos(radius, pos)
    local players = GetPlayers2()
    local closestDistance = radius or -1
    local closestPlayer = -1
    local closestVeh = -1
    for _ ,value in ipairs(players) do
        local target = GetPlayerPed(value)
        if(target ~= ply) then
            local ped = GetPlayerPed(value)
            if GetVehiclePedIsUsing(ped) ~= 0 then
                local targetCoords = GetEntityCoords(ped, 0)
                local distance = GetDistanceBetweenCoords(targetCoords["x"], targetCoords["y"], targetCoords["z"], pos["x"], pos["y"], pos["z"], true)
                if(closestDistance == -1 or closestDistance > distance) then
                    closestVeh = GetVehiclePedIsUsing(ped)
                    closestPlayer = value
                    closestDistance = distance
                end
            end
        end
    end
    return closestPlayer, closestVeh, closestDistance
end
 
 
function radarSetSpeed(defaultText)
    DisplayOnscreenKeyboard(1, "FMMC_MPM_NA", "", defaultText or "", "", "", "", 5)
    while (UpdateOnscreenKeyboard() == 0) do
        DisableAllControlActions(0);
        Wait(0);
    end
    if (GetOnscreenKeyboardResult()) then
        local gettxt = tonumber(GetOnscreenKeyboardResult())
        if gettxt ~= nil then
            return gettxt
        else
            ClearPrints()
            SetTextEntry_2("STRING")
            AddTextComponentString("~r~Veuillez entrer un nombre correct !")
            DrawSubtitleTimed(3000, 1)
            return
        end
    end
    return
end
 
 
function drawTxt(x,y ,width,height,scale, text, r,g,b,a)
    SetTextFont(0)
    SetTextProportional(0)
    SetTextScale(scale, scale)
    SetTextColour(r, g, b, a)
    SetTextDropShadow(0, 0, 0, 0,255)
    SetTextEdge(1, 0, 0, 0, 255)
    SetTextDropShadow()
    SetTextOutline()
    SetTextEntry("STRING")
    AddTextComponentString(text)
    DrawText(x - width/2, y - height/2 + 0.005)
end
 
RegisterNetEvent('SpockeeLSPD:POLICE_radar')
AddEventHandler('SpockeeLSPD:POLICE_radar', function (data)

    POLICE_radar()
end)

function POLICE_radar()

    if isRadarPlaced then 
        
        if GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId() ), RadarPos.x, RadarPos.y, RadarPos.z, true) < 0.9 then 
       
            RequestAnimDict("anim@apt_trans@garage")
            while not HasAnimDictLoaded("anim@apt_trans@garage") do
               Wait(1)
            end
            TaskPlayAnim(PlayerPedId() , "anim@apt_trans@garage", "gar_open_1_left", 1.0, -1.0, 5000, 0, 1, true, true, true) 
       
            Citizen.Wait(2000) 
       
            SetEntityAsMissionEntity(Radar, false, false)
           
            DeleteObject(Radar)
            DeleteEntity(Radar)
            Radar = nil
            RadarPos = {}
            RadarAng = 0
            isRadarPlaced = false
           
            RemoveBlip(RadarBlip)
            RadarBlip = nil
            LastPlate = ""
            LastVehDesc = ""
            LastSpeed = 0
            LastInfo = ""
           
        else
           
            ClearPrints()
            SetTextEntry_2("STRING")
            AddTextComponentString("~r~Vous n'êtes pas à coté de votre Radar !")
            DrawSubtitleTimed(3000, 1)
           
            Citizen.Wait(1500) 
       
        end
   
    else 
        maxSpeed = radarSetSpeed("50")
       
        Citizen.Wait(200) 
        RadarPos = GetOffsetFromEntityInWorldCoords(PlayerPedId() , 0, 1.5, 0)
        RadarAng = GetEntityRotation(PlayerPedId() )
       
        if maxSpeed ~= nil then 
       
            RequestAnimDict("anim@apt_trans@garage")
            while not HasAnimDictLoaded("anim@apt_trans@garage") do
               Wait(1)
            end
            TaskPlayAnim(PlayerPedId() , "anim@apt_trans@garage", "gar_open_1_left", 1.0, -1.0, 5000, 0, 1, true, true, true) -- animation
           
            Citizen.Wait(1500)
           
            RequestModel("prop_cctv_pole_01a")
            while not HasModelLoaded("prop_cctv_pole_01a") do
               Wait(1)
            end
           
            Radar = CreateObject(GetHashKey('prop_cctv_pole_01a'), RadarPos.x, RadarPos.y, RadarPos.z - 7, true, true, true) 
            SetEntityRotation(Radar, RadarAng.x, RadarAng.y, RadarAng.z - 115)
            SetEntityAsMissionEntity(Radar, true, true)
           
            FreezeEntityPosition(Radar, true) 
 
            isRadarPlaced = true
           
            RadarBlip = AddBlipForCoord(RadarPos.x, RadarPos.y, RadarPos.z)
            SetBlipSprite(RadarBlip, 380) 
            SetBlipColour(RadarBlip, 1) 
            SetBlipAsShortRange(RadarBlip, true)
            BeginTextCommandSetBlipName("STRING")
            AddTextComponentString("Radar")
            EndTextCommandSetBlipName(RadarBlip)
       
        end
       
    end
end
 
Citizen.CreateThread(function()
    while true do
        Wait(0)
 
        if isRadarPlaced then
       
            if HasObjectBeenBroken(Radar) then 
               
                SetEntityAsMissionEntity(Radar, false, false)
                SetEntityVisible(Radar, false)
                DeleteObject(Radar) 
                DeleteEntity(Radar) 
               
                Radar = nil
                RadarPos = {}
                RadarAng = 0
                isRadarPlaced = false
               
                RemoveBlip(RadarBlip)
                RadarBlip = nil
               
                LastPlate = ""
                LastVehDesc = ""
                LastSpeed = 0
                LastInfo = ""
               
            end
           
            if GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId() ), RadarPos.x, RadarPos.y, RadarPos.z, true) > 300 then 
           
                SetEntityAsMissionEntity(Radar, false, false)
                SetEntityVisible(Radar, false)
                DeleteObject(Radar) 
                DeleteEntity(Radar) 
               
                Radar = nil
                RadarPos = {}
                RadarAng = 0
                isRadarPlaced = false
               
                RemoveBlip(RadarBlip)
                RadarBlip = nil
               
                LastPlate = ""
                LastVehDesc = ""
                LastSpeed = 0
                LastInfo = ""
               
                ClearPrints()
                SetTextEntry_2("STRING")
                AddTextComponentString("~r~Vous êtes parti trop loin de votre Radar !")
                DrawSubtitleTimed(3000, 1)
               
            end
           
        end
       
        if isRadarPlaced then
 
            local viewAngle = GetOffsetFromEntityInWorldCoords(Radar, -8.0, -4.4, 0.0) 
            local ply, veh, dist = GetClosestDrivingPlayerFromPos(30, viewAngle) 

            if veh ~= nil then
           
                local vehPlate = GetVehicleNumberPlateText(veh) or ""
                local vehSpeedKm = GetEntitySpeed(veh)*3.6
                local vehDesc = GetDisplayNameFromVehicleModel(GetEntityModel(veh))--.." "..GetVehicleColor(veh)
                if vehDesc == "CARNOTFOUND" then vehDesc = "" end
                       
                     
                if vehSpeedKm < maxSpeed then
                    info = string.format("   Vehicule ~r~%s ~w~Plaque ~r~%s ~w~Km/h ~g~%s", vehDesc, vehPlate, math.ceil(vehSpeedKm))
                else
                    info = string.format("   Vehicule ~r~%s ~w~Plaque ~r~%s ~w~Km/h ~r~%s", vehDesc, vehPlate, math.ceil(vehSpeedKm))
                    if LastPlate ~= vehPlate then
                        LastSpeed = vehSpeedKm
                        LastVehDesc = vehDesc
                        LastPlate = vehPlate
                    elseif LastSpeed < vehSpeedKm and LastPlate == vehPlate then
                            LastSpeed = vehSpeedKm
                    end
                    LastInfo = string.format("   Vehicule ~r~%s ~w~Plaque ~r~%s ~w~Km/h ~r~%s", LastVehDesc, LastPlate, math.ceil(LastSpeed))
                end
                   
                DrawRect(0.88, 0.97, 0.2, 0.03, 0, 0, 0, 220)
                drawTxt(0.88, 0.97, 0.2, 0.03, 0.24, info, 255, 255, 255, 255)
               
                DrawRect(0.88, 0.93, 0.2, 0.03, 0, 0, 0, 220)
                drawTxt(0.88, 0.93, 0.2, 0.03, 0.24, LastInfo, 255, 255, 255, 255)
               
            end
           
        end
           
    end  
end)