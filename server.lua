local meetingActive = false
local x, y, z = nil

-- Register the command
RegisterCommand('meeting', function(source, args, rawCommand)
	if isAdmin(source) then
		if args[1] == "start" then
			local countdown = args[2]
			TriggerClientEvent('chatMessage', -1, "^1[SERVER]: A Server Meeting will begin in ".. countdown .." seconds.")
			SetTimeout(countdown * 1000, function()
				TriggerClientEvent('svrMeeting:beginMeeting', -1)
			end)
		elseif args[1] == "stop" then
			TriggerClientEvent('svrMeeting:endMeeting', -1)
		end
	end
end)

RegisterNetEvent('svrMeeting:startSyncMeeting')
AddEventHandler('svrMeeting:startSyncMeeting', function()
	if isAdmin(source) then
		TriggerClientEvent('svrMeeting:allowMeeting', source)
		TriggerClientEvent('chatMessage', source, "^1[SERVER]:^1 You are permitted to begin a server meeting.")
	end
end)

RegisterNetEvent('svrMeeting:endSyncMeeting')
AddEventHandler('svrMeeting:endSyncMeeting', function()
end)

function isAdmin(source)
    local allowed = false
    for i,id in ipairs(admins) do
        for x,pid in ipairs(GetPlayerIdentifiers(source)) do
            if string.lower(pid) == string.lower(id) then
                allowed = true
            end
        end
	end
	if IsPlayerAceAllowed(source, "lance.meeting") then
		allowed = true
	end
    return allowed
end
