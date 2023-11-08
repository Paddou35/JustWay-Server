fx_version 'adamant'

game 'gta5'

description 'BCSO Script for Saphira Server - RageUI'

version '1.0.1'

shared_scripts { 
	'@es_extended/imports.lua',
    'config.lua'
}

server_scripts {
	--'@async/async.lua',
	'@oxmysql/lib/MySQL.lua',
	'server/sv_main.lua'
}

client_scripts {
	'src/RMenu.lua',
    'src/menu/RageUI.lua',
    'src/menu/Menu.lua',
    'src/menu/MenuController.lua',
    'src/components/*.lua',
    'src/menu/elements/*.lua',
    'src/menu/items/*.lua',
    'src/menu/panels/*.lua',
    'src/menu/windows/*.lua',
	'client/cl_main.lua',
    'client/cl_cloakroom.lua',
    'client/cl_function.lua',
    'client/cl_actionmenu.lua'
}

dependencies {
	'es_extended',
	'esx_skin',
}