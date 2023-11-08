RegisterCommand(Config.MenuCommand, function()
    lib.callback('checkgroup', false, function(staff, tipo)
        if staff then
            local options = {
                
                {
                    title = Lang.menu_report,
                    description = Lang.menu_report_desc,
                    icon = 'clipboard-list',
                    event = 'svg:reports:menu'
                },
                {
                    title = Lang.menu_staff,
                    description = Lang.menu_staff_desc,
                    icon = 'clipboard-user',
                    event = 'svg:staff:menu'
                },
                {
                    title = Lang.menu_refund,
                    description = Lang.menu_refund_desc,
                    icon = 'basket-shopping',
                    event = 'svg:refund:menu'
                },
                {
                    title = Lang.send_announce,
                    description = Lang.send_announce_desc,
                    icon = 'bullhorn',
                    event = 'svg:message:all'
                },
                {
                    title = Lang.send_private_msg,
                    description = Lang.send_private_msg_desc,
                    icon = 'mug-hot',
                    event = 'svg:call:ass'
                },
            }

            for _,v in pairs(Config.MaxGroups) do
                if tipo == v then
                    table.insert(options, {title = Lang.wipe_player, description = Lang.wipe_player_desc, icon = 'trash', event = 'svg:wipe:player'})
                end
            end
            
            lib.registerContext({
                id = 'adminmenu',
                title = Lang.menu_admin,
                options = options
            })
            lib.showContext('adminmenu')
        else
            Config.Notify(Lang.no_staff, 'error')
        end
    end)
end)

local announce = false
RegisterNetEvent('svg:message:all', function()
    lib.callback('checkgroup', false, function(staff, tipo)
        if staff then
            local input = lib.inputDialog(Lang.send_announce, {
                {type = 'input', description = Lang.write_announce, required = true},
            })
            if not input then return end
            if not input[1] then TriggerEvent('svg:message:all') Config.Notify(Lang.not_valid_msg, 'error') return end
            if Config.TxAdmin then
                TriggerEvent('txcl:showAnnouncement', input[1], tipo..' '..GetPlayerName(NetworkGetEntityOwner(cache.ped)))
            else
                TriggerServerEvent('svg:announce:server', input[1])
            end
            TriggerServerEvent('svg:webhook', ' Announce: **'..input[1]..'**', 'announce')
        end
    end)
end)

RegisterNetEvent('svg:announce:all', function(msg)
    lib.callback('checkgroup', false, function(staff, tipo)
        if staff then
            CreateThread(function()
                announce = true
                while announce do

                    local scaleform = RequestScaleformMovie('mp_big_message_freemode')
                    while not HasScaleformMovieLoaded(scaleform) do
                        Wait(0)
                    end
                    PushScaleformMovieFunction(scaleform, 'SHOW_SHARD_WASTED_MP_MESSAGE')
                    PushScaleformMovieFunctionParameterString(Lang.announce)
                    PushScaleformMovieFunctionParameterString(msg)
                    PopScaleformMovieFunctionVoid()
                    DrawScaleformMovieFullscreen(scaleform, 255, 255, 255, 255, 0)

                    Wait(0)
                end
                
            end)
            Wait(5000)
            announce = false
        end
    end)
end)

RegisterNetEvent('svg:call:ass', function() 
    lib.callback('checkgroup', false, function(staff, tipo)
        if staff then
            local input = lib.inputDialog(Lang.send_private_msg, {
                {type = 'number', description = Lang.id_player, required = true},
                {type = 'input', description = Lang.reason, required = true},
            })
            if not input then return end
            if not input[1] then return end
            if not input[2] then return end
            local staff = GetPlayerName(NetworkGetEntityOwner(cache.ped))
            local staff2 = tipo..' '..GetPlayerName(NetworkGetEntityOwner(cache.ped))
            local target = tonumber(input[1])
            local reason = input[2]
            if Config.TxAdmin then
                TriggerServerEvent('send:private:sv', target, reason, staff, false)
            else
                TriggerServerEvent('send:private:sv', target, reason, Lang.msg_from..staff2, true)
            end
        end
    end)
end)



RegisterNetEvent('svg:wipe:player', function()
    lib.callback('checkgroup', false, function(staff, tipo)
        if staff then
            for _,v in pairs(Config.MaxGroups) do
                if tipo == v then
                    local input = lib.inputDialog(Lang.wipe_player, {
                        {type = 'number', description = Lang.id_player, required = true},
                    })
                    if not input then return end
                    if not input[1] then return end
                    local id = tonumber(input[1])
                    local alert = lib.alertDialog({
                        header = Lang.wipe_player,
                        content = Lang.wipe_player_check..id,
                        centered = true,
                        cancel = true
                    })
                    if alert == 'confirm' then
                        TriggerServerEvent('svg:now:wipe', id)
                    end
                end
            end
        end
    end)
end)

