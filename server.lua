local permitted = {}

-- function for disabling voie chat later.
local meetingActive = false
local x, y, z = nil

-- Register the command
RegisterCommand('meeting', function(source, args, rawCommand)
	for i=0, #permitted do
		if source == permitted[i] then
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
	end
end)

RegisterNetEvent('svrMeeting:startSyncMeeting')
AddEventHandler('svrMeeting:startSyncMeeting', function()
	if IsPlayerAceAllowed(source, 'lance.meeting') then
		table.insert(permitted, source)
		TriggerClientEvent('svrMeeting:allowMeeting', source)
		
		TriggerClientEvent('chatMessage', source, "^1[SERVER]:^1 You are permitted to begin a server meeting.")
	end
	TriggerClientEvent('svrMeeting:allowedMeeting', -1)
end)

RegisterNetEvent('svrMeeting:endSyncMeeting')
AddEventHandler('svrMeeting:endSyncMeeting', function()
end)