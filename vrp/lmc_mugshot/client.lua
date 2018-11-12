local player = GetPlayerPed(-1)
local playerCoords = GetEntityCoords(player)


local handle
local board
local board_model = GetHashKey("prop_police_id_board")
local player = GetPlayerPed(-1)
local playerCoords = GetEntityCoords(player)
local board_pos = vector3(playerCoords.x, playerCoords.y, playerCoords.z)
local board_scaleform
local overlay
local overlay_model = GetHashKey("prop_police_id_text")


local function CreateNamedRenderTargetForModel(name, model)
	local handle = 0
	if not IsNamedRendertargetRegistered(name) then
		RegisterNamedRendertarget(name, 0)
	end
	if not IsNamedRendertargetLinked(model) then
		LinkNamedRendertarget(model)
	end
	if IsNamedRendertargetRegistered(name) then
		handle = GetNamedRendertargetRenderId(name)
	end

	return handle
end

local function LoadScaleform (scaleform)
	local handle = RequestScaleformMovie(scaleform)

	if handle ~= 0 then
		while not HasScaleformMovieLoaded(handle) do
			Citizen.Wait(0)
		end
	end

	return handle
end

local function CallScaleformMethod (scaleform, method, ...)
	local t
	local args = { ... }

	BeginScaleformMovieMethod(scaleform, method)

	for k, v in ipairs(args) do
		t = type(v)
		if t == 'string' then
			PushScaleformMovieMethodParameterString(v)
		elseif t == 'number' then
			if string.match(tostring(v), "%.") then
				PushScaleformMovieFunctionParameterFloat(v)
			else
				PushScaleformMovieFunctionParameterInt(v)
			end
		elseif t == 'boolean' then
			PushScaleformMovieMethodParameterBool(v)
		end
	end

	EndScaleformMovieMethod()
end



RegisterNetEvent('mugshot:makeTheBoard')
AddEventHandler('mugshot:makeTheBoard', function(fornavn, efternavn, age, registration)
        title = age
        center = fornavn.. " ".. efternavn
        footer = registration
        header = ""
	CallScaleformMethod(board_scaleform, 'SET_BOARD', title, center, footer, header, 0, 1337, 116)
end)





Citizen.CreateThread(function()
	board_scaleform = LoadScaleform("mugshot_board_01")
	handle = CreateNamedRenderTargetForModel("ID_Text", overlay_model)


	while handle do
		HideHudAndRadarThisFrame()
		SetTextRenderId(handle)
		Set_2dLayer(4)
		Citizen.InvokeNative(0xC6372ECD45D73BCD, 1)
		DrawScaleformMovie(board_scaleform, 0.405, 0.37, 0.81, 0.74, 255, 255, 255, 255, 0)
		Citizen.InvokeNative(0xC6372ECD45D73BCD, 0)
		SetTextRenderId(GetDefaultScriptRendertargetRenderId())

		Citizen.InvokeNative(0xC6372ECD45D73BCD, 1)
		Citizen.InvokeNative(0xC6372ECD45D73BCD, 0)
		Wait(0)
	end
end)

function LetFuckingGo()
	local ped = PlayerPedId()

	RequestModel(board_model)
	RequestModel(overlay_model)
	RequestAnimDict(lineup_male)

	while not HasModelLoaded(board_model) or not HasModelLoaded(overlay_model) do Wait(1) end

	board = CreateObject(board_model, board_pos, false, true, false)
	overlay = CreateObject(overlay_model, board_pos, false, true, false)
	AttachEntityToEntity(overlay, board, -1, 4103, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, false, false, false, false, 2, true)
	SetModelAsNoLongerNeeded(board_model)
	SetModelAsNoLongerNeeded(overlay_model)

	ClearPedWetness(ped)
	ClearPedBloodDamage(ped)
	ClearPlayerWantedLevel(PlayerId())
	SetCurrentPedWeapon(ped, GetHashKey("weapon_unarmed"), 1)
	AttachEntityToEntity(board, ped, GetPedBoneIndex(ped, 28422), 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0, 0, 0, 0, 2, 1)

end

Citizen.CreateThread(function()
    local dict = "mp_character_creation@lineup@male_a"
    local ped = GetPlayerPed(-1)
    local sitting = IsPedSittingInAnyVehicle(ped)

    RequestAnimDict(dict)
    while not HasAnimDictLoaded(dict) do
        Citizen.Wait(100)
    end
    local mugshot = false
    while true do
        Citizen.Wait(0)
        if IsControlJustPressed(1, 212) and not IsPedInAnyVehicle(PlayerPedId(), true) and not IsPedSwimming(PlayerPedId(), true) then
            if not mugshot and not sitting then
                    
    TriggerServerEvent('mugshot:getInfo')
                Wait(500)
                LetFuckingGo()
                TaskPlayAnim(GetPlayerPed(-1), dict, "loop_raised", 8.0, 8.0, -1, 49, 0, false, false, false)
                mugshot = true
            else
                mugshot = false
                ClearPedSecondaryTask(GetPlayerPed(-1))
                DeleteObject(overlay)
            DeleteObject(board)
            end
        elseif IsPedInAnyVehicle(PlayerPedId(), true) and mugshot == true then
            mugshot = false
            
        end
        if mugshot == true then
            DisableControlAction(0, 24, true) -- attack
            DisableControlAction(0, 25, true) -- aim
            DisableControlAction(0, 37, true) -- weapon wheel
            DisableControlAction(0, 44, true) -- cover
            DisableControlAction(0, 45, true) -- reload
            DisableControlAction(0, 140, true) -- light attack
            DisableControlAction(0, 141, true) -- heavy attack
            DisableControlAction(0, 142, true) -- alternative attack
            DisablePlayerFiring(GetPlayerPed(-1), true) -- Disable weapon firing
        end
    end
end)