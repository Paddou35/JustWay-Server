Config = {}

Config.MenuCommand = 'admin'
Config.TxAdmin = true

Config.Groups = {
    'admin',
    'mod',
    'helper'
}
Config.MaxGroups = {
    'admin',
}

Config.RessTrigger = 'atx_death:revive'
Config.UseBasicneeds = false

Config.NoClipCommand = 'noclip'
Config.ReportCommand = 'report'

Config.EnableReportStaffCommand = true
Config.ReportStaff = 'reports'

Config.ReportCooldown = 5

Config.EnableWipeConsole = true --se true i giocatori possono essere wippati dalla console tramite identifier / if true players can be wipped from the console by identifier

Config.Notify = function(msg, type, title)
    if not title then --check for title
        lib.notify({
            title = 'Server Name',
            description = msg,
            type = type,
            position = 'top-center',
            duration = 5000,
        })
    else
        lib.notify({
            title = title,
            description = msg,
            type = type,
            position = 'top-center',
            duration = 5000,
        })
    end
end

Lang = {
    menu_admin = 'Admin Menù',

    menu_report = 'Reports Menù',
    menu_report_desc = 'Manage player reports',
    report_reason = 'Report reason',
    type = 'Type: ',
    general = 'General',
    cheater = 'Cheater',
    bug = 'Bug',
    details = 'Details',
    report_created = 'You have created a report!',
    report_fast = 'You can\'t send reports that fast!',
    new_report = 'New Report Received!',
    close_report = 'Close Report',
    report_closed = 'You closed the report!',

    menu_staff = 'Staff Menù',
    menu_staff_desc = 'This menu contains interactions for the staff',
    go_to = 'Go to a Player',
    go_back = 'Go Back',
    bring = 'Bring Player',
    bring_back = 'Bring Back Player',
    freeze = 'Freeze Player',
    unfreeze = 'Unfreeze Player',
    viewId = 'View ID',
    tp_to = 'You teleported to ',
    have_to_tp = 'You have to tp first from a player!',
    tp_to_you = 'You teleported ',
    to_you = ' to you',
    have_been_tp = 'You have been teleported by the staff ',
    tp_back = 'You have been teleported back',
    no_now = 'You can\'t use it now!',
    you_freeze = 'You have freeze ',
    have_been_freeze = 'You have been freeze by ',
    you_unfreeze = 'You have unfreeze ',
    have_been_unfreeze = 'You have been unfreeze by ',

    menu_refund = 'Refund Menù',
    menu_refund_desc = 'This menu contains refund functions',
    ress = 'Revive Player',
    heal = 'Heal Player',
    armour = 'Give Armour',
    giveItem = 'Give Item',
    item = 'Item',
    amount = 'Amount',
    you_ress = 'You revived ',
    ress_by = 'You have been revived by ',
    you_heal = 'You healed ',
    heal_by = 'You have been healed by ',
    giveg = 'You gave the armour to ',
    receiveg = 'You received the armour from ',

    send_announce = 'Submit announcement',
    send_announce_desc = 'Send an announcement for all players',
    announce = '~y~Announcement',
    write_announce = 'Write the ad',

    send_private_msg = 'Recall Player',
    send_private_msg_desc = 'Send a private message to a player',
    msg_from = 'Message from ',

    wipe_player = 'Wipe Player',
    wipe_player_desc = 'Delete all player data from the server',
    wipe_player_check = 'Are you sure you want to wipe the player with ID: ',
    wipe_success = 'You wipped ID: ',
    have_been_wipped = 'You have been wipped!',

    no_staff = 'You are not a staff',
    not_valid_msg = 'Enter a valid message',

    id_player = 'ID Player',
    reason = 'Reason',
    not_in_game = 'Player not in game',
}