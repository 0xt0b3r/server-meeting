RegisterNetEvent("svrMeeting:beginSync")
AddEventHandler("svrMeeting:beginSync", function(meetingHost, x, y, z, countdown)
    TriggerClientEvent('chatMessage', -1, "^1[CADOJ]: ^2".. meetingHost .. "^1 is now hosting a server meeting, You will be teleported in ^2".. countdown .. " seconds.")
    SetTimeout(countdown * 1000, function()
        TriggerClientEvent("svrMeeting:beginMeeting", -1, x, y, z, meetingHost)
    end)
end)

RegisterNetEvent("svrMeeting:finalizeMeeting")
AddEventHandler("svrMeeting:finalizeMeeting", function(meetingHost)
    TriggerClientEvent('chatMessage', -1, "^1[CADOJ]: ^2".. meetingHost .. "^1 has now ended the server meeting, You may resume roleplay.")
    TriggerClientEvent('svrMeeting:stopMeeting', -1)
end)

-- Gets called when a player is fully loaded.
RegisterNetEvent("svrMeeting:playerConnected")
AddEventHandler("svrMeeting:playerConnected", function() 
    if IsPlayerAceAllowed(source, "lance.meeting") then
        TriggerClientEvent('svrMeeting:noRestrict', source)
    end
end)
