fx_version 'cerulean'
lua54 'yes'
games { 'gta5' }
author 'Easy Dev'
description 'Periority Cooldown System made By Easy Dev'
version '1.0.0'

ox_lib 'locale'

client_scripts {
    'client/main.lua',
    'client/client_open.lua',
}
server_scripts {
    'server/**.lua',
}
shared_scripts {
    'config.lua',
    '@ox_lib/init.lua',
    '@qbx_core/modules/playerdata.lua',
}
files {
    'web/index.html',
    'web/app.js',
    'web/css/style.css',
    'locales/en.json',
}

ui_page {'web/index.html'}

escrow_ignore { 
    'config.lua',
    'client/client_open.lua',
}
exports {
    'isCooldownInactive'
}

dependencies {
    'ox_lib'
}
