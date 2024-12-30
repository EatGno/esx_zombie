Config = {}

-- Paramètres généraux des zombies
Config.ZombieModels = {"u_m_y_zombie_01", "a_m_y_zombie_01", "a_m_m_zombie_01"} -- Modèles de zombies
Config.ZombieHealth = 100
Config.ZombieDamage = 25
Config.ZombieSpeed = 1.0

-- Paramètres de détection et d'agression
Config.AggroRange = 50.0   -- Distance à laquelle les zombies commencent à poursuivre un joueur
Config.VisionRange = 40.0  -- Distance à laquelle les zombies peuvent voir les joueurs
Config.NoiseRange = 30.0   -- Distance à laquelle les zombies entendent un bruit

-- Paramètres d'infection
Config.InfectionChance = 50 -- Chance en % d'infecter un joueur lors d'un contact avec un zombie
Config.InfectionTime = 300  -- Temps (en secondes) avant que l'infection tue le joueur

-- Paramètres de spawn des zombies
Config.SpawnRadius = 500.0  -- Rayon dans lequel les zombies peuvent apparaître autour de la position actuelle
Config.SpawnInterval = 60   -- Intervalle en secondes pour la réapparition des zombies

-- Limites de la carte
Config.MapBounds = {
    minX = -3000.0, minY = -3000.0, minZ = 0.0,
    maxX = 3000.0, maxY = 3000.0, maxZ = 1000.0
}
