all_items = {}
isOnDuty = false
DutyName = "Prendre"

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

-- Peds

CreateThread(function()
    for k,v in pairs(Config.PEDList) do
        local hash = GetHashKey(v.pedHashKey)
        while not HasModelLoaded(hash) do
            RequestModel(hash)
            Wait(20)
        end
        ped = CreatePed('', v.pedHashKey, v.spawnpoint, false, true)
        SetBlockingOfNonTemporaryEvents(ped, true)
        SetEntityInvincible(ped, true)
        FreezeEntityPosition(ped, true)
    end
end)

CreateThread(function()
    ESX.TriggerServerCallback('SpockeeLSPD:getDutyStatus', function(result)
        if result == 0 then
            isOnDuty = false
            DutyName = "Prendre" --(A réactivé si okokTalkToNPC n'est pas utilisé)
        else
            isOnDuty = true
            DutyName = "Arrêter" --(A réactivé si okokTalkToNPC n'est pas utilisé)
        end
    end)
end)

-- Sonette

CreateThread(function()
	while true do
		local sleep = 1500

        for k in pairs(Config.Sonette) do
            local plyCoords = GetEntityCoords(GetPlayerPed(-1), false)
            local pos = Config.Sonette
            local distance = Vdist(plyCoords.x, plyCoords.y, plyCoords.z, pos[k].x, pos[k].y, pos[k].z)
            local isInMarker, hasExited = false, false

            if distance <= Config.DrawDistance then
                sleep = 0
                DrawMarker(Config.Marker.type, pos[k].x, pos[k].y, pos[k].z, 0.0, 0.0, 0.0, 0.0,0.0,0.0, Config.Marker.x, Config.Marker.y, Config.Marker.z, Config.Marker.r, Config.Marker.g, Config.Marker.b, Config.Marker.a, false, false, 2, Config.Marker.rotate, nil, nil, false)  
                if distance <= 1.4 then
                    Visual.FloatingHelpText("Appuyer sur ~INPUT_CONTEXT~ pour sonner", 1)
                    if IsControlJustPressed(1,51) then
                        ESX.TriggerServerCallback('SpockeeLSPD:NbOfOfficer', function(result)
                            if result == 0 then
                                exports['okokNotify']:Alert("LSPD", "Aucun officier n'est disponible, repassez plus tard.", 2000, 'warning')
                            else
                                TriggerServerEvent('SpockeeLSPD:SonetteAccueilServ')
                            end
                        end)
                    end
                end
            end
        end
		Wait(sleep)
	end
end)

RegisterNetEvent('SpockeeLSPD:SonetteAccueil1')
AddEventHandler('SpockeeLSPD:SonetteAccueil1', function()
    ESX.TriggerServerCallback('SpockeeLSPD:NbOfOfficer', function(result)
        if result == 0 then
            exports['okokNotify']:Alert("LSPD", "Aucun officier n'est disponible, repassez plus tard.", 4000, 'warning')
        else
            TriggerServerEvent('SpockeeLSPD:SonetteAccueilServ')
        end
    end)
end)

RegisterNetEvent('SpockeeLSPD:SonetteBCSO')
AddEventHandler('SpockeeLSPD:SonetteBCSO', function()
    ESX.TriggerServerCallback('SpockeeLSPD:NbOfSheriff', function(result)
        if result == 0 then
            exports['okokNotify']:Alert("LSSD", "Aucun officier n'est disponible, repassez plus tard.", 4000, 'warning')
        else
            TriggerServerEvent('SpockeeLSPD:SonetteBCSOServ')
        end
    end)
end)

RegisterNetEvent('SpockeeLSPD:SonetteAccueil2')
AddEventHandler('SpockeeLSPD:SonetteAccueil2', function(GuestRang, ServiceName)
    PlaySoundFrontend(-1, "Start_Squelch", "CB_RADIO_SFX", 1)
    PlaySoundFrontend(-1, "OOB_Start", "GTAO_FM_Events_Soundset", 1)
    exports['okokNotify']:Alert(ServiceName, "Mme/M. "..GuestRang.." Attend un Officier à l'accueil.", 4000, 'info')
    Wait(100)
    PlaySoundFrontend(-1, "End_Squelch", "CB_RADIO_SFX", 1)
end)

-- Prise de service (désactivés, utilisation de okokTalkToNPC)

local open = false 
local MenuPointLSPD = RageUI.CreateMenu('', 'Vestiaires')
MenuPointLSPD.Display.Header = true 
MenuPointLSPD.Closed = function()
  open = false
end

function PointeuseLSPD()
    if open then 
        open = false
        RageUI.Visible(MenuPointLSPD, false)
        return
    else
        open = true 
        RageUI.Visible(MenuPointLSPD, true)
        CreateThread(function()
            while open do 
                RageUI.IsVisible(MenuPointLSPD,function()

                    RageUI.Button(""..DutyName.." son service", nil, {RightLabel = "→"}, true, {onSelected = function()
                        local clOnDuty = 0
                        local clJobGrade = {}
                        if DutyName == "Prendre" then
                            clOnDuty = 1
                            clJobGrade = 'police'
                            TriggerServerEvent('SpockeeLSPD:svDutyChange', clOnDuty, clJobGrade)
                            isOnDuty = true
                            DutyName = "Arrêter"
                        elseif DutyName == "Arrêter" then
                            clOnDuty = 0
                            clJobGrade = 'off_police'
                            TriggerServerEvent('SpockeeLSPD:svDutyChange', clOnDuty, clJobGrade)
                            isOnDuty = false
                            DutyName = "Prendre"
                        end
                    end})
                end)
            Wait(0)
            end
        end)
    end
end

CreateThread(function()
	while true do
		local sleep = 1500

		if ESX.PlayerData.job ~= nil and ESX.PlayerData.job.name == 'police' then
            for k in pairs(Config.Pointeuse) do
                local plyCoords = GetEntityCoords(GetPlayerPed(-1), false)
                local pos = Config.Pointeuse
                local distance = Vdist(plyCoords.x, plyCoords.y, plyCoords.z, pos[k].x, pos[k].y, pos[k].z)
                local isInMarker, hasExited = false, false

                if distance <= Config.DrawDistance then
                    sleep = 0
                    DrawMarker(Config.Marker.type, pos[k].x, pos[k].y, pos[k].z, 0.0, 0.0, 0.0, 0.0,0.0,0.0, Config.Marker.x, Config.Marker.y, Config.Marker.z, Config.Marker.r, Config.Marker.g, Config.Marker.b, Config.Marker.a, false, false, 2, Config.Marker.rotate, nil, nil, false)  
                    if distance <= 2.0 then
                        Visual.FloatingHelpText("Appuyer sur ~INPUT_CONTEXT~", 1)
                        if IsControlJustPressed(1,51) then
                            PointeuseLSPD()
                        end
                    end
                end                
            end
		end
		Wait(sleep)
	end
end)

RegisterNetEvent('SpockeeLSPD:PriseService') -- (utilisation de okokTalkToNPC)
AddEventHandler('SpockeeLSPD:PriseService', function(GuestRang)
    if ESX.PlayerData.job and ESX.PlayerData.job.name == 'police' then
        local clOnDuty = 0
        local clJobGrade = {}
        if isOnDuty == false then
            clOnDuty = 1
            clJobGrade = 'police'
            TriggerServerEvent('SpockeeLSPD:svDutyChange', clOnDuty, clJobGrade)
            exports['okokNotify']:Alert("Natasha", "Bon service collègue, à tout à l'heure.", 3000, 'info')
            isOnDuty = true
        elseif isOnDuty == true then
            clOnDuty = 0
            clJobGrade = 'off_police'
            TriggerServerEvent('SpockeeLSPD:svDutyChange', clOnDuty, clJobGrade)
            exports['okokNotify']:Alert("Natasha", "Bonne soirée et à bientôt officier !", 3000, 'info')
            isOnDuty = false
        end
    elseif ESX.PlayerData.job and ESX.PlayerData.job.name == 'bcso' then
        local clOnDuty = 0
        local clJobGrade = {}
        if isOnDuty == false then
            clOnDuty = 1
            clJobGrade = 'bcso'
            TriggerServerEvent('SpockeeLSPD:svDutyChange', clOnDuty, clJobGrade)
            exports['okokNotify']:Alert("Sergent McCaslin", "Bon service collègue, à tout à l'heure.", 3000, 'info')
            isOnDuty = true
        elseif isOnDuty == true then
            clOnDuty = 0
            clJobGrade = 'off_bcso'
            TriggerServerEvent('SpockeeLSPD:svDutyChange', clOnDuty, clJobGrade)
            exports['okokNotify']:Alert("Sergent McCaslin", "Bonne soirée et à bientôt officier !", 3000, 'info')
            isOnDuty = false
        end
    else
        exports['okokNotify']:Alert("LSPD/LSSD", "Vous ne faites pas partie de nos effectifs", 3000, 'warning')
    end
end)

-- Garage (Désactivé, utilisation okokGarage)

local open = false 
local MenuGarageLSPD = RageUI.CreateMenu('', 'Faites votre choix ?')
MenuGarageLSPD.Display.Header = true 
MenuGarageLSPD.Closed = function()
  open = false
end

Garage = {
    vehiclelist = {},
}

function GarageLSPD()
    if open then 
        open = false
        RageUI.Visible(MenuGarageLSPD, false)
        return
    else
        open = true 
        RageUI.Visible(MenuGarageLSPD, true)
        CreateThread(function()
            while open do 
                RageUI.IsVisible(MenuGarageLSPD,function() 
                    local nbcars = 0
                    for i = 1, #Garage.vehiclelist, 1 do
                        local hashvehicle = Garage.vehiclelist[i].vehicle.model
                        local modelevehiclespawn = Garage.vehiclelist[i].vehicle
                        local nomvehiclemodele = GetDisplayNameFromVehicleModel(hashvehicle)
                        local nomvehicletexte  = GetLabelText(nomvehiclemodele)
                        local plaque = Garage.vehiclelist[i].plate

                        nbcars = nbcars + 1        
            
                        RageUI.Button(nomvehicletexte.." | "..plaque, "Pour sortir votre véhicule", {RightLabel = "→"}, true, {
                            onSelected = function()
                                for k,v in pairs(Config.LSPDSpawnVeh) do
                                    if ESX.Game.IsSpawnPointClear(vector3(v.spawnzone.x, v.spawnzone.y, v.spawnzone.z), 10.0) then
                                        SpawnVehicle(modelevehiclespawn, plaque)
                                        RageUI.CloseAll()
                                        open = false
                                    else
                                        exports['okokNotify']:Alert("SAMS", "Place de parking bloquée", 1000, 'warning')
                                    end
                                end
                            end
                        })
                    end

                    if nbcars == 0 then
                        RageUI.Separator("! Tous tes véhicules sont sortis !")
                    end
                        
                    RageUI.Button("Fermer", nil, {Color = {BackgroundColor = {255, 0, 0, 50}}, RightLabel = "→"}, true , {
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

CreateThread(function()
	while true do
		local sleep = 1500

		if ESX.PlayerData.job and ESX.PlayerData.job.name == 'police' and isOnDuty == true then
            for k in pairs(Config.LSPDGarage) do
                local plyCoords = GetEntityCoords(GetPlayerPed(-1), false)
                local pos = Config.LSPDGarage
                local distance = Vdist(plyCoords.x, plyCoords.y, plyCoords.z, pos[k].x, pos[k].y, pos[k].z)
                local isInMarker, hasExited = false, false

                if distance <= Config.DrawDistance then
                    sleep = 0
                    DrawMarker(Config.Marker.type, pos[k].x, pos[k].y, pos[k].z, 0.0, 0.0, 0.0, 0.0,0.0,0.0, Config.Marker.x, Config.Marker.y, Config.Marker.z, 192, 221, 51, Config.Marker.a, false, false, 2, Config.Marker.rotate, nil, nil, false)  
                    if distance <= 2.0 and not IsPedSittingInAnyVehicle(PlayerPedId()) then
                        Visual.FloatingHelpText("Appuyer sur ~INPUT_CONTEXT~ pour ouvrir le garage", 1)
                        if IsControlJustPressed(1,51) then
                            ESX.TriggerServerCallback('SpockeeLSPD:vehiclelist', function(ownedCars)
                                Garage.vehiclelist = ownedCars
                            end)
                            GarageLSPD()
                        end
                    end
                end                
            end
		end
		Wait(sleep)
	end
end)

-- Ranger Véhicule

CreateThread(function()
	while true do
		local sleep = 1500

		if ESX.PlayerData.job and ESX.PlayerData.job.name == 'police' then
            for k in pairs(Config.LSPDRetourVeh) do
                local plyCoords = GetEntityCoords(GetPlayerPed(-1), false)
                local pos = Config.LSPDRetourVeh
                local distance = Vdist(plyCoords.x, plyCoords.y, plyCoords.z, pos[k].x, pos[k].y, pos[k].z)
                local isInMarker, hasExited = false, false

                if distance <= 20.0 then
                    sleep = 0
                    if IsPedSittingInAnyVehicle(PlayerPedId()) then
                        DrawMarker(27, pos[k].x, pos[k].y, pos[k].z, 0.0, 0.0, 0.0, 0.0,0.0,0.0, Config.Marker.x, Config.Marker.y, Config.Marker.z, 255, 0, 0, Config.Marker.a, false, false, 2, false, nil, nil, false)
                        if distance <= 10.0 then
                            Visual.FloatingHelpText("Appuyer sur ~INPUT_CONTEXT~ pour ranger le véhicule", 1)
                            if IsControlJustPressed(1,51) then
                                ReturnVehicle()                              
                            end
                        end
                    end
                end                
            end
            for k in pairs(Config.LSPDHeliport) do
                local plyCoords = GetEntityCoords(GetPlayerPed(-1), false)
                local pos = Config.LSPDHeliport
                local distance = Vdist(plyCoords.x, plyCoords.y, plyCoords.z, pos[k].x, pos[k].y, pos[k].z)
                local isInMarker, hasExited = false, false

                if distance <= 20.0 then
                    sleep = 0
                    if IsPedSittingInAnyVehicle(PlayerPedId()) then
                        if distance <= 10.0 then
                            Visual.FloatingHelpText("Appuyer sur ~INPUT_CONTEXT~ pour ranger le véhicule", 1)
                            if IsControlJustPressed(1,51) then                                
                                local veh,dist4 = ESX.Game.GetClosestVehicle(playerCoords)
                                if dist4 < 1 then
                                    DeleteEntity(veh)
                                    exports['okokNotify']:Alert("LSPD", "Véhicule rangé !", 1000, 'success')
                                end                               
                            end
                        end
                    end
                end                
            end
		end
		Wait(sleep)
	end
end)

-- Héliport (Désactivé, utilisation okokGarage)

--[[local open = false 
local MenuHeliLSPD = RageUI.CreateMenu('', 'Faites votre choix ?')
MenuHeliLSPD.Display.Header = true 
MenuHeliLSPD.Closed = function()
  open = false
end

function HelicoLSPD()
    if open then 
        open = false
        RageUI.Visible(MenuHeliLSPD, false)
        return
    else
        open = true 
        RageUI.Visible(MenuHeliLSPD, true)
        CreateThread(function()
            while open do 
                RageUI.IsVisible(MenuHeliLSPD,function()

                    RageUI.Button("Nom a ajouter", nil, {RightLabel = "→"}, true , {
                    onSelected = function()
                        
                    end})

                end)

            Wait(0)
            end
        end)
    end
end

CreateThread(function()
	while true do
		local sleep = 1500

		if ESX.PlayerData.job and ESX.PlayerData.job.name == 'police' and isOnDuty == true then
            for k in pairs(Config.LSPDHeliport) do
                local plyCoords = GetEntityCoords(GetPlayerPed(-1), false)
                local pos = Config.LSPDHeliport
                local distance = Vdist(plyCoords.x, plyCoords.y, plyCoords.z, pos[k].x, pos[k].y, pos[k].z)
                local isInMarker, hasExited = false, false

                if distance <= Config.DrawDistance then
                    sleep = 0
                    DrawMarker(Config.Marker.type, pos[k].x, pos[k].y, pos[k].z, 0.0, 0.0, 0.0, 0.0,0.0,0.0, Config.Marker.x, Config.Marker.y, Config.Marker.z, 192, 221, 51, Config.Marker.a, false, false, 2, Config.Marker.rotate, nil, nil, false)  
                    if distance <= 2.0 and not IsPedSittingInAnyVehicle(PlayerPedId()) then
                        Visual.FloatingHelpText("Appuyer sur ~INPUT_CONTEXT~ pour ouvrir le hangar ", 1)
                        if IsControlJustPressed(1,51) then
                            HelicoLSPD()
                        end
                    end
                end                
            end
		end
		Wait(sleep)
	end
end)]]

-- Armurie (Désactivé, utilisation okokTalkToNPC)

local open = false 
local MenuArmurLSPD = RageUI.CreateMenu('', 'Faites votre choix ?')
MenuArmurLSPD.Display.Header = true 
MenuArmurLSPD.Closed = function()
  open = false
end

function ArmurieLSPD()
    if ESX.PlayerData.job and ESX.PlayerData.job.name == 'police' and isOnDuty == true then
        if open then 
            open = false
            RageUI.Visible(MenuArmurLSPD, false)
            return
        else
            open = true 
            RageUI.Visible(MenuArmurLSPD, true)
            CreateThread(function()
                while open do 
                    RageUI.IsVisible(MenuArmurLSPD,function()

                        RageUI.Button("Prendre son matériel", "~o~Prendre sa Matraque, Lampe et son Taser !", {RightLabel = "→"}, true, {onSelected = function()
                            TriggerServerEvent('SpockeeLSPD:equipementbase')
                        end});

                        RageUI.Button("Rendre son matériel", "~o~Prendre sa Matraque, Lampe et son Taser !", {RightLabel = "→"}, true, {onSelected = function()
                            TriggerServerEvent('SpockeeLSPD:equipementbase')
                        end});

                        if ESX.PlayerData.job and ESX.PlayerData.job.name == 'police' and ESX.PlayerData.job.grade_name == 'boss' or ESX.PlayerData.job.grade_name == 'commander' or ESX.PlayerData.job.grade_name == 'captain' then

                            RageUI.Separator('~o~↓↓ Acheter des Armes ↓↓')

                            RageUI.Button("Prendre équipement de base", "~o~Prendre sa Matraque, Lampe et son Taser !", {RightLabel = "~g~$0 ~W~ →"}, true, {onSelected = function()
                                TriggerServerEvent('SpockeeLSPD:equipementbase')
                            end});

                            for k,v in pairs(Config.ArmurerieArmes) do
                                RageUI.Button(v.buttoname, nil, {RightLabel = "~g~$"..v.prix}, true , {onSelected = function()
                                    TriggerServerEvent('SpockeeLSPD:armurerie', v.arme, v.prix)
                                end});
                            end                        
                        end                    
                    end)

                Wait(0)
                end
            end)
        end
    else
        exports['okokNotify']:Alert("LSPD", "Merci de vous mettre en service officier", 1000, 'warning') 
    end
end

CreateThread(function()
	while true do
		local sleep = 1500

		if ESX.PlayerData.job and ESX.PlayerData.job.name == 'police' then
            for k in pairs(Config.Armurerie) do
                local plyCoords = GetEntityCoords(GetPlayerPed(-1), false)
                local pos = Config.Armurerie
                local distance = Vdist(plyCoords.x, plyCoords.y, plyCoords.z, pos[k].x, pos[k].y, pos[k].z)
                local isInMarker, hasExited = false, false

                if distance <= Config.DrawDistance then
                    sleep = 0
                    DrawMarker(Config.Marker.type, pos[k].x, pos[k].y, pos[k].z, 0.0, 0.0, 0.0, 0.0,0.0,0.0, Config.Marker.x, Config.Marker.y, Config.Marker.z, Config.Marker.r, Config.Marker.g, Config.Marker.b, Config.Marker.a, false, false, 2, Config.Marker.rotate, nil, nil, false)  
                    if distance <= 2.0 and not IsPedSittingInAnyVehicle(PlayerPedId()) then
                        Visual.FloatingHelpText("Appuyer sur ~INPUT_CONTEXT~ pour ouvrir l'armurie", 1)
                        if IsControlJustPressed(1,51) then
                            ArmurieLSPD()
                        end
                    end
                end                
            end
		end
		Wait(sleep)
	end
end)

-- Boss Menu (Géré avec core_multijob)

local open = false 
local MenuBossLSPD = RageUI.CreateMenu('', 'Faites votre choix ?')
MenuBossLSPD.Display.Header = true 
MenuBossLSPD.Closed = function()
  open = false
end

function BossLSPD()
    if ESX.PlayerData.job and ESX.PlayerData.job.name == 'police' and isOnDuty == true then
        if open then 
            open = false
            RageUI.Visible(MenuBossLSPD, false)
            return
        else
            open = true 
            RageUI.Visible(MenuBossLSPD, true)
            CreateThread(function()
                while open do 
                    RageUI.IsVisible(MenuBossLSPD,function()
                        RageUI.Button("Accédez au gestion entreprise" , nil, {RightLabel = "→"}, true , {onSelected = function()
                            gestionboss()
                            RageUI.CloseAll()                                
                        end})
                    end)
                Wait(0)
                end
            end)
        end
    else
        exports['okokNotify']:Alert("LSPD", "Merci de vous mettre en service.", 1000, 'warning') 
    end
end

CreateThread(function()
	while true do
		local sleep = 1500

		if ESX.PlayerData.job and ESX.PlayerData.job.name == 'police' and ESX.PlayerData.job.grade_name == 'boss' then
            for k in pairs(Config.BossMenu) do
                local plyCoords = GetEntityCoords(GetPlayerPed(-1), false)
                local pos = Config.BossMenu
                local distance = Vdist(plyCoords.x, plyCoords.y, plyCoords.z, pos[k].x, pos[k].y, pos[k].z)
                local isInMarker, hasExited = false, false

                if distance <= Config.DrawDistance then
                    sleep = 0
                    DrawMarker(Config.Marker.type, pos[k].x, pos[k].y, pos[k].z, 0.0, 0.0, 0.0, 0.0,0.0,0.0, Config.Marker.x, Config.Marker.y, Config.Marker.z, Config.Marker.r, Config.Marker.g, Config.Marker.b, Config.Marker.a, false, false, 2, Config.Marker.rotate, nil, nil, false)  
                    if distance <= 2.0 then
                        Visual.FloatingHelpText("Appuyer sur ~INPUT_CONTEXT~ pour ouvrir le bureau", 1)
                        if IsControlJustPressed(1,51) then
                            BossLSPD()
                        end
                    end
                end
            end
        elseif ESX.PlayerData.job and ESX.PlayerData.job.name == 'police' and ESX.PlayerData.job.grade_name == 'commander' then
            for k in pairs(Config.BossMenu) do
                local plyCoords = GetEntityCoords(GetPlayerPed(-1), false)
                local pos = Config.BossMenu
                local distance = Vdist(plyCoords.x, plyCoords.y, plyCoords.z, pos[k].x, pos[k].y, pos[k].z)
                local isInMarker, hasExited = false, false

                if distance <= Config.DrawDistance then
                    sleep = 0
                    DrawMarker(Config.Marker.type, pos[k].x, pos[k].y, pos[k].z, 0.0, 0.0, 0.0, 0.0,0.0,0.0, Config.Marker.x, Config.Marker.y, Config.Marker.z, Config.Marker.r, Config.Marker.g, Config.Marker.b, Config.Marker.a, false, false, 2, Config.Marker.rotate, nil, nil, false)  
                    if distance <= 2.0 then
                        Visual.FloatingHelpText("Appuyer sur ~INPUT_CONTEXT~ pour ouvrir le bureau", 1)
                        if IsControlJustPressed(1,51) then
                            BossLSPD()
                        end
                    end
                end
            end
        elseif ESX.PlayerData.job and ESX.PlayerData.job.name == 'police' and ESX.PlayerData.job.grade_name == 'captain' then
            for k in pairs(Config.BossMenu) do
                local plyCoords = GetEntityCoords(GetPlayerPed(-1), false)
                local pos = Config.BossMenu
                local distance = Vdist(plyCoords.x, plyCoords.y, plyCoords.z, pos[k].x, pos[k].y, pos[k].z)
                local isInMarker, hasExited = false, false

                if distance <= Config.DrawDistance then
                    sleep = 0
                    DrawMarker(Config.Marker.type, pos[k].x, pos[k].y, pos[k].z, 0.0, 0.0, 0.0, 0.0,0.0,0.0, Config.Marker.x, Config.Marker.y, Config.Marker.z, Config.Marker.r, Config.Marker.g, Config.Marker.b, Config.Marker.a, false, false, 2, Config.Marker.rotate, nil, nil, false)  
                    if distance <= 2.0 then
                        Visual.FloatingHelpText("Appuyer sur ~INPUT_CONTEXT~ pour ouvrir le bureau", 1)
                        if IsControlJustPressed(1,51) then
                            BossLSPD()
                        end
                    end
                end
            end
		end
		Wait(sleep)
	end
end)

function gestionboss()
    TriggerEvent('esx_society:openBossMenu', 'police', function(data, menu)
        menu.close()
    end, {wash = false})
end

-- Vestiaire des saisies (Géré avec OxInventory)

--[[local open = false 
local MenuSaisiesLSPD = RageUI.CreateMenu('', 'Faites votre choix ?')
MenuSaisiesLSPD.Display.Header = true 
MenuSaisiesLSPD.Closed = function()
  open = false
end

function SaisiesLSPD()
    if ESX.PlayerData.job and ESX.PlayerData.job.name == 'police' and isOnDuty == true then
        if open then 
            open = false
            RageUI.Visible(MenuSaisiesLSPD, false)
            return
        else
            open = true 
            RageUI.Visible(MenuSaisiesLSPD, true)
            CreateThread(function()
                while open do 
                    RageUI.IsVisible(MenuSaisiesLSPD,function()
                        RageUI.Button("Prendre un objet", nil, {RightLabel = "→"}, true, {onSelected = function()
                            getSaisiesStock()
                        end},GetMenu);
            
                        RageUI.Button("Déposer un objet", nil, {RightLabel = "→"}, true, {onSelected = function()
                            getInventory()
                        end},PutMenu);                    
                    end)
    
                    RageUI.IsVisible(GetMenu, function()
                    
                        for k,v in pairs(all_items) do
                            RageUI.Button(v.label, nil, {RightLabel = "x"..v.nb}, true, {onSelected = function()
                                local count = KeyboardInput("Combien voulez vous en déposer",nil,4)
                                count = tonumber(count)
                                if count <= v.nb then
                                    TriggerServerEvent("SpockeeLSPD:takeSaisiesItems",v.item, count)
                                else
                                    exports['okokNotify']:Alert("LSPD", "Vous n'en avez pas assez sur vous", 1000, 'error')
                                end
                                getSaisiesStock()
                            end});
                        end        
                    end)
            
                    RageUI.IsVisible(PutMenu, function()
                        
                        for k,v in pairs(all_items) do
                            RageUI.Button(v.label, nil, {RightLabel = "x"..v.nb}, true, {onSelected = function()
                                local count = KeyboardInput("Combien voulez vous en déposer",nil,4)
                                count = tonumber(count)
                                TriggerServerEvent("SpockeeLSPD:putSaisiesItems",v.item, count)
                                getInventory()
                            end});
                        end
                    end)
                Wait(0)
                end
            end)
        end
    else
        exports['okokNotify']:Alert("LSPD", "Merci de vous mettre en service officier", 1000, 'warning') 
    end
end

CreateThread(function()
	while true do
		local sleep = 1500

		if ESX.PlayerData.job and ESX.PlayerData.job.name == 'police' then
            for k in pairs(Config.Saisies) do
                local plyCoords = GetEntityCoords(GetPlayerPed(-1), false)
                local pos = Config.Saisies
                local distance = Vdist(plyCoords.x, plyCoords.y, plyCoords.z, pos[k].x, pos[k].y, pos[k].z)
                local isInMarker, hasExited = false, false

                if distance <= Config.DrawDistance then
                    sleep = 0
                    DrawMarker(Config.Marker.type, pos[k].x, pos[k].y, pos[k].z, 0.0, 0.0, 0.0, 0.0,0.0,0.0, Config.Marker.x, Config.Marker.y, Config.Marker.z, Config.Marker.r, Config.Marker.g, Config.Marker.b, Config.Marker.a, false, false, 2, Config.Marker.rotate, nil, nil, false)  
                    if distance <= 2.0 then
                        Visual.FloatingHelpText("Appuyer sur ~INPUT_CONTEXT~ pour déposer/prendre les saises", 1)
                        if IsControlJustPressed(1,51) then
                            SaisiesLSPD()
                        end
                    end
                end                
            end
		end
		Wait(sleep)
	end
end)

function getSaisiesStock()
    ESX.TriggerServerCallback('SpockeeLSPD:getSaisiesItems', function(inventory)                
        all_items = inventory        
    end)
end]]