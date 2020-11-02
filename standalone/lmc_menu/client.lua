local show = false
function openGui()
  if show == false then
    show = true
    SetNuiFocus(true, true)

    SendNUIMessage(
      {
        show = true
      }
    )
  end
end

function closeGui()
  show = false
  SetNuiFocus(false)
  SendNUIMessage({show = false})
end

RegisterCommand('gui1', function(source)
	openGui()
end)

RegisterNetEvent("lmc_menu:openGui")
AddEventHandler("lmc_menu:openGui", function(user_id)
	user_id = user_id
    openGui()
end)

RegisterNUICallback("button1", function()
	TriggerServerEvent("lmc_menu:button1")
end)

RegisterNUICallback("button2", function()
	TriggerServerEvent("lmc_menu:button2")
end)

RegisterNUICallback("button3", function()
	TriggerServerEvent("lmc_menu:button3")
end)

RegisterNUICallback("button4", function()
	TriggerServerEvent("lmc_menu:button4")
end)

RegisterNUICallback(
  "close",
  function(data)
    closeGui()
  end
)

AddEventHandler(
  "onResourceStop",
  function(resource)
    if resource == GetCurrentResourceName() then
      closeGui()
    end
  end
)
