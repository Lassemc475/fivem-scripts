function Draw3DText(x, y, z, text)
	local onScreen, _x, _y = World3dToScreen2d(x, y, z)
	local px, py, pz = table.unpack(GetGameplayCamCoords())

	SetTextScale(0.35, 0.35)
	SetTextFont(4)
	SetTextProportional(1)
	SetTextColour(255, 255, 255, 215)
	SetTextEntry("STRING")
	SetTextCentre(1)
	AddTextComponentString(text)
	DrawText(_x, _y)
	local factor = (string.len(text)) / 370
	DrawRect(_x, _y + 0.0125, 0.015 + factor, 0.03, 20,20,20,150)
end

local counter = 0

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1000)
		if counter >= 1 then
			counter = counter - 1
		end
	end
end)



Citizen.CreateThread(function()
	while true do
		Citizen.Wait(5)
		local player = GetPlayerPed(-1)
		local coords = GetEntityCoords(PlayerPedId(),true)
		local x,y,z = 1946.3254394531,3851.6657714844,31.164108276367
		if (Vdist(coords["x"], coords["y"], coords["z"], x,y,z) < 5) then
			if counter == 0 then
				Draw3DText(x,y,(z+1.33), "Tryk ~g~H~w~ for at starte nedtællingen")
				if IsControlJustPressed(0, 74) then
		    	counter = 100
				end
			else
				Draw3DText(x,y,(z+1.33), counter .. " sekunder tilbage")
			end
		end
	end
end)
