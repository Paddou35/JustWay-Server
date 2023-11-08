isOnDuty = false

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


RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	ESX.PlayerData.job = job
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

CreateThread(function()
    ESX.TriggerServerCallback('SpockeeLSPD:getDutyStatus', function(result)
        if result == 0 then
            isOnDuty = false
        else
            isOnDuty = true
        end
    end)
end)

---- Cloakroom // Vestiaire ----

local open = false 
local MenuVestLSPD = RageUI.CreateMenu('', 'Vestiaires')
local ChoiseMenu = RageUI.CreateSubMenu(MenuVestLSPD,"","Faire un choix :")
local PutMenu = RageUI.CreateSubMenu(MenuVestLSPD,"", "Contenue :")
local GetMenu = RageUI.CreateSubMenu(MenuVestLSPD,"", "Contenue :")
MenuVestLSPD.Display.Header = true 
MenuVestLSPD.Closed = function()
  open = false
end

function VestiairesLSPD()

    if isOnDuty == true then
        if open then 
            open = false
            RageUI.Visible(MenuVestLSPD, false)
            return
        else
            open = true 
            RageUI.Visible(MenuVestLSPD, true)
            CreateThread(function()
                while open do 
                    RageUI.IsVisible(MenuVestLSPD,function()

                        RageUI.Separator("↓ ~b~Tenue~w~ ↓")

                        RageUI.Button("Mettre sa tenue de travail", nil, {RightLabel = "→"}, true, {onSelected = function()
                        end},ChoiseMenu);

                        RageUI.Button("Retirer sa tenue de travail", nil, {RightLabel = "→"}, true, {onSelected = function()
                            ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, jobSkin)
                                TriggerEvent('skinchanger:loadSkin', skin)
                            end)
                        end});

                        RageUI.Separator("↓ ~o~Gilet pare-balles~w~ ↓")

                        RageUI.Button("Prendre un Gilet pare-balles", nil, {RightLabel = "→"}, true, {onSelected = function()
                            SetPedComponentVariation(PlayerPedId()  , 9, 16, 2)   --bulletwear
                            SetPedArmour(PlayerPedId() , 100)
                            exports['okokNotify']:Alert("LSPD", "Vous avez équipé votre Gilet Par Balle", 1000, 'Success')
                        end});

                        RageUI.Button("Retirer son Gilet pare-balles", nil, {RightLabel = "→"}, true, {onSelected = function()
                            SetPedComponentVariation(PlayerPedId()  , 9, 0, 0)   --bulletwear
                            SetPedArmour(PlayerPedId() , 0)
                        end});

                        RageUI.Separator("↓ ~o~Coffre~w~ ↓")

                        RageUI.Button("Prendre un objet", nil, {RightLabel = "→"}, true, {onSelected = function()
                            getStock()
                        end},GetMenu);
            
                        RageUI.Button("Déposer un objet", nil, {RightLabel = "→"}, true, {onSelected = function()
                            getInventory()
                        end},PutMenu);              
                    end)

                    RageUI.IsVisible(ChoiseMenu, function()

                        RageUI.Button("Patrouille standard", nil, {RightLabel = "→"}, true, {onSelected = function()
                            local model = GetEntityModel(GetPlayerPed(-1))
                            print(model)

                            local AffichGrade1 = 0
                            local AffichGrade2 = 0

                            if ESX.GetPlayerData().job and ESX.GetPlayerData().job.name == 'police' and ESX.GetPlayerData().job.grade_name == 'officer3' then
                                AffichGrade1 = 8
                                AffichGrade2 = 0
                            end
                            if ESX.GetPlayerData().job and ESX.GetPlayerData().job.name == 'police' and ESX.GetPlayerData().job.grade_name == 'officer4' then
                                AffichGrade1 = 8
                                AffichGrade2 = 1
                            end
                            if ESX.GetPlayerData().job and ESX.GetPlayerData().job.name == 'police' and ESX.GetPlayerData().job.grade_name == 'sergaent1' then
                                AffichGrade1 = 8
                                AffichGrade2 = 1
                            end
                            if ESX.GetPlayerData().job and ESX.GetPlayerData().job.name == 'police' and ESX.GetPlayerData().job.grade_name == 'sergaent2' then
                                AffichGrade1 = 11
                                AffichGrade2 = 2
                            end
                            if ESX.GetPlayerData().job and ESX.GetPlayerData().job.name == 'police' and ESX.GetPlayerData().job.grade_name == 'lieutenant1' then
                                AffichGrade1 = 0
                                AffichGrade2 = 0
                            end
                            if ESX.GetPlayerData().job and ESX.GetPlayerData().job.name == 'police' and ESX.GetPlayerData().job.grade_name == 'lieutenant2' then
                                AffichGrade1 = 0
                                AffichGrade2 = 0
                            end
                            if ESX.GetPlayerData().job and ESX.GetPlayerData().job.name == 'police' and ESX.GetPlayerData().job.grade_name == 'captain' then
                                AffichGrade1 = 0
                                AffichGrade2 = 0
                            end
                            if ESX.GetPlayerData().job and ESX.GetPlayerData().job.name == 'police' and ESX.GetPlayerData().job.grade_name == 'commander' then
                                AffichGrade1 = 0
                                AffichGrade2 = 0
                            end
                            if ESX.GetPlayerData().job and ESX.GetPlayerData().job.name == 'police' and ESX.GetPlayerData().job.grade_name == 'boss' then
                                AffichGrade1 = 0
                                AffichGrade2 = 0
                            end

                            if ESX.GetPlayerData().job and ESX.GetPlayerData().job.name == 'police' and ESX.GetPlayerData().job.grade_name == 'cadet' then
                                TriggerEvent('skinchanger:getSkin', function(skin)
                                    if model == GetHashKey("mp_m_freemode_01") then
                                        clothesSkin = {
                                        ['tshirt_1'] = 153,  ['tshirt_2'] = 0,
                                        ['torso_1'] = 2,   ['torso_2'] = 11,
                                        ['decals_1'] = AffichGrade1,   ['decals_2'] = AffichGrade2,
                                        ['arms'] = 0,
                                        ['pants_1'] = 35,   ['pants_2'] = 0,
                                        ['shoes_1'] = 25,   ['shoes_2'] = 0,
                                        ['chain_1'] = 6,    ['chain_2'] = 0,
                                        ['helmet_1'] = -1,   ['helmet_2'] = 0,
                                        ['bags_1'] = 0,     ['bags_2'] = 0
                                        }
                                    else
                                        clothesSkin = {
                                        ['tshirt_1'] = 58,  ['tshirt_2'] = 0,
                                        ['torso_1'] = 250,   ['torso_2'] = 0,
                                        ['decals_1'] = AffichGrade1,   ['decals_2'] = AffichGrade2,
                                        ['arms'] = 85,
                                        ['pants_1'] = 96,   ['pants_2'] = 0,
                                        ['shoes_1'] = 54,   ['shoes_2'] = 0,
                                        ['chain_1'] = 126,    ['chain_2'] = 0,
                                        ['helmet_1'] = -1,   ['helmet_2'] = 0,
                                        ['bags_1'] = 0,     ['bags_2'] = 1
                                        }
                                    end
                                    TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)
                                end)
                            else
                                TriggerEvent('skinchanger:getSkin', function(skin)
                                    if model == GetHashKey("mp_m_freemode_01") then
                                        clothesSkin = {
                                        ['tshirt_1'] = 44,  ['tshirt_2'] = 0,
                                        ['torso_1'] = 55,   ['torso_2'] = 0,
                                        ['decals_1'] = AffichGrade1,   ['decals_2'] = AffichGrade2,
                                        ['arms'] = 0,
                                        ['pants_1'] = 35,   ['pants_2'] = 0,
                                        ['shoes_1'] = 51,   ['shoes_2'] = 0,
                                        ['chain_1'] = 5,    ['chain_2'] = 0,
                                        ['helmet_1'] = -1,   ['helmet_2'] = 0,
                                        ['bags_1'] = 0,     ['bags_2'] = 0
                                        }
                                    else
                                        clothesSkin = {
                                        ['tshirt_1'] = 52,  ['tshirt_2'] = 0,
                                        ['torso_1'] = 48,   ['torso_2'] = 0,
                                        ['decals_1'] = 7,   ['decals_2'] = AffichGrade2,
                                        ['arms'] = 14,
                                        ['pants_1'] = 34,   ['pants_2'] = 0,
                                        ['shoes_1'] = 52,   ['shoes_2'] = 0,
                                        ['chain_1'] = 5,    ['chain_2'] = 0,
                                        ['helmet_1'] = -1,   ['helmet_2'] = 0,
                                        ['bags_1'] = 0,     ['bags_2'] = 0
                                        }
                                    end
                                    TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)
                                end)
                            end
                        end});

                        if ESX.GetPlayerData().job and ESX.GetPlayerData().job.name == 'police' and ESX.GetPlayerData().job.grade_name ~= 'cadet'then

                            RageUI.Button("Patrouille légère", nil, {RightLabel = "→"}, true, {onSelected = function()
                                TriggerEvent('skinchanger:getSkin', function(skin)
                                    if model == GetHashKey("mp_m_freemode_01") then
                                        clothesSkin = {
                                        ['tshirt_1'] = 44,  ['tshirt_2'] = 0,
                                        ['torso_1'] = 55,   ['torso_2'] = 0,
                                        ['decals_1'] = AffichGrade1,   ['decals_2'] = AffichGrade2,
                                        ['arms'] = 0,
                                        ['pants_1'] = 35,   ['pants_2'] = 0,
                                        ['shoes_1'] = 51,   ['shoes_2'] = 0,
                                        ['chain_1'] = 5,    ['chain_2'] = 0,
                                        ['helmet_1'] = -1,   ['helmet_2'] = 0,
                                        ['bags_1'] = 0,     ['bags_2'] = 0
                                        }
                                    else
                                        clothesSkin = {
                                        ['tshirt_1'] = 52,  ['tshirt_2'] = 0,
                                        ['torso_1'] = 48,   ['torso_2'] = 0,
                                        ['decals_1'] = 7,   ['decals_2'] = AffichGrade2,
                                        ['arms'] = 14,
                                        ['pants_1'] = 34,   ['pants_2'] = 0,
                                        ['shoes_1'] = 52,   ['shoes_2'] = 0,
                                        ['chain_1'] = 5,    ['chain_2'] = 0,
                                        ['helmet_1'] = -1,   ['helmet_2'] = 0,
                                        ['bags_1'] = 0,     ['bags_2'] = 0
                                        }
                                    end
                                    TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)
                                end)
                            end});

                            RageUI.Button("Tenue de cérémonie", nil, {RightLabel = "→"}, true, {onSelected = function()
                                TriggerEvent('skinchanger:getSkin', function(skin)
                                    if model == GetHashKey("mp_m_freemode_01") then
                                        clothesSkin = {
                                        ['tshirt_1'] = 44,  ['tshirt_2'] = 0,
                                        ['torso_1'] = 55,   ['torso_2'] = 0,
                                        ['decals_1'] = AffichGrade1,   ['decals_2'] = AffichGrade2,
                                        ['arms'] = 0,
                                        ['pants_1'] = 35,   ['pants_2'] = 0,
                                        ['shoes_1'] = 51,   ['shoes_2'] = 0,
                                        ['chain_1'] = 5,    ['chain_2'] = 0,
                                        ['helmet_1'] = -1,   ['helmet_2'] = 0,
                                        ['bags_1'] = 0,     ['bags_2'] = 0
                                        }
                                    else
                                        clothesSkin = {
                                        ['tshirt_1'] = 52,  ['tshirt_2'] = 0,
                                        ['torso_1'] = 48,   ['torso_2'] = 0,
                                        ['decals_1'] = 7,   ['decals_2'] = AffichGrade2,
                                        ['arms'] = 14,
                                        ['pants_1'] = 34,   ['pants_2'] = 0,
                                        ['shoes_1'] = 52,   ['shoes_2'] = 0,
                                        ['chain_1'] = 5,    ['chain_2'] = 0,
                                        ['helmet_1'] = -1,   ['helmet_2'] = 0,
                                        ['bags_1'] = 0,     ['bags_2'] = 0
                                        }
                                    end
                                    TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)
                                end)
                            end});

                            RageUI.Button("Instructeur", nil, {RightLabel = "→"}, true, {onSelected = function()
                                TriggerEvent('skinchanger:getSkin', function(skin)
                                    if model == GetHashKey("mp_m_freemode_01") then
                                        clothesSkin = {
                                        ['tshirt_1'] = 44,  ['tshirt_2'] = 0,
                                        ['torso_1'] = 55,   ['torso_2'] = 0,
                                        ['decals_1'] = AffichGrade1,   ['decals_2'] = AffichGrade2,
                                        ['arms'] = 0,
                                        ['pants_1'] = 35,   ['pants_2'] = 0,
                                        ['shoes_1'] = 51,   ['shoes_2'] = 0,
                                        ['chain_1'] = 5,    ['chain_2'] = 0,
                                        ['helmet_1'] = -1,   ['helmet_2'] = 0,
                                        ['bags_1'] = 0,     ['bags_2'] = 0
                                        }
                                    else
                                        clothesSkin = {
                                        ['tshirt_1'] = 52,  ['tshirt_2'] = 0,
                                        ['torso_1'] = 48,   ['torso_2'] = 0,
                                        ['decals_1'] = 7,   ['decals_2'] = AffichGrade2,
                                        ['arms'] = 14,
                                        ['pants_1'] = 34,   ['pants_2'] = 0,
                                        ['shoes_1'] = 52,   ['shoes_2'] = 0,
                                        ['chain_1'] = 5,    ['chain_2'] = 0,
                                        ['helmet_1'] = -1,   ['helmet_2'] = 0,
                                        ['bags_1'] = 0,     ['bags_2'] = 0
                                        }
                                    end
                                    TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)
                                end)
                            end});

                            RageUI.Button("Tenue de Maries", nil, {RightLabel = "→"}, true, {onSelected = function()
                                TriggerEvent('skinchanger:getSkin', function(skin)
                                    if model == GetHashKey("mp_m_freemode_01") then
                                        clothesSkin = {
                                        ['tshirt_1'] = 44,  ['tshirt_2'] = 0,
                                        ['torso_1'] = 55,   ['torso_2'] = 0,
                                        ['decals_1'] = AffichGrade1,   ['decals_2'] = AffichGrade2,
                                        ['arms'] = 0,
                                        ['pants_1'] = 35,   ['pants_2'] = 0,
                                        ['shoes_1'] = 51,   ['shoes_2'] = 0,
                                        ['chain_1'] = 5,    ['chain_2'] = 0,
                                        ['helmet_1'] = -1,   ['helmet_2'] = 0,
                                        ['bags_1'] = 0,     ['bags_2'] = 0
                                        }
                                    else
                                        clothesSkin = {
                                        ['tshirt_1'] = 52,  ['tshirt_2'] = 0,
                                        ['torso_1'] = 48,   ['torso_2'] = 0,
                                        ['decals_1'] = 7,   ['decals_2'] = AffichGrade2,
                                        ['arms'] = 14,
                                        ['pants_1'] = 34,   ['pants_2'] = 0,
                                        ['shoes_1'] = 52,   ['shoes_2'] = 0,
                                        ['chain_1'] = 5,    ['chain_2'] = 0,
                                        ['helmet_1'] = -1,   ['helmet_2'] = 0,
                                        ['bags_1'] = 0,     ['bags_2'] = 0
                                        }
                                    end
                                    TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)
                                end)
                            end});

                        end
                    end)

                    RageUI.IsVisible(GetMenu, function()
                    
                        for k,v in pairs(all_items) do
                            RageUI.Button(v.label, nil, {RightLabel = "x"..v.nb}, true, {onSelected = function()
                                local count = KeyboardInput("Combien voulez vous en déposer",nil,4)
                                count = tonumber(count)
                                if count <= v.nb then
                                    TriggerServerEvent("SpockeeLSPD:takeStockItems",v.item, count)
                                else
                                    exports['okokNotify']:Alert("LSPD", "Vous n'en avez pas assez sur vous", 1000, 'error')
                                end
                                getStock()
                            end});
                        end        
                    end)
            
                    RageUI.IsVisible(PutMenu, function()
                        
                        for k,v in pairs(all_items) do
                            RageUI.Button(v.label, nil, {RightLabel = "x"..v.nb}, true, {onSelected = function()
                                local count = KeyboardInput("Combien voulez vous en déposer",nil,4)
                                count = tonumber(count)
                                TriggerServerEvent("SpockeeLSPD:putStockItems",v.item, count)
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

		if ESX.GetPlayerData().job and ESX.GetPlayerData().job.name == 'police' then
            for k in pairs(Config.Vestiaires) do
                local plyCoords = GetEntityCoords(GetPlayerPed(-1), false)
                local pos = Config.Vestiaires
                local distance = Vdist(plyCoords.x, plyCoords.y, plyCoords.z, pos[k].x, pos[k].y, pos[k].z)
                local isInMarker, hasExited = false, false

                if distance <= Config.DrawDistance then
                    sleep = 0
                    DrawMarker(Config.Marker.type, pos[k].x, pos[k].y, pos[k].z, 0.0, 0.0, 0.0, 0.0,0.0,0.0, Config.Marker.x, Config.Marker.y, Config.Marker.z, Config.Marker.r, Config.Marker.g, Config.Marker.b, Config.Marker.a, false, false, 2, Config.Marker.rotate, nil, nil, false)  
                    if distance <= 3.2 then
                        Visual.FloatingHelpText("Appuyer sur ~INPUT_CONTEXT~ pour ouvrir les vestiaires ", 1)
                        if IsControlJustPressed(1,51) then
                            VestiairesLSPD()
                        end
                    end
                end
            end
		end
		Wait(sleep)
	end
end)

---- Cloakroom // Vestiaire - Helicopter ----

--[[local open = false 
local MenuHeliLSPD = RageUI.CreateMenu('', 'Vestiaires')
MenuHeliLSPD.Display.Header = true 
MenuHeliLSPD.Closed = function()
  open = false
end

function VestHelicoLSPD()

    if isOnDuty == true then
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

                        RageUI.Button("Mettre sa tenue de vol", nil, {RightLabel = "→"}, true, {onSelected = function()
                            TriggerEvent('skinchanger:getSkin', function(skin)
                                if model == GetHashKey("mp_m_freemode_01") then
                                    clothesSkin = {
                                    ['tshirt_1'] = 44,  ['tshirt_2'] = 0,
                                    ['torso_1'] = 55,   ['torso_2'] = 0,
                                    ['decals_1'] = 0,   ['decals_2'] = 0,
                                    ['arms'] = 0,
                                    ['pants_1'] = 35,   ['pants_2'] = 0,
                                    ['shoes_1'] = 51,   ['shoes_2'] = 0,
                                    ['chain_1'] = 5,    ['chain_2'] = 0,
                                    ['helmet_1'] = -1,   ['helmet_2'] = 0,
                                    ['bags_1'] = 0,     ['bags_2'] = 0
                                    }
                                else
                                    clothesSkin = {
                                    ['tshirt_1'] = 52,  ['tshirt_2'] = 0,
                                    ['torso_1'] = 48,   ['torso_2'] = 0,
                                    ['decals_1'] = 0,   ['decals_2'] = 0,
                                    ['arms'] = 14,
                                    ['pants_1'] = 34,   ['pants_2'] = 0,
                                    ['shoes_1'] = 52,   ['shoes_2'] = 0,
                                    ['chain_1'] = 5,    ['chain_2'] = 0,
                                    ['helmet_1'] = -1,   ['helmet_2'] = 0,
                                    ['bags_1'] = 0,     ['bags_2'] = 0
                                    }
                                end
                                TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)
                            end)
                        end});

                        RageUI.Button("Retirer sa tenue", nil, {RightLabel = "→"}, true, {onSelected = function()
                            ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, jobSkin)
                                TriggerEvent('skinchanger:loadSkin', skin)
                            end)
                        end});
                    end)
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

		if ESX.GetPlayerData().job and ESX.GetPlayerData().job.name == 'police' then
            for k in pairs(Config.VestHelico) do
                local plyCoords = GetEntityCoords(GetPlayerPed(-1), false)
                local pos = Config.VestHelico
                local distance = Vdist(plyCoords.x, plyCoords.y, plyCoords.z, pos[k].x, pos[k].y, pos[k].z)
                local isInMarker, hasExited = false, false

                if distance <= Config.DrawDistance then
                    sleep = 0
                    DrawMarker(Config.Marker.type, pos[k].x, pos[k].y, pos[k].z, 0.0, 0.0, 0.0, 0.0,0.0,0.0, Config.Marker.x, Config.Marker.y, Config.Marker.z, Config.Marker.r, Config.Marker.g, Config.Marker.b, Config.Marker.a, false, false, 2, Config.Marker.rotate, nil, nil, false)  
                    if distance <= 2 then
                        Visual.FloatingHelpText("Appuyer sur ~INPUT_CONTEXT~ pour ouvrir les vestiaires", 1)
                        if IsControlJustPressed(1,51) then
                            VestHelicoLSPD()
                        end
                    end
                end                
            end
		end
		Wait(sleep)
	end
end)]]