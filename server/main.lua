local Cooldown = false

-- Create a thread to manage cooldown timing
CreateThread(function()
    while true do 
        if Cooldown and Config.CurrentCooldown > 0 then 
            Config.CurrentCooldown = Config.CurrentCooldown - 1
            if Config.CurrentCooldown <= 0 then
                Cooldown = false
                Config.CurrentType = "inactive"
            end
        end
        -- Broadcast the current state to all clients every second
        TriggerClientEvent("easy-cooldown:client:updateconfig", -1, Config)
        Wait(1000)
    end      
end)

-- Callback to get current config
lib.callback.register("easy-cooldown:server:getconfig", function(source, cb)
    cb(Config)
end)

-- Event to set the priority type and manage cooldown state
RegisterNetEvent("easy-cooldown:server:setprio")
AddEventHandler("easy-cooldown:server:setprio", function(ptype)
    Config.CurrentType = ptype
    if ptype == "cooldown" then 
        Cooldown = true
        -- Only trigger the cooldown input for the player who requested it
        TriggerClientEvent("easy-cooldownInput", source)
        
    elseif ptype == "inactive" then 
        Cooldown = false
        Config.CurrentCooldown = 0
    end
    -- Broadcast the updated state immediately
    TriggerClientEvent("easy-cooldown:client:updateconfig", -1, Config)
end)

RegisterNetEvent("easy-cooldown:server:receiveInput")
AddEventHandler("easy-cooldown:server:receiveInput", function(inputText)
    local source = source
    local inputNumber = tonumber(inputText)
    if inputNumber ~= nil and inputNumber > 0 then
        -- Process the valid input number
        Config.CurrentCooldown = inputNumber * 60 -- assuming input is in minutes
        Config.CurrentType = "cooldown" -- Ensure the type is set to cooldown
        Cooldown = true -- Set the Cooldown flag
        -- Broadcast the updated state immediately
        TriggerClientEvent("easy-cooldown:client:updateconfig", -1, Config)
    else
        -- Resend the input prompt to the client
        TriggerClientEvent("easy-cooldownInput", source)
    end
end)


-- Function to check if cooldown is inactive
function isCooldownInactive()
    return not Cooldown or Config.CurrentCooldown <= 0
end

-- Export the function for use in other scripts
exports('isCooldownInactive', isCooldownInactive)

RegisterNetEvent("easy-cooldown:server:removeCooldown")
AddEventHandler("easy-cooldown:server:removeCooldown", function()
    Config.CurrentCooldown = 0
    Config.CurrentType = "inactive"
    Cooldown = false
    -- Broadcast the updated state immediately
    TriggerClientEvent("easy-cooldown:client:updateconfig", -1, Config)
end)

lib.callback.register("easy-cooldown:server:isCooldownInactive", function(source, cb)
    if cb then
        cb(isCooldownInactive())
    else
        print("Callback function is nil")
    end
end)