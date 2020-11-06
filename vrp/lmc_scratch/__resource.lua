resource_manifest_version "77731fab-63ca-442c-a67b-abc70f28dfa5"
dependency 'mysql-async'

ui_page "client/html/ui.html"
files {
	"client/html/ui.html",
	"client/html/styles.css",
	"client/html/scripts.js",
	"client/html/wScratchPad.min.js",
	"client/html/*.png"
}

client_script {
	"lib/Tunnel.lua",
	"lib/Proxy.lua",
	"client/main.lua"
}
server_scripts {
	"@mysql-async/lib/MySQL.lua",
	"@vrp/lib/utils.lua",
	"server/main.lua"
}
