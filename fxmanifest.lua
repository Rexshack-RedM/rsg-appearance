fx_version 'cerulean'
rdr3_warning 'I acknowledge that this is a prerelease build of RedM, and I am aware my resources *will* become incompatible once RedM ships.'
game 'rdr3'
lua54 'yes'

description 'rsg-appearance'
version '1.0.4'

client_scripts {
    'utils/overlays.lua',
    'utils/features.lua',
    'utils/functions.lua',
    'utils/cloth_hash_names.lua',
    'utils/hairs_list.lua',
    'config.lua',
    'client/cl_main.lua',
}

server_scripts {    
    'server/sv_main.lua',
    '@oxmysql/lib/MySQL.lua',
}
files {
  'img/*.png
}
