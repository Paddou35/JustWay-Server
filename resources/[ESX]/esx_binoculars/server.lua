--ESX INIT--
ESX = exports["es_extended"]:getSharedObject()
--SERVER EVENT--

ESX.RegisterUsableItem('jumelles', function(source) -- Consider the item as usable

	local xPlayer = ESX.GetPlayerFromId(source)

	TriggerClientEvent('jumelles:Active', source) --Trigger the event when the player is using the item

end)