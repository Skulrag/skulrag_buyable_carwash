-- Resource Metadata
fx_version 'cerulean'
games { 'gta5' }
lua54 'on'

author 'Skulrag <skulragpro@gmail.com>'
description 'Skulrag\'s buyables carwash'
version '1.0.0'

-- What to run
client_scripts {
	'@es_extended/locale.lua',
	'locales/en.lua',
	'locales/fr.lua',
	'config.lua',
	'client/utils.lua',
	'client/main.lua'
}

server_scripts {
	'@mysql-async/lib/MySQL.lua',
	'@es_extended/locale.lua',
	'locales/en.lua',
	'locales/fr.lua',
	'config.lua',
	'server/main.lua'
}

-- Extra data can be used as well
dependency 'es_extended'
