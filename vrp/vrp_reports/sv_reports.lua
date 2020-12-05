local Tunnel = module("vrp", "lib/Tunnel")
local Proxy = module("vrp", "lib/Proxy")

vRP = Proxy.getInterface("vRP")
vRPclient = Tunnel.getInterface("vRP","vrp_reports")

local reports = {}
local discord = {}
local wait = {}
local hidden = {}

RegisterCommand("openreport", function(source, args, user)
    local xPlayer = vRP.getUserId({source})
    if vRP.hasGroup({xPlayer,"ledelse"}) then
        TriggerClientEvent("reports:openreport", source, args[1])
    end
end)

RegisterCommand("report", function(source, args, user)
    local source = source
    local xPlayers = GetPlayers()

    if ((wait[source]) and (wait[source]+Config.ReportCooldown > GetGameTimer())) then
        TriggerClientEvent('reports:error', source, 'Vent venligst lidt tid med at lave en ny.')
    end

    if string.len(table.concat(args, " ")) < 15 then
        TriggerClientEvent('reports:error', source, 'Du bedes skrive lidt mere til din rapport.')
    end

    local report = #reports + 1
    reports[report] = { report = report, id = source, name = GetPlayerName(source), text = table.concat(args, " "), discord = discord[source] }

    for k,v in pairs(xPlayers) do
        local xPlayer = vRP.getUserId({v})

        TriggerClientEvent("reports:addReport", v, reports[report])
    end

    wait[source] = GetGameTimer()
end)

RegisterServerEvent("reports:bring")
AddEventHandler("reports:bring", function(id)
    TriggerClientEvent('reports:goto', id, source)
end)

RegisterServerEvent("reports:historyS")
AddEventHandler("reports:historyS", function()
    local source = source
    local xPlayer = vRP.getUserId({source})

    if vRP.hasGroup({xPlayer,"ledelse"}) then
        TriggerClientEvent("reports:history", source)
    end
end)

RegisterServerEvent("reports:delete")
AddEventHandler("reports:delete", function(id)
    reports[id] = nil
    TriggerClientEvent("reports:error", source, 'Du slettede case #' .. id)
    TriggerClientEvent("reports:delete", source, id)
end)

RegisterServerEvent("reports:init")
AddEventHandler("reports:init", function()
    local src = source
    local identifier = nil
    local data = nil

    for k,v in pairs(GetPlayerIdentifiers(src)) do
        if string.find(v,'discord') then
            identifier = string.sub(v, 9)
        end
    end

    if not identifier then
        discord[src] = GetPlayerName(src)
    else
        PerformHttpRequest("https://fivem.dk/api/getUser.php?identifier="..identifier.."&type=string", function(err, text, headers)
            if err == 200 then
                discord[src] = text
            else
                discord[src] = GetPlayerName(source)
            end
        end, "GET", "", {["Content-type"] = "application/json"})
    end
end)