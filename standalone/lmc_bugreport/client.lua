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

RegisterCommand('bugreport', function(source)
	openGui()
end)

RegisterNetEvent("lmc_bugreport:openGui")
AddEventHandler("lmc_bugreport:openGui", function(user_id)
	user_id = user_id
    openGui()
end)

RegisterNUICallback("sendReport", function(data)
  discord = data['data'][1]
  id = data['data'][2]
  description = data['data'][3]
  bug = data['data'][4]
  if (discord == "" or id == "" or description == "" or bug == "") then
    print("noget mangler")

  else
    TriggerServerEvent("lmc_bugreport:sendReport", data)
  end

end)

RegisterNetEvent("lmc_bugreport:reportSent")
AddEventHandler("lmc_bugreport:reportSent", function(user_id)
	user_id = user_id
    closeGui()
end)

RegisterNUICallback("close", function()
	closeGui()
end)
