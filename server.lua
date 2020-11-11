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
	if target == 0 then
		return false
	end

	if message == "" then --[[ Check to prevent empty messages ]]
		TriggerClientEvent('kyk_privatemessages:error', source, 'Message can\'t be empty ')
		if (Config.chatOnly == false) then
			TriggerClientEvent('kyk_privatemessages:SendAlert', target, { type = 'error', text = 'Message can\'t be empty' })
		end
		return
	elseif (GetPlayerName(tonumber(target)) == nil or GetPlayerPing(target) == 0) then --[[ Check if player has ping if not then his not online if he is then wtf how does he have 0 ping]]
		TriggerClientEvent('kyk_privatemessages:error', source, 'Invalid Target!')
		if (Config.chatOnly == false) then
			TriggerClientEvent('kyk_privatemessages:SendAlert', target, { type = 'error', text = 'Invalid Target!' })
		end
		return
	elseif (target == source) then
		TriggerClientEvent('kyk_privatemessages:error', source, 'Listen here. You are not supposed to send urself private messages!')
		if Config.screenMessages then
			TriggerClientEvent('kyk_privatemessages:SendAlert', target, { type = 'error', text = 'Listen here. You are not supposed to send urself private messages!' })
		end
		return
	else
		messagesSent = messagesSent + 1
		if (source == 0) then --[[ If the source was console then you will not be able to reply to it. ]]
			print('Message Sent To ^1'..GetPlayerName(target))
			if not Config.disableChat then
				TriggerClientEvent('chat:addMessage', args[1], { args = { '^7[^2Message Recieved From ^1^*Console^r^7]: '..message }, color = 255,255,255 })
			end
			if Config.screenMessages then
				TriggerClientEvent('kyk_privatemessages:SendAlert', target, { type = 'inform', text = 'Private Message Recieved<br>Sender: Console<br><br>Message: '..message })
			end
		else
			TriggerClientEvent('kyk_privatemessages:lastSender', target, tonumber(source))
			--[[ Source(sender) stuff ]]
			TriggerClientEvent('chat:addMessage', source, { args = { '^7^2Private Message Sent To ^1^*'..GetPlayerName(target)..' (ID: '..tonumber(target)..')^r^7' }, color = 255,255,255 })
			if Config.screenMessages then
				TriggerClientEvent('kyk_privatemessages:SendAlert', source, { type = 'success', text = 'Message sent to: '..GetPlayerName(target)..' (ID: '..tonumber(target)..')'..' successfully.' })
			end

			--[[ Reciever(target) stuff ]]
			TriggerClientEvent('chat:addMessage', target, { args = { '^7^*[^2Message Recieved From ^1'..GetPlayerName(tonumber(source))..' (ID: '..tonumber(source)..')^r^7]: '..message }, color = 255,255,255 })
			if Config.screenMessages then
				TriggerClientEvent('kyk_privatemessages:SendAlert', target, { type = 'inform', text = 'Private Message Recieved<br>Sender: '..GetPlayerName(source)..' (ID: '..tonumber(source)..')<br><br>Message: '..message })
			end
		end
	end
end, false)


if Config.statistics then
	RegisterCommand("pmStats", function(source, args, rawCommand) --[[ Statistics Command ]]
		if (source == 0) then
			print('---Private Message Statistics---')
			print('Private Messages Sent: ^1'..messagesSent)
			print('Replys Sent: ^1'..replys)
			print('------')
		else
			TriggerClientEvent("chat:addMessage", source, {
				color = {255, 255, 255},
				multiline = true,
				args = { '[^2Private Message Statistics^7]\n- PMs Sent: ^1'..messagesSent..'^7\n- Replys Sent: ^1'..replys..'^1' }
			})
		end
		
	end, true)
end


--[[ Check for updates system ( Update code gotten from EasyAdmin version checker) ]]
if Config.checkForUpdates then
	local version = '1.0'
	local resourceName = "Kyk-PrivateMessages ("..GetCurrentResourceName()..")"
	
	Citizen.CreateThread(function()
		function checkVersion(err,response, headers)
			if err == 200 then
				local data = json.decode(response)
				if version ~= data.privateMessagesVersion and tonumber(version) < tonumber(data.privateMessagesVersion) then
					print(""..resourceName.." ~r~is outdated.\nNewest Version: "..data.privateMessagesVersion.."\nYour Version: "..version.."\nPlease get the latest update from https://github.com/JeesusKrisostoomus/Kyk-PrivateMessages")
				elseif tonumber(version) > tonumber(data.privateMessagesVersion) then
					print("Your version of "..resourceName.." seems to be higher than the current version.")
				else
					print(resourceName.. " is up to date!")
				end
			else
				print("Version Check failed! HTTP Error Code: "..err)
			end
			
			SetTimeout(3600000, checkVersionHTTPRequest) --[[ Makes the version check repeat every 1h ]]
		end
		function checkVersionHTTPRequest() --[[ Registers checkVersionHTTPRequest function ]]
			PerformHttpRequest("https://raw.githubusercontent.com/JeesusKrisostoomus/Kyk-Releases/main/versions.json", checkVersion, "GET") --[[ Sends GET http requests ]]
		end
		checkVersionHTTPRequest() --[[ Calls checkVersionHTTPRequest function ]]
	end)
end


--[[
	Registered Events
]]
RegisterNetEvent('kyk_privatemessages:reply')
AddEventHandler('kyk_privatemessages:reply', function(lastSender, args)
	local message = table.concat(args, " ", 1)

	TriggerClientEvent('kyk_privatemessages:lastSender', lastSender, tonumber(source))

	--[[ Source stuff ]]
	TriggerClientEvent('chat:addMessage', source, { args = { '^7^2Reply Sent to ^1'..GetPlayerName(lastSender) }, color = 255,255,255 })
	if Config.screenMessages then
		TriggerClientEvent('kyk_privatemessages:SendAlert', source, { type = 'success', text = 'Reply sent to: '..GetPlayerName(target)..' (ID: '..tonumber(target)..')'..' successfully.' })
	end

	--[[ Reciever stuff ]]
	TriggerClientEvent('chat:addMessage', lastSender, { args = { '^7[^2Message Recieved From ^1'..GetPlayerName(tonumber(source))..'^7]: '..message }, color = 255,255,255 })
	if Config.screenMessages then
		TriggerClientEvent('kyk_privatemessages:SendAlert', target, { type = 'inform', text = 'Private Message Recieved<br>Sender: '..GetPlayerName(source)..' (ID: '..tonumber(source)..')<br><br>Message: '..message })
	end

	replys = replys + 1
end)


AddEventHandler('onResourceStart', function(resourceName)
	if (GetCurrentResourceName() == resourceName) then
		if (Config.disableChat == true and Config.screenMessages == false) then
			print('Both "Chat Private Messages" and "Screen Private Messages" were disabled.\nForcing Chat Messages on')
			Config.disableChat = false
		end
	end
end)