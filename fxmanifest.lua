fx_version 'cerulean'
rdr3_warning 'I acknowledge that this is a prerelease build of RedM, and I am aware my resources *will* become incompatible once RedM ships.'
game 'rdr3'
lua54 'yes'

description 'rsg-appearance'
version '2.1.0'

shared_scripts '@ox_lib/init.lua'

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
  '@oxmysql/lib/MySQL.lua',
  'server/sv_main.lua',
}

files {
  'img/*.png'
}

dependency {
  'ox_lib'
}
