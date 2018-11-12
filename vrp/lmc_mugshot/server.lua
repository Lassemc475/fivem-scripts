local Tunnel = module("vrp", "lib/Tunnel")
local Proxy = module("vrp", "lib/Proxy")

vRP = Proxy.getInterface("vRP")
vRPclient = Tunnel.getInterface("vRP","lmc_mugshot")

RegisterServerEvent('mugshot:getInfo')
AddEventHandler('mugshot:getInfo', function()
	local source = source
    local user_id = vRP.getUserId({source})
    local player = vRP.getUserSource({user_id})
    local nuser_id = vRP.getUserId({source})
                vRP.getUserIdentity({nuser_id, function(identity)
					if identity then
                        local fornavn = identity.firstname
                        local efternavn = identity.name
                        local age = identity.age.. " år"
                        local registration = identity.registration.. "-".. identity.user_id
                        TriggerClientEvent('mugshot:makeTheBoard', -1, fornavn, efternavn, age, registration)
                    end
                end})
end)

