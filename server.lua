local oldPrint = print
print = function(trash)
	oldPrint('^7[^2Kyk Private Messages^7] '..trash..'^0')
end

local messagesSent = 0
local replys = 0

--[[
	Registered Commands
]]

--[[ Create the /pm (id) (message) command ]]
RegisterCommand("pm", function(source, args, rawCommand)
	local target = tonumber(args[1])
	local message = table.concat(args, " ",2)
	local targetPing = GetPlayerPing(target)

	if message == "" then --[[ Check to prevent empty messages ]]
		TriggerClientEvent('kyk_privatemessages:error', source, 'Message can\'t be empty ')
		return
	--elseif (targetPing == 0 or target == source) then --[[ Check if player has ping if not then his not online if he is then wtf how does he have 0 ping]]
	--	TriggerClientEvent('kyk_privatemessages:error', source, 'Invalid Target!')
	--	return
	else
		messagesSent = messagesSent + 1
		if (source == 0) then --[[ If the source was console then you will not be able to reply to it. ]]
			print('Message Sent To ^1'..GetPlayerName(target))
			TriggerClientEvent('chat:addMessage', args[1], { args = { '^7[^2Message Recieved From ^1 Console^7]: '..message }, color = 255,255,255 })
		else
			TriggerClientEvent('kyk_privatemessages:lastSender', target, tonumber(target))
			TriggerClientEvent('chat:addMessage', source, { args = { '^7[^2Message Sent To ^1'..GetPlayerName(tonumber(target))..' (ID: '..tonumber(target)..'^7]: '..message }, color = 255,255,255 })
			TriggerClientEvent('chat:addMessage', args[1], { args = { '^7[^2Message Recieved From ^1'..GetPlayerName(tonumber(source))..' (ID: '..tonumber(source)..')^7]: '..message }, color = 255,255,255 })
		end
	end
end, false)

if Config.statistics then
	RegisterCommand("pmStats", function(source, args, rawCommand) --[[ Statistics Command ]]
		if (source == 0) then
			print('---Private Message Statistics---')
			print('Private Messages Sent: '..messagesSent)
			print('------')
		else
			statsMessage1 = '[^2Private Message Statistics^7]'
			statsMessage2 = 'PMs Sent: ^1'..messagesSent
			statsMessage3 = 'Replys Sent: ^1'..replys
			TriggerClientEvent('chat:addMessage', source, { args = { statsMessage1 }, color = 255,255,255 })
			TriggerClientEvent('chat:addMessage', source, { args = { statsMessage2 }, color = 255,255,255 })
			TriggerClientEvent('chat:addMessage', source, { args = { statsMessage3 }, color = 255,255,255 })

		end
		
	end, true)
end


--[[
	Registered Events
]]
RegisterNetEvent('kyk_privatemessages:reply')
AddEventHandler('kyk_privatemessages:reply', function(lastSender, args)
	local message = table.concat(args, " ", 1)

	TriggerClientEvent('chat:addMessage', source, { args = { '^7[^2Reply Sent to ^1'..GetPlayerName(lastSender)..']' }, color = 255,255,255 })
	TriggerClientEvent('chat:addMessage', lastSender, { args = { '^7[^2Message Recieved From ^1'..GetPlayerName(tonumber(source))..'^7]: '..message }, color = 255,255,255 })
	replys = replys + 1
end)