RegisterNetEvent('svg:staff:menu', function()
    lib.callback('checkgroup', false, function(staff, tipo)
        if staff then
            local options = {
                {
                    title = Lang.go_to,
                    icon = 'arrow-right',
                    event = 'svg:menu:func',
                    args = {
                        type = 'goto'
                    }
                },
                {
                    title = Lang.go_back,
                    icon = 'arrow-left',
                    event = 'svg:menu:func',
                    args = {
                        type = 'gotoback'
                    }
                },
                {
                    title = Lang.bring,
                    icon = 'user-plus',
                    event = 'svg:menu:func',
                    args = {
                        type = 'bring'
                    }
                },
                {
                    title = Lang.bring_back,
                    icon = 'user-minus',
                    event = 'svg:menu:func',
                    args = {
                        type = 'bringback'
                    }
                },
                {
                    title = Lang.freeze,
                    icon = 'snowflake',
                    event = 'svg:menu:func',
                    args = {
                        type = 'freeze'
                    }
                },
                {
                    title = Lang.unfreeze,
                    icon = 'fire',
                    event = 'svg:menu:func',
                    args = {
                        type = 'unfreeze'
                    }
                },
            }

            if Config.TxAdmin then 
                table.insert(options, {title = Lang.viewId, icon = 'users', event = 'svg:id'})
            end

            lib.registerContext({
                id = 'staffmenu',
                menu = 'adminmenu',
                title = 'Staff Menù',
                options = options,
            })
            lib.showContext('staffmenu')
        end
    end)
end)
local id = false
RegisterNetEvent('svg:id', function()
    if not id then
        lib.callback('checkgroup', false, function(staff, tipo)
            if staff then
                TriggerEvent('txcl:showPlayerIDs', true)
                id = true
            end
        end)
    else
        TriggerEvent('txcl:showPlayerIDs', false)
        id = false
    end
end)

RegisterNetEvent('svg:menu:func', function(args)
    lib.callback('checkgroup', false, function(staff, tipo)
        if staff then
            if args.type ~= 'gotoback' and args.type ~= 'noclip' then
                local input = lib.inputDialog(Lang.menu_staff, {
                    {type = 'number', description = Lang.id_player, required = true},
                })
                if not input then return end
                if not input[1] then return end
                local id = tonumber(input[1])
                TriggerServerEvent('svg:menu:func:sv', args.type, id)
                lib.showContext('staffmenu')
            elseif args.type == 'gotoback' then
                TriggerServerEvent('svg:menu:func:sv', args.type)
                lib.showContext('staffmenu')
            else
                ExecuteCommand(Config.NoClipCommand)
            end     
        end
    end)
end)


RegisterNetEvent('svg:refund:menu', function()
    lib.callback('checkgroup', false, function(staff, tipo)
        if staff then
            local options = {
                {
                    title = Lang.ress,
                    icon = 'suitcase-medical',
                    event = 'svg:menu:refund',
                    args = {
                        type = 'ress'
                    }
                },
                {
                    title = Lang.heal,
                    icon = 'bandage',
                    event = 'svg:menu:refund',
                    args = {
                        type = 'heal'
                    }
                },
                {
                    title = Lang.armour,
                    icon = 'shield-halved',
                    event = 'svg:menu:refund',
                    args = {
                        type = 'armour'
                    }
                },
                {
                    title = Lang.giveItem,
                    icon = 'box',
                    event = 'svg:menu:refund',
                    args = {
                        type = 'item'
                    }
                },
            }
            
            
            lib.registerContext({
                id = 'refundmenu',
                menu = 'adminmenu',
                title = Lang.menu_refund,
                options = options,
            })
            lib.showContext('refundmenu')
        end
    end)
end)

RegisterNetEvent('svg:menu:refund', function(args)
    lib.callback('checkgroup', false, function(staff, tipo)
        if staff then
            local input = lib.inputDialog(Lang.menu_refund, {
                {type = 'number', description = Lang.id_player, required = true},
            })
            if not input then return end
            if not input[1] then return end
            local id = tonumber(input[1])
            if args.type ~= 'item'then
                TriggerServerEvent('svg:refund:sv', args.type, id)
            elseif args.type == 'item' then
                local item = lib.inputDialog(Lang.menu_refund, {
                    {type = 'input', description = Lang.item, required = true},
                    {type = 'number', description = Lang.amount, required = true},
                })
                if not item then return end
                if not item[1] then return end
                if not item[2] then return end
                local num = tonumber(item[2])
                if num <= 0 then return end

                TriggerServerEvent('svg:refund:sv', args.type, id, item[1], num)
            end
            lib.showContext('refundmenu')
        end
    end)
end)

RegisterNetEvent('heal:svg', function(target)
    if target == 'akdabdaidbaida' then
        SetEntityHealth(cache.ped, GetEntityMaxHealth(cache.ped))
    end
end)


