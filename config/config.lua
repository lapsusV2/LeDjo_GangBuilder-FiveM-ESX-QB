Config = {
    Locale = 'en',

   -- ESX UNIQUEMENT, vous devez être sur esx 1.9.4 ou supérieur
    setJobField = 'metadata',                -- job ou 'metadata' si vous réglez sur 'metadata' alors le champ de travail sera libre de définir un autre travail, c'est quelque chose que les gens aiment appeler "job2"
    
    OxInventory = true,                
    QSInventory = false,               
    QBInventory = false,                

    InventoryPrefix = 'inventory',      
    
    mafiaMenu = {                       
        defaultKey = 'F6',              -- Touche pour ouvrir
        position = 'top-right',
        enabled = true,                 -- si tu ne veux pas mettre faux
    },

    commands = {
        creator = {
            name = 'creategang',           -- Commande pour crée le Gang
            restricted = 'group.admin', -- groupe qui aura accès à la commande 
        },

        deleteMafia = {
            name = 'dellgang',         -- Commande pour supprimer le Gang
            restricted = 'group.admin'  -- groupe qui aura accès à la commande 
        },

        teleportToBase = {
            name = 'tpgang',            -- Commande pour se teleporter au gang
            restricted = 'group.admin'  -- groupe qui aura accès à la commande 
        },

        findBase = {
            name = 'base',          -- Commande permettant aux joueurs de trouver leur base via gps
            enabled = true              -- en mettant ici false vous désactivez cette commande
        },

        resetMarker = {
            name = 'resetmarker',       -- Commande pour réinitialiser tous les marqueurs
            restricted = 'group.admin'  -- groupe qui aura accès à la commande 
        },

        updateCars = {
            name = 'updatevehicles',    -- commande pour mettre à jour les véhicules intégrés dans la mafia
            restricted = 'group.admin'  -- groupe qui aura accès à la commande 
        },

        newMarker = {
            name = 'newmarker',         -- commande pour ajouter plus de marqueurs
            restricted = 'group.admin', -- groupe qui aura accès à la commande 
        },


     -- esx uniquement et si vous utilisez setJobField comme metadata
        setGang = {
            name = 'setgang',           -- commande pour définir un gang, ne fonctionne que si setJobField est 'metadata'
            restricted = 'group.admin'  -- groupe qui aura accès à la commande 
        },
        
        -- esx uniquement et si vous utilisez setJobField comme metadata
        removeGang = {
            name = 'removegang',
            restricted = 'group.admin',
        },

        -- esx uniquement et si vous utilisez setJobField comme metadata
        mygang = {
            name = 'mygang',
            restricted = 'group.admin'
        }
    },

    -- si défini sur vrai, tout le monde sur le serveur qui a un mot de passe peut accéder à la cachette, l'idée derrière cela est de rendre le système plus réaliste, par exemple la police peut accéder à la cachette si elle a un mot de passe
    stashAccessEveryone = false, -- si défini sur false, seules les personnes qui ont un emploi peuvent accéder à cette cachette, encore une fois si elles ont un mot de passe


    actions = {
        freezeWhileCuffed = true
    },

    stash = {
        [1] = {10, 10},     -- [level] = {slots, kg}
        [2] = {20, 20},     -- [level] = {slots, kg}
        [3] = {30, 30},     -- [level] = {slots, kg}
        [4] = {40, 40},     -- [level] = {slots, kg}
    },

    Levels = {              -- prices for levels
        [1] = 500,          -- price for level 2 
        [2] = 1000,         -- price for level 3
        [3] = 1500          -- price for level 4 
    },

    firePlayerData = {      -- travail que ce joueur obtiendra lorsque vous le virez de gang, qbcore/shared/gangs
        job = 'unemployed', -- qb = aucun, esx = chômeur la plupart du temps
        grade = 0
    },

    TuneOptions = {
        modEngine = 3,
        modBrakes = 2,
        modTransmission = 2,
        modSuspension = 3,
        modArmor = true,
        windowTint = 1,
    
    },

    dealership = { -- seule la mafia peut voir blip et ouvrir un concessionnaire
        enable = true, -- si vous ne voulez pas cette option, mettez false ici
        blip = {
            type = 227,     -- https://docs.fivem.net/docs/game-references/blips/
            scale = 0.6,
            colour = 3,     -- https://docs.fivem.net/docs/game-references/blips/#blip-colors
            text = 'Concessionnaire illégal'
        },
        coords = vec3(499.257, -1338.011, 29.319), 
        vehiclePreview = vec4(493.756, -1332.161, 28.336, 252.884),
        unitCalculator = 'kmh'
    },

    impound = {
        blip = {
            type = 227,     -- https://docs.fivem.net/docs/game-references/blips/
            scale = 0.6,
            colour = 1,     -- https://docs.fivem.net/docs/game-references/blips/#blip-colors
            text = 'Fourrière illégale'
        },                            -- seule la mafia peut voir le blip et interagir
        coords = vec3(-465.680, -1707.112, 18.811),
        spawn = vec3(-456.535, -1706.918, 18.819),  

    },

    ImpoundPrices = {
    
        [0] = 300, -- Compacts
        [1] = 500, -- Sedans
        [2] = 500, -- SUVs
        [3] = 800, -- Coupes
        [4] = 1200, -- Muscle
        [5] = 800, -- Sports Classics
        [6] = 1500, -- Sports
        [7] = 2500, -- Super
        [8] = 300, -- Motorcycles
        [9] = 500, -- Off-road
        [10] = 1000, -- Industrial
        [11] = 500, -- Utility
        [12] = 600, -- Vans
        [13] = 100, -- Cylces
        [14] = 2800, -- Boats
        [15] = 3500, -- Helicopters
        [16] = 3800, -- Planes
        [17] = 500, -- Service
        [18] = 0, -- Emergency
        [19] = 100, -- Military
        [20] = 1500, -- Commercial
        [21] = 0 -- Trains (lol)
    }
}