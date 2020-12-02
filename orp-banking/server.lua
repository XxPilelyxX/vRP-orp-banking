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
		TriggerClientEvent('orp:bank:notify', source, "error", "Ugyldig værdi")
	else
		vRP.tryDeposit({user_id, tonumber(amount)})
		TriggerClientEvent('orp:bank:notify', source, "success", "Du indsatte " .. amount.."DKK")
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
		TriggerClientEvent('orp:bank:notify', source, "error", "Ugyldig værdi")
	else
		vRP.tryWithdraw({user_id,amount})
		TriggerClientEvent('orp:bank:notify', source, "success", "Du hævede " .. amount.."DKK")
	end
end)

RegisterServerEvent('orp:bank:balance')
AddEventHandler('orp:bank:balance', function()
	
	local source = source
	local user_id = vRP.getUserId({source})
	balance = vRP.getBankMoney({user_id})
	TriggerClientEvent('orp:bank:info', source, balance)
end)

RegisterServerEvent('orp:bank:transfer')
AddEventHandler('orp:bank:transfer', function(datainfo)
	local _source = source
	local xTarget = tonumber(datainfo.to)
	local xPlayer = vRP.getUserId({_source})
	local amount = datainfo.amountt
	local balance = 0

	if xTarget == nil then
		TriggerClientEvent('orp:bank:notify', _source, "error", "IDet ikke fundet")
	elseif xTarget == xPlayer then
		TriggerClientEvent('orp:bank:notify', _source, "error", "Du kan ikke overføre til dig selv")
	else
		balance = vRP.getBankMoney({xPlayer})
		zbalance = vRP.getBankMoney({xTarget})
		
		if balance <= 0 or balance < tonumber(amount) or tonumber(amount) <= 0 then
			TriggerClientEvent('orp:bank:notify', _source, "error", "Du har ikke nok penge til at overføre dette beløb")
		else
			vRP.setBankMoney({xPlayer, balance-tonumber(amount)})
			vRP.giveBankMoney({xTarget, tonumber(amount)})
			TriggerClientEvent('orp:bank:notify', _source, "success", "Du overførte nu " .. amount.."DKK")
			TriggerClientEvent('orp:bank:notify', xTarget, "success", "Du modtog lige " .. amount .. 'DKK via hævede')
		end
	end
end)