----------------------------------------------------------------------------------------------------------
local can = true
RegisterCommand(Config.ReportCommand, function()
    if can then
        local report = lib.inputDialog(Lang.menu_report, {
            { type = 'select', label = Lang.report_reason, required = true, options = {
                { value = Lang.general, label = Lang.general },
                { value = Lang.cheater, label = Lang.cheater },
                { value = Lang.bug, label = Lang.bug },
            }},
            {type = 'input', description = Lang.details, required = true},
        })
        if not report then return end
        if not report[1] then return end
        if not report[2] then return end
        
        local info = {type = report[1], desc = report[2]}
        TriggerServerEvent('svg:report:new', info)
        Config.Notify(Lang.report_created, 'info')

        
        local cool = Config.ReportCooldown * 60
        local first = 0
        can = false

        while (cool > first) do
			Wait(1000)
			first  = first  + 1
		end
        can = true
    else
        Config.Notify(Lang.report_fast, 'error')
    end
end)

local reportTable = {}
local totalReports = 0

RegisterNetEvent('update:feedback', function(new)
    lib.callback('checkgroup', false, function(staff, tipo)
        if staff then
            totalReports = totalReports + 1
            reportTable[totalReports] = new
            Config.Notify(Lang.new_report, 'info')
        end
    end)
end)

RegisterNetEvent('svg:close:client', function(id, a)
    lib.callback('checkgroup', false, function(staff, tipo)
        if staff then
            reportTable[id] = a
        end
    end)
end)

if Config.EnableReportStaffCommand then
    RegisterCommand(Config.ReportStaff, function()
        lib.callback('checkgroup', false, function(staff, tipo)
            if staff then
                local options = {}
                for k, v in ipairs(reportTable) do
    
                    if not v.closed then
                        table.insert(options, {title = 'ID: '..v.feedId..'\n Steam: '..v.steam, description = Lang.type..v.type..'\n'..Lang.reason..': '..v.desc, event = 'svg:open:report', args = {feedId = v.feedId, plyId = v.plyId, steam = v.steam, type = v.type, desc = v.desc, closed = v.closed}})
                    end
                end
                
                lib.registerContext({
                    id = 'reportmenu',
                    menu = 'adminmenu',
                    title = Lang.menu_report,
                    options = options,
                })
                lib.showContext('reportmenu')
            end
        end)
    end)
end

RegisterNetEvent('svg:reports:menu', function()
    lib.callback('checkgroup', false, function(staff, tipo)
        if staff then
            local options = {}
            for k, v in ipairs(reportTable) do

                if not v.closed then
                    table.insert(options, {title = 'ID: '..v.feedId..'\n Steam: '..v.steam, description = Lang.type..v.type..'\n'..Lang.reason..': '..v.desc, event = 'svg:open:report', args = {feedId = v.feedId, plyId = v.plyId, steam = v.steam, type = v.type, desc = v.desc, closed = v.closed}})
                end
            end
            
            lib.registerContext({
                id = 'reportmenu',
                menu = 'adminmenu',
                title = Lang.menu_report,
                options = options,
            })
            lib.showContext('reportmenu')
        end
    end)
end)



RegisterNetEvent('svg:open:report', function(args)
    lib.callback('checkgroup', false, function(staff, tipo)
        if staff then
            local options = {
                {
                    title = Lang.close_report,
                    icon = 'trash',
                    serverEvent = 'svg:delete:report',
                    args = {
                        id = args.feedId,
                    }
                },
                {
                    title = Lang.go_to,
                    icon = 'arrow-right',
                    event = 'svg:report:func',
                    args = {
                        type = 'goto',
                        player = args.plyId,
                        
                    }
                },
                {
                    title = Lang.bring,
                    icon = 'user-plus',
                    event = 'svg:report:func',
                    args = {
                        type = 'bring',
                        player = args.plyId,
                    }
                },
                {
                    title = Lang.ress,
                    icon = 'suitcase-medical',
                    event = 'svg:report:func',
                    args = {
                        type = 'ress',
                        player = args.plyId,
                    }
                },
                {
                    title = Lang.heal,
                    icon = 'bandage',
                    event = 'svg:report:func',
                    args = {
                        type = 'heal',
                        player = args.plyId,
                    }
                },
            }
            lib.registerContext({
                id = 'reportstaff',
                menu = 'reportmenu',
                title = 'Steam: '..args.steam..' - ID: '..args.plyId..'\n\n'..Lang.reason..': '..args.desc,
                options = options,
            })
            lib.showContext('reportstaff')
        end
    end)
end)

RegisterNetEvent('svg:report:func', function(args)
    lib.callback('checkgroup', false, function(staff, tipo)
        if staff then
            if args.type == 'goto' or args.type == 'bring' then
                TriggerServerEvent('svg:menu:func:sv', args.type, args.player)
            elseif args.type == 'ress' or args.type == 'heal' then
                TriggerServerEvent('svg:refund:sv', args.type, args.player)
            end
        end
    end)
end)

RegisterNetEvent('svg:admin:notify', function(reason, type, title)
    if title then
        Config.Notify(reason, type, title)
    else
        Config.Notify(reason, type)
    end
end)