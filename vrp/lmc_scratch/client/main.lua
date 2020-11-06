vRP = Proxy.getInterface("vRP")
vRPclient = Tunnel.getInterface("vRP", "lmc_scratch")

local open = false
local skrabet = false
local skrabet1 = false


RegisterNetEvent("lmc_scratch:SkrabetJa")
AddEventHandler("lmc_scratch:SkrabetJa", function()
  if open then
      closeGui()
    else
      openGui()
    end
end)


Citizen.CreateThread(function()
  while true do
    if open then
      local ply = GetPlayerPed(-1)
      local active = true
      DisableControlAction(0, 1, active) -- LookLeftRight
      DisableControlAction(0, 2, active) -- LookUpDown
      DisableControlAction(0, 24, active) -- Attack
      DisablePlayerFiring(ply, true) -- Disable weapon firing
      DisableControlAction(0, 142, active) -- MeleeAttackAlternate
      DisableControlAction(0, 106, active) -- VehicleMouseControlOverride
    end
    Citizen.Wait(0)
  end
end)

RegisterNUICallback("close", function(data)
  closeGui()
end)

RegisterNUICallback("vinder", function()
  if skrabet == false then
  TriggerServerEvent("lmc_scratch:vinder")
  skrabet = true
  end
end)

RegisterNUICallback("verify", function()
  if skrabet1 == false then
  TriggerServerEvent("lmc_scratch:verify")
  skrabet1 = true
  end
end)

RegisterNetEvent("lmc_scratch:notification")
AddEventHandler("lmc_scratch:notification", function(message)
    nuiNotification(message)
end)

function openGui()
  open = true
  SetNuiFocus(true, true)
  SendNUIMessage({open = true})
end

function closeGui()
  SetNuiFocus(false)
  SendNUIMessage({open = false})
  open = false
end

function nuiNotification(message)
  SendNUIMessage({
    notification = true,
    notification_msg = message
  })
end


function LocalPed()
  return GetPlayerPed(-1)
end

AddEventHandler("onResourceStop", function(resource)
  if resource == GetCurrentResourceName() then
    if open then
      closeGui()
    end
  end
end)
