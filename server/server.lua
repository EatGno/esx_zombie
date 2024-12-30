ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

-- Lorsqu'un zombie attaque un joueur, il y a une chance d'infection
RegisterServerEvent('zombie:infectPlayer')
AddEventHandler('zombie:infectPlayer', function()
    local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer then
        -- Vérifie si l'attaque a une chance d'infecter
        if math.random(1, 100) <= Config.InfectionChance then
            TriggerClientEvent('zombie:infectPlayer', source)
        end
    end
end)

-- Déclenche une notification de mort d'un joueur
RegisterServerEvent('zombie:death')
AddEventHandler('zombie:death', function()
    local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer then
        xPlayer.setHealth(0) -- Le joueur meurt après l'infection
        TriggerClientEvent('chat:addMessage', -1, {args = {"Zombies", "Le joueur " .. GetPlayerName(source) .. " est mort de l'infection!"}})
    end
end)
