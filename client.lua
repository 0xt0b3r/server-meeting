local a, b, c = nil
local x, y, z = 2044.42, 4768.07, 41.0603
local allowed = false
local meetingRunning = false

Citizen.CreateThread(function()
    while true do
      Citizen.Wait(0)
      if NetworkIsSessionActive() then
        TriggerServerEvent('svrMeeting:startSyncMeeting')
        return
      end
    end
end)

RegisterNetEvent('svrMeeting:beginMeeting')
AddEventHandler('svrMeeting:beginMeeting', function()
    meetingRunning = true
    runMeeting()
end)

RegisterNetEvent('svrMeeting:endMeeting')
AddEventHandler('svrMeeting:endMeeting', function()
    meetingRunning = false
end)

RegisterNetEvent('svrMeeting:allowMeeting')
AddEventHandler('svrMeeting:allowMeeting', function()
    allowed = true
end)

Citizen.CreateThread(function()
  function runMeeting()
    a, b, c = table.unpack(GetEntityCoords(GetPlayerPed(-1), true))
    SetEntityCoords(GetPlayerPed(-1), x, y, z, 0, 0, 0, false)
    while true do
      Citizen.Wait(0)
      if meetingRunning == true then
        if not allowed then
          FreezeEntityPosition(GetPlayerPed(-1), true)
          RemoveAllPedWeapons(GetPlayerPed(-1), true)
          DisableControlAction(0, 245, true)
          DisableControlAction(0, 45, true)
          DisableControlAction(0, 249, true)
          DisableAllControlActions(1)
          DisableAllControlActions(2)
          DisableAllControlActions(3)
        end
      else
        SetEntityCoords(GetPlayerPed(-1), a, b, c, 0, 0, 0, false)
        FreezeEntityPosition(GetPlayerPed(-1), false)
        RemoveAllPedWeapons(GetPlayerPed(-1), false)
        DisableControlAction(0, 245, false)
        DisableControlAction(0, 45, false)
        DisableControlAction(0, 249, false)
        EnableAllControlActions(1)
        EnableAllControlActions(2)
        EnableAllControlActions(3)
        return
      end
    end
  end
end)
