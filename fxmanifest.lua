fx_version 'adamant'
game 'gta5'
developer 'LeDjo_Developpement'
discord 'https://discord.gg/nKVQW5Q5js'
lua54 'yes'

shared_scripts {
	'@ox_lib/init.lua',
	'config/config.lua',
	'locales.lua',
	'locales/*.lua',
	'bridge/framework.lua',
}
server_scripts {
	'@oxmysql/lib/MySQL.lua',
	'bridge/**/server.lua',
	'config/server_config.lua',
	'server/*'
}
client_scripts {
	'bridge/**/client.lua',
	'config/vehicles.lua',
	'client/*'
}
