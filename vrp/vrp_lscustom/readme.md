# vRP_lscustom - Med Bennys Auto ting, såsom liveries, osv.

**Client**

Tilføj dette efter ``SetVehicleWindowTint(nveh,tonumber(windowtint))`` i vrp_garages/client.lua
```lua
local playerVeh = GetVehiclePedIsIn(GetPlayerPed(-1), false)
local VehicleModel = GetEntityModel(playerVeh)
local model =  GetDisplayNameFromVehicleModel(VehicleModel)
TriggerServerEvent("LSC:applyModifications",model,playerVeh)
```


**SQL**

Tilføj en ``modifications`` kolonne under ``vrp_user_garages``
