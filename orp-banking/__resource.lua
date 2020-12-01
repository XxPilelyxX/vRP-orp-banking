dependency "vrp"

client_scripts{
    'lib/Proxy.lua',
    'lib/Tunnel.lua',
    'client.lua'
}

server_scripts {
    '@mysql-async/lib/MySQL.lua',
    '@vrp/lib/utils.lua',
    'server.lua'
}

ui_page 'html/index.html'

files {
    'html/index.html',
    'html/script.js',
    'html/style.css',
    'html/img/logo.png',
    'html/img/logo-red.png',
    'html/img/logo-blue.png',
}