Discord = {

    url = 'https://discord.gg/nKVQW5Q5js',
    title = 'LeDjo_Developpement',

    /*
        https://www.spycolor.com/

        ['default'] = 14423100,
        ['blue'] = 255,
        ['red'] = 16711680,
        ['green'] = 65280,
        ['white'] = 16777215,
        ['black'] = 0,
        ['orange'] = 16744192,
        ['yellow'] = 16776960,
        ['pink'] = 16761035,
        ['lightgreen'] = 65309,
    */

    color = 65309, -- green

    imageUrl = 'https://cdn.discordapp.com/attachments/1090026904326783039/1106650807656521779/Sans_titre_960_960_px.png', 


    TagEveryoneFields = {               -- ici vous pouvez gérer quel journal doit/ou ne pas taguer @everyone
        mafiaCreating = false,          -- lorsque la mafia est créée par l'administrateur
        levelUp = false,                -- lorsque les joueurs montent leur mafia
        firePeopleOnline = false,       -- lorsque les joueurs renvoient des personnes de la mafia qui sont en ligne
        firePeopleOffline = false,      -- lorsque les joueurs renvoient des personnes de la mafia qui sont hors ligne
        firePeopleCheater = true,       -- quand quelqu'un essaie de virer des gens de la mafia sans grade de patron
        hire = false,                   -- lorsque le patron embauche de nouvelles personnes
        hireCheater = true,             -- quand quelqu'un qui n'a pas de grade de patron essaie d'embaucher par triche
        eventCheck = true  ,            -- lorsque tente d'exécuter l'événement via l'exécuteur
        updateGradeCheater = true,      -- quand quelqu'un essaie de mettre à jour la note pour les joueurs qui n'ont pas de boss
        updateGradeOnline = false,      -- lorsque la note est mise à jour pour les joueurs
        moneyWithdraw = false,          -- lorsque l'argent est retiré de la mafia
        moneyDeposit = false,           -- lorsque l'argent est déposé dans la mafia
        vehicleBuy = false,             -- achat de véhicule
        deleteVehicles = false,         -- lorsque l'administrateur supprime le véhicule intégré de la mafia
        newVehicle = false,             -- lorsqu'un nouveau véhicule est ajouté par l'administrateur
        updateBoss = false,             -- lorsque le marqueur de menu du patron est mis à jour via la commande
        vehicleMarker = false,          -- lorsque le marqueur de véhicule est mis à jour via la commande
        heliMarker = false,             -- when helicopter marker is updated via command
        lvl = false,                    -- lorsque le marqueur d'hélicoptère est mis à jour via la commande
        stashUpdate = false,            -- lorsque la position de la cachette est mise à jour via la commande
    }
}

function GiveCarKeys(src, plate)
    TriggerClientEvent('vehiclekeys:client:SetOwner', src, plate)
end