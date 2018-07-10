local countdown = 0

local mute = false
local allowed = false
local inProgress = false

local a, b, c = nil

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		if NetworkIsSessionStarted() then
			TriggerServerEvent("svrMeeting:playerConnected")
			return
		end
	end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if mute then
            FreezeEntityPosition(GetPlayerPed(-1), true)
            RemoveAllPedWeapons(GetPlayerPed(-1), true)
            DisableControlAction(0, 245, true)
            NetworkSetVoiceActive(false)
        else
            FreezeEntityPosition(GetPlayerPed(-1), false)
            NetworkSetVoiceActive(true)
        end
    end
end)

RegisterCommand("meeting", function(source, args, raw)
    if allowed then
        
        countdown = args[2]

        if args[1] == "start" then
            if not inProgress then
                local meetingHost = GetPlayerName(source)
                local x, y, z = table.unpack(GetEntityCoords(GetPlayerPed(-1), true))
                TriggerServerEvent("svrMeeting:beginSync", meetingHost, x, y, z, countdown)
            else
                TriggerEvent('chatMessage', "^1[CADOJ]: There is already a meeting in progress.")
            end
        elseif args[1] == "stop" then
            if inProgress then
                local meetingHost = GetPlayerName(source)
                local x, y, z = table.unpack(GetEntityCoords(GetPlayerPed(-1), true))
                TriggerServerEvent("svrMeeting:finalizeMeeting", meetingHost)
            else
                TriggerEvent('chatMessage', "^1[CADOJ]: There is not a meeting in progress.")
            end
        end
    end
end, false)

RegisterNetEvent("svrMeeting:beginMeeting")
AddEventHandler("svrMeeting:beginMeeting", function(x, y, z, meetingHost)
    a, b, c = table.unpack(GetEntityCoords(GetPlayerPed(-1), true))
    SetEntityCoords(GetPlayerPed(-1), x, y, z, 0, 0, 0, false)
    inProgress = true
    mute = true
    if allowed == true then
        mute = false
    else
        mute = true
    end
end)

RegisterNetEvent("svrMeeting:stopMeeting")
AddEventHandler("svrMeeting:stopMeeting", function(x, y, z, meetingHost)
    mute = false
    inProgress = false
    SetEntityCoords(GetPlayerPed(-1), a, b, c, 0, 0, 0, false)
end)

RegisterNetEvent("svrMeeting:noRestrict")
AddEventHandler("svrMeeting:noRestrict", function()
    allowed = true
    TriggerEvent('chatMessage', "^1[CADOJ]:^2 You are allowed to begin a Server Meeting.")
end)