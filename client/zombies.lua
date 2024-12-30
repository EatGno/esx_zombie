local zombies = {}
local playerPed = PlayerPedId()

-- Fonction pour créer un zombie aléatoirement
function SpawnZombie()
    local spawnX = math.random(Config.MapBounds.minX, Config.MapBounds.maxX)
    local spawnY = math.random(Config.MapBounds.minY, Config.MapBounds.maxY)
    local spawnZ = math.random(Config.MapBounds.minZ, Config.MapBounds.maxZ)

    local model = GetHashKey(Config.ZombieModels[math.random(#Config.ZombieModels)])
    RequestModel(model)
    while not HasModelLoaded(model) do
        Wait(10)
    end

    -- Crée le zombie à la position spécifiée
    local zombie = CreatePed(4, model, spawnX, spawnY, spawnZ, 0.0, true, false)
    SetPedCanRagdoll(zombie, false)
    SetEntityHealth(zombie, Config.ZombieHealth)
    SetPedConfigFlag(zombie, 281, true) -- Le zombie ne fuit pas
    SetPedRelationshipGroupHash(zombie, GetHashKey("zombies"))
    TaskWanderStandard(zombie, 10.0, 10)

    -- Ajoute le zombie à la liste des zombies actifs
    table.insert(zombies, zombie)
end

-- Mise à jour des zombies
CreateThread(function()
    while true do
        Wait(1000)  -- Vérifie tous les 1 seconde

        -- Crée des zombies à intervalles réguliers
        if math.random() < 1 / Config.SpawnInterval then
            SpawnZombie()
        end

        local playerCoords = GetEntityCoords(playerPed)

        for _, zombie in ipairs(zombies) do
            if DoesEntityExist(zombie) and not IsEntityDead(zombie) then
                local zombieCoords = GetEntityCoords(zombie)
                local distanceToPlayer = #(playerCoords - zombieCoords)

                -- Si le zombie est dans le rayon d'aggro, il poursuit le joueur
                if distanceToPlayer <= Config.AggroRange then
                    if distanceToPlayer <= 2.0 then
                        -- Si le zombie est proche du joueur, il attaque
                        TaskCombatPed(zombie, playerPed, 0, 16)
                        ApplyDamageToPed(playerPed, Config.ZombieDamage, false)
                    else
                        -- Si le zombie est à une distance raisonnable, il poursuit
                        TaskGoToEntity(zombie, playerPed, -1, 1.0, 2.0, 0, 0)
                    end
                else
                    -- Sinon, le zombie erre autour de sa position
                    TaskWanderStandard(zombie, 10.0, 10)
                end

                -- Vérifie si un tir a eu lieu à proximité et si le zombie peut entendre
                if IsPedShooting(playerPed) then
                    local shotCoords = GetEntityCoords(playerPed)
                    if #(shotCoords - zombieCoords) <= Config.NoiseRange then
                        TaskGoToEntity(zombie, playerPed, -1, 1.5, 2.0, 0, 0)
                    end
                end
            else
                -- Supprime les zombies morts de la liste
                table.remove(zombies, _)
            end
        end
    end
end)

-- Infection des joueurs
AddEventHandler('zombie:infectPlayer', function()
    local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer then
        -- Simulation de l'infection
        TriggerClientEvent('chat:addMessage', source, {args = {"Zombies", "Vous avez été infecté par un zombie!"}})
        
        -- Attendre que l'infection dure avant la mort du joueur
        Citizen.SetTimeout(Config.InfectionTime * 1000, function()
            TriggerClientEvent('zombie:death', source)
        end)
    end
end)

-- Supprimer un joueur en cas de mort due à l'infection
RegisterServerEvent('zombie:death')
AddEventHandler('zombie:death', function()
    local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer then
        xPlayer.setHealth(0) -- Le joueur meurt
        TriggerClientEvent('chat:addMessage', -1, {args = {"Zombies", "Le joueur " .. GetPlayerName(source) .. " est mort de l'infection!"}})
    end
end)
