local oldPrint = print
print = function(trash)
	oldPrint('^7[^2Kyk Private Messages^7] '..trash..'^0')
end

--[[
    Variables
]]
local lastSender


--[[
    Reply Commands
]]
RegisterCommand("r", function(source, args, rawCommand) --[[ Reply Command ]]
    if lastSender == nil then
        TriggerEvent('kyk_privatemessages:error', 'You haven\'t yet gotten any private messages.')
    else
        TriggerServerEvent('kyk_privatemessages:reply', lastSender, args)
    end
end, false)
RegisterCommand("reply", function(source, args, rawCommand) --[[ Reply Command ]]
    if lastSender == nil then
        TriggerEvent('kyk_privatemessages:error', 'You haven\'t yet gotten any private messages.')
    else
        TriggerServerEvent('kyk_privatemessages:reply', lastSender, args)
    end
end, false)


--[[
    Chat Suggestions
]]
if Config.chatSuggestions then
    AddEventHandler('onClientResourceStart', function (resourceName)
        if (GetCurrentResourceName() == resourceName) then
            TriggerEvent('chat:addSuggestion', '/pm', 'Send someone a private message', {
                { name="id", help="Enter target player id." },
                { name="message", help="Enter the message." }
            })
            TriggerEvent('chat:addSuggestion', '/r', 'Reply to last private message', {
                { name="message", help="Enter the message." }
            })
            TriggerEvent('chat:addSuggestion', '/reply', 'Reply to last private message', {
                { name="message", help="Enter the message." }
            })
        end
    end)
    AddEventHandler('onClientResourceStop', function(resourceName)
        if (GetCurrentResourceName() == resourceName) then
            TriggerEvent('chat:removeSuggestion', '/pm')
            TriggerEvent('chat:removeSuggestion', '/r')
            TriggerEvent('chat:removeSuggestion', '/reply')
        end
    end)
end


--[[
    Registered Events
]]
RegisterNetEvent('kyk_privatemessages:error')
AddEventHandler('kyk_privatemessages:error', function(err)
    TriggerEvent("chatMessage", "^7[^1Error^7]", {255,0,0}, err )
end)

RegisterNetEvent('kyk_privatemessages:lastSender')
AddEventHandler('kyk_privatemessages:lastSender', function(sender)
    lastSender = sender
end)



--[[ Taken from mythic_notify (https://github.com/wowpanda/mythic_notify) ]]
RegisterNetEvent("kyk_privatemessages:SendAlert")
AddEventHandler("kyk_privatemessages:SendAlert", function(data)
	DoHudText(data.type, data.text)
end)

function DoHudText(type, text)
	SendNUIMessage({
		action = 'notif',
		type = type,
		text = text
	})
end