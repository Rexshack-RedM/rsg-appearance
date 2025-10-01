fx_version 'cerulean'
rdr3_warning 'I acknowledge that this is a prerelease build of RedM, and I am aware my resources *will* become incompatible once RedM ships.'
game 'rdr3'
lua54 'yes'

description 'rsg-appearance'
version '2.4.13'

shared_scripts {
    '@ox_lib/init.lua',
    'config.lua',
    'shared/functions.lua',
}

client_scripts {
    'client/*.lua',
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'server/*.lua',
}

files {
    'img/*.png',
    'data/features.lua',
    'data/overlays.lua',
    'data/clothing.lua',
    'data/hairs_list.lua',
    'data/clothes_list.lua',
    'locales/*.json',
}

ox_libs {
    'locale',
}

dependencies {
    'rsg-core',
    'ox_lib'
}
