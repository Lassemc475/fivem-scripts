Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        SetForceVehicleTrails(true)
        SetForcePedFootstepsTracks(true)
        ClearOverrideWeather()
        ClearWeatherTypePersist()
        SetWeatherTypeNowPersist('XMAS')
        N_0xc54a08c85ae4d410(3.0)
        RequestScriptAudioBank("ICE_FOOTSTEPS", false)
        RequestScriptAudioBank("SNOW_FOOTSTEPS", false)
        RequestNamedPtfxAsset("core_snow")
        while not HasNamedPtfxAssetLoaded("core_snow") do
            Citizen.Wait(0)
        end
        UseParticleFxAssetNextCall("core_snow")
    end
end)