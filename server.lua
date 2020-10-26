local oldPrint = print
print = function(trash)
	oldPrint('^7[^2Kyk Private Messages^7] '..trash..'^0')
end

--[[ Create the /pm (id) (message) command ]]
RegisterCommand("pm", function(source, args, rawCommand)
	local target = tonumber(args[1])
	local message = table.concat(args, " ",2)
	local targetPing = GetPlayerPing(target)

	if message == "" then --[[ Check to prevent empty messages ]]
		TriggerClientEvent('kyk_privatemessages:error', source, 'Message can\'t be empty ')
		return
	elseif (targetPing == 0 or target == source) then --[[ Check if player has ping if not then his not online if he is then wtf how does he have 0 ping]]
		TriggerClientEvent('kyk_privatemessages:error', source, 'Invalid Target!')
		return
	else
		TriggerClientEvent('chat:addMessage', source, { args = { '^7[^2Message Sent To ^1'..GetPlayerName(target)..'^7]: '..message }, color = 255,255,255 })
		TriggerClientEvent('chat:addMessage', args[1], { args = { '^7[^2Message Recieved From ^1'..GetPlayerName(tonumber(source))..'^7]: '..message }, color = 255,255,255 })
	end
	if Config.debug then
		print('Source ID: '..tonumber(source))
		print('Target ID: '..tonumber(args[1]))
		print('Target Ping: '..targetPing)
		print('Message: '..message)
	end
end, false)