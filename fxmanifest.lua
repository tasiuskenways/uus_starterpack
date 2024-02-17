fx_version 'cerulean'
game 'gta5'
author 'Tasius Kenways'

version '1.0.0'

shared_scripts {
    '@ox_lib/init.lua',
    'config.lua'
}

client_scripts {
    'cl_main.lua',
}

server_scripts {
    'sv_main.lua',
    '@oxmysql/lib/MySQL.lua',
}

ox_lib "locale"

lua54 'yes'
use_experimental_fxv2_oal 'yes'
