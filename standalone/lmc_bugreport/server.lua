local webhook = "" --Indsæt dit eget Discord webhook her, ellers virker det ikke.


RegisterNetEvent("lmc_bugreport:sendReport")
AddEventHandler("lmc_bugreport:sendReport", function(data)

  discord = data['data'][1]
  id = data['data'][2]
  description = data['data'][3]
  bug = data['data'][4]

  local fields = {}

  table.insert(fields, { name = "Discord:", value = discord, inline = true })
  table.insert(fields, { name = "Id:", value = id, inline = true })
  table.insert(fields, { name = "Hvordan fandt du buggen?:", value = bug, inline = false })

  PerformHttpRequest(webhook, function(err, text, headers) end, 'POST', json.encode(
    {
      username = "lmc_bugreport",
      embeds = {
        {
          description = "```" .. description .. "```",
          color = 16769280,
          fields = fields
        }
      },
    }), { ['Content-Type'] = 'application/json' })


  TriggerClientEvent("lmc_bugreport:reportSent", source)
  TriggerClientEvent("pNotify:SendNotification", source,{text = "Din bugreport blev sendt afsted", type = "error", queue = "global", timeout = 10000, layout = "centerRight",animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"},killer = true})



end)
