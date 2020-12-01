local Tunnel = module("vrp", "lib/Tunnel")
local Proxy = module("vrp", "lib/Proxy")
MySQL = module("vrp_mysql", "MySQL")

vRP = Proxy.getInterface("vRP")
vRPclient = Tunnel.getInterface("vRP","orp_banking")

RegisterServerEvent('orp:bank:deposit')
AddEventHandler('orp:bank:deposit', function(amount)
    local source = source
	
	local user_id = vRP.getUserId({source})
	if amount == nil or amount <= 0 or amount > vRP.getBankMoney({user_id}) then
		TriggerClientEvent('orp:bank:notify', source, "error", "Invalid Amount")
	else
		vRP.tryDeposit({user_id, tonumber(amount)})
		TriggerClientEvent('orp:bank:notify', source, "success", "You successfully deposit $" .. amount)
	end
end)

RegisterServerEvent('orp:bank:withdraw')
AddEventHandler('orp:bank:withdraw', function(amount)
	local source = source
	local user_id = vRP.getUserId({source})
	local min = 0
	amount = tonumber(amount)
	min = vRP.getBankMoney({user_id})
	if amount == nil or amount <= 0 or amount > min then
		TriggerClientEvent('orp:bank:notify', source, "error", "Invalid Amount")
	else
		vRP.tryWithdraw({user_id,amount})
		TriggerClientEvent('orp:bank:notify', source, "success", "You successfully withdraw $" .. amount)
	end
end)

RegisterServerEvent('orp:bank:balance')
AddEventHandler('orp:bank:balance', function()
	
	local _source = source
	local user_id = vRP.getUserId({user_id})
	balance = vRP.getBankMoney({user_id})
	TriggerClientEvent('orp:bank:info', _source, balance)
end)

RegisterServerEvent('orp:bank:transfer')
AddEventHandler('orp:bank:transfer', function(to, amountt)
	local _source = source
	local xPlayer = vRP.getUserId({_source})
	local xTarget = vRP.getUserId({to})
	local amount = amountt
	local balance = 0

	if(xTarget == nil or xTarget == -1) then
		TriggerClientEvent('orp:bank:notify', _source, "error", "Recipient not found")
	else
		balance = vRP.getBankMoney({xPlayer})
		zbalance = vRP.getBankMoney({xTarget})
		
		if tonumber(_source) == tonumber(to) then
			TriggerClientEvent('orp:bank:notify', _source, "error", "You cannot transfer money to yourself")
		else
			if balance <= 0 or balance < tonumber(amount) or tonumber(amount) <= 0 then
				TriggerClientEvent('orp:bank:notify', _source, "error", "You don't have enough money for this transfer")
			else
				vRP.setBankMoney({xPlayer, balance-tonumber(amount)})
				vRP.giveBankMoney({xTarget, tonumber(amount)})
				TriggerClientEvent('orp:bank:notify', _source, "success", "You successfully transfer $" .. amount)
				TriggerClientEvent('orp:bank:notify', to, "success", "You have just received $" .. amount .. ' via transfer')
			end
		end
	end
end)