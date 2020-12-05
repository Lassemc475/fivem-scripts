vRP = Proxy.getInterface("vRP")
vRPclient = Tunnel.getInterface("vRP","vrp_reports")

local NUI = false

function getPlayersInArea(coords,area)
    local players = GetActivePlayers()
    local playersInArea = {}
  
    for i=1, #players, 1 do
  
      local target       = GetPlayerPed(players[i])
      local targetCoords = GetEntityCoords(target)
      local distance     = GetDistanceBetweenCoords(targetCoords.x, targetCoords.y, targetCoords.z, coords.x, coords.y, coords.z, true)
  
      if distance <= area then
        table.insert(playersInArea, players[i])
      end
  
    end
  
    return playersInArea
end

TriggerServerEvent("reports:init")

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
        if (IsControlJustPressed(1, 10) and not NUI) then
            TriggerServerEvent("reports:historyS")
            Wait(500)
        end
	end
end)

RegisterNetEvent("reports:openreport")
AddEventHandler("reports:openreport", function(id)
    if not id then
        SendNUIMessage({ action = 'error', data = 'Ugyldigt case nummer.' })
        return
    end

    SendNUIMessage({ action = 'open', data = id })
end)

RegisterNetEvent("reports:history")
AddEventHandler("reports:history", function(history)
    SetNuiFocus(true, true)
    SendNUIMessage({ action = 'history' })
end)

RegisterNetEvent("reports:delete")
AddEventHandler("reports:delete", function(id)
    SendNUIMessage({ action = 'delete', data = id })
end)

RegisterNUICallback('closeNUI', function()
    NUI = false
    SetNuiFocus(NUI, NUI)
end)

RegisterNUICallback('openNUI', function()
    NUI = true
    SetNuiFocus(NUI, NUI)
end)

RegisterNUICallback('goto', function(data)
    TriggerEvent("reports:goto", data.player)
end)

RegisterNUICallback('GetInfo', function(data, cb)
    local sec = math.floor((GetGameTimer()-data.timer)/1000)
    local min = math.floor(((GetGameTimer()-data.timer)/1000)/60)

    local id = GetPlayerFromServerId(data.player)
    local ped = GetPlayerPed(id)
    local div = {'fas fa-power-off', 'OFFLINE'}

    if DoesEntityExist(ped) and NetworkIsPlayerActive(id) then
        local nearbyPlayers = getPlayersInArea(GetEntityCoords(ped), 20)
        div = {'fas fa-users', #nearbyPlayers - 1 .. ' spillere i nærheden (20m)'}
    end
    
    cb({div,data, GetStreetAndZone(GetEntityCoords(ped)), min > 0 and (min .. " minutter siden") or (sec .. " sekunder siden")})
end)

RegisterNUICallback('bring', function(data)
    local id = GetPlayerFromServerId(data.player)
    local ped = GetPlayerPed(id)

    if DoesEntityExist(ped) then
        TriggerServerEvent("reports:bring", data.player)
    else
        TriggerEvent("notification", 'Spilleren er offline!', 2)
    end
end)

RegisterNUICallback('delete', function(data)
    TriggerServerEvent("reports:delete", data.report)
end)

RegisterNetEvent("reports:goto")
AddEventHandler("reports:goto", function(id)
    local id = GetPlayerFromServerId(id)
    local ped = GetPlayerPed(id)

    if DoesEntityExist(ped) then
        DoScreenFadeOut(500)
        Wait(500)
        SetEntityCoords(PlayerPedId(), GetEntityCoords(ped))
        DoScreenFadeIn(500)
    else
        TriggerEvent("notification", 'Spilleren er offline!', 2)
    end
end)

RegisterNetEvent("reports:error")
AddEventHandler("reports:error", function(msg)
    SendNUIMessage({ action = 'error', data = msg })
end)

RegisterNetEvent("reports:info")
AddEventHandler("reports:info", function(msg)
    SendNUIMessage({ action = 'info', data = msg })
end)

RegisterNetEvent("reports:addReport")
AddEventHandler("reports:addReport", function(data)
    local years, months, days, hours, minutes, seconds = Citizen.InvokeNative(0x50C7A99057A69748, Citizen.PointerValueInt(), Citizen.PointerValueInt(), Citizen.PointerValueInt(), Citizen.PointerValueInt(), Citizen.PointerValueInt(), Citizen.PointerValueInt())
    local id = GetPlayerFromServerId(data.id)
    local ped = GetPlayerPed(id)
    local coords = GetEntityCoords(ped)

    data.x = coords.x
    data.y = coords.x
    data.z = coords.x
    data.time = hours .. ":" .. minutes .. ":" .. seconds
    data.timer = GetGameTimer()

    SendNUIMessage({ action = 'new', data = data })
end)

function GetStreetAndZone(plyPos)
    local s1, s2 = Citizen.InvokeNative( 0x2EB41072B4C1E4C0, plyPos.x, plyPos.y, plyPos.z, Citizen.PointerValueInt(), Citizen.PointerValueInt() )
    local street1 = GetStreetNameFromHashKey(s1)
    local street2 = GetStreetNameFromHashKey(s2)
    zone = tostring(GetNameOfZone(plyPos.x, plyPos.y, plyPos.z))
    local playerStreetsLocation = GetLabelText(zone)
    local street = street1 .. ", " .. playerStreetsLocation
    return street
end

AddEventHandler('onResourceStop', function(resource)
    SetNuiFocus(false, false)
end)
