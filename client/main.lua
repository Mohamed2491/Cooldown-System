local Cooldown = "00:00"

RegisterNetEvent('QBCore:Client:OnPlayerLoaded', function()
    lib.callback("easy-cooldown:server:getconfig", function(newconfig)
        Config = newconfig
    end)
end)

RegisterNetEvent('esx:playerLoaded', function()
    lib.callback("easy-cooldown:server:getconfig", function(newconfig)
    Config = newconfig
    end)
end)

RegisterNetEvent("easy-cooldown:client:updateconfig", function(newconfig)
    Config = newconfig
end)

CreateThread(function()
    while true do 
        if Config.CurrentCooldown > 0 then 
            local seconds = Config.CurrentCooldown
            local mins = string.format("%02.f", math.floor(seconds / 60))
            local secs = string.format("%02.f", math.floor(seconds - mins * 60))
            Cooldown = mins..":"..secs
            Config.CurrentCooldown = Config.CurrentCooldown - 1
            if mins == "00" and secs == "01" then
                Config.CurrentCooldown = 0
                Config.CurrentType = "inactive" 
            end
        end
        SendNUIMessage({
            action = "showstatus",
            type = Config.CurrentType,
            active = Config.Types[Config.CurrentType],
            cooldown = Cooldown,
        })
        Wait(1000)
    end
end)

RegisterNetEvent("Cooldownmenu", function()
    lib.registerContext({
        id = 'cooldown_menu',
        title = locale('cooldown.menu.title'),
        options = {
          {
            title = locale('cooldown.start.title'),
            icon = 'fa-solid fa-play',
            description = locale('cooldown.start.description'),
            event = 'easy-cooldownInput',
            args = { someArg = 'value1' }
          },
          {
              title = locale('cooldown.remove.title'),
              icon = 'fa-solid fa-stop',
              description = locale('cooldown.remove.description'),
              event = 'easy-removeCooldown',
              args = { someArg = 'value1' }
            },
    
        }
      })
      lib.showContext('cooldown_menu')
end)

RegisterCommand(Config.Command, function()
    local PlayerData = exports.qbx_core:GetPlayerData()
    local PlayerJob = PlayerData.job.name
    local PlayerDuty = PlayerData.job.onduty
    if (PlayerJob == "police" or PlayerJob == "sheriff") and PlayerDuty then 
        TriggerEvent("Cooldownmenu")
    else
        lib.notify({ title = locale('error.title'), description = "Not Authorized!", type = "error" })
    end   
end)

RegisterNetEvent("easy-cooldownInput")
AddEventHandler("easy-cooldownInput", function()
    local dialog = lib.inputDialog("Enter Cooldown", {
        { 
            type = 'number', 
            label = locale('input.title'), 
            icon = 'clock', 
            required = true, 
            name = 'cooldown' 
        }
    })

    if dialog then
        local inputNumber = tonumber(dialog[1]) -- Access the first entry in the dialog table
        if inputNumber then
            -- Send the input to the server for this specific player
            TriggerServerEvent("easy-cooldown:server:receiveInput", inputNumber)
        else
            lib.notify({ title = locale('input.error'), description = locale('input.error.description'), type = "error" })
        end
    else
        lib.notify({ title = locale('error.title'), description = locale('error.description'), type = "error" })
    end
end)

RegisterNetEvent("easy-removeCooldown")
AddEventHandler("easy-removeCooldown", function()
    Config.CurrentCooldown = 0
    Config.CurrentType = "inactive"
    SendNUIMessage({
        action = "showstatus",
        type = Config.CurrentType,
        active = Config.Types[Config.CurrentType],
        cooldown = Cooldown,
    })
    TriggerServerEvent("easy-cooldown:server:removeCooldown")
end)