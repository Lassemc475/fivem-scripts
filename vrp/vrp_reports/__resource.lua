client_scripts {
	"lib/Proxy.lua",
    "lib/Tunnel.lua",
    'cl_reports.lua'
}

server_scripts {
    "@vrp/lib/utils.lua",
	'sv_reports.lua',
    'sv_config.lua'
}

files {
    'html/*'
}

ui_page 'html/html.html'