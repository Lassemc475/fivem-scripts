local Tunnel = module("vrp", "lib/Tunnel")
local Proxy = module("vrp", "lib/Proxy")
local DISCORD_WEBHOOK = "webhook.link/skrrtskrrt"
local DISCORD_NAME = "Skrabelod log"
local item = "skrabelod"
local haveItem = false



vRP = Proxy.getInterface("vRP")
vRPclient = Tunnel.getInterface("vRP", "lmc_scratch")


RegisterServerEvent("lmc_scratch:vinder")
AddEventHandler("lmc_scratch:vinder", function(message)


    local source = source
    local user_id = vRP.getUserId({source})

    if haveItem then
      haveItem = false

  		reward = math.random(25000, 50000)
  	  local penge = reward
  		vRP.giveMoney({user_id,penge})
  		sendToDiscord(title, "ID - ".. tostring(user_id).. " Har lige vundet ".. tostring(penge).. " kr på et skrabelod!", color)
  		TriggerClientEvent("pNotify:SendNotification", source,{text ="Du vandt og fik udbetalt "..penge.." kr", type = "info", queue = "global",timeout = 8000, layout = "bottomCenter",animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"},killer = true})
  end
end)



RegisterCommand('skrab', function(source)
  local user_id = vRP.getUserId({source})
  local player = vRP.getUserSource({user_id})

  local _source = source
  local user_id = vRP.getUserId({source})



  if vRP.tryGetInventoryItem({user_id, item, 1, false}) then
    haveItem = true
    TriggerClientEvent('lmc_scratch:SkrabetJa', source)
  end

end)


function sendToDiscord(user_id, message, color)
  local connect = {
        {
            ["color"] = 3447003,
            ["title"] = "Skrabelod log",
            ["description"] = message,
            -- ["footer"] = {
            -- ["text"] = "",
            -- },
        }
    }
  PerformHttpRequest(DISCORD_WEBHOOK, function(err, text, headers) end, 'POST', json.encode({username = DISCORD_NAME, embeds = connect}), { ['Content-Type'] = 'application/json' })
end
