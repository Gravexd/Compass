fx_version 'cerulean'
game 'gta5'

version '2.0.0'
description 'https://github.com/Gravexd/compass'


client_scripts {
	"config.lua",
	"essentials.lua",
	"client/compass_cl.lua",
}

ui_page('html/index.html')

files({
    'html/index.html',
    'html/app.js',
    'html/style.css',
})

shared_script '@ox_lib/init.lua'

lua54 "yes"
