local oldPrint = print
print = function(trash)
	oldPrint('^7[^2Kyk Private Messages^7] '..trash..'^0')
end

RegisterNetEvent('kyk_privatemessages:error')
AddEventHandler('kyk_privatemessages:error', function(err)
    TriggerEvent("chatMessage", "^7[^1Error^7]", {255,0,0}, err )
    if Config.debug then
        print('Error: '..err)
    end
end)

AddEventHandler('onClientResourceStart', function (resourceName)
    if (GetCurrentResourceName() == resourceName) then
        TriggerEvent('chat:addSuggestion', '/pm', 'Send someone a private message', {
            { name="id", help="Enter target player id." },
            { name="message", help="Enter the message." }
        })
    end
end)

AddEventHandler('onClientResourceStop', function(resourceName)
    if (GetCurrentResourceName() == resourceName) then
        TriggerEvent('chat:removeSuggestion', '/pm')
    end
end)