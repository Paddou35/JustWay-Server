Config = {
    Blip = true, -- Affichage du blip (true = oui, false = non)
    
    MarkerType = -1, -- Pour voir les différents type de marker: https://docs.fivem.net/docs/game-references/markers/
    MarkerSizeLargeur = 1.0, -- Largeur du marker
    MarkerSizeEpaisseur = 1.0, -- Épaisseur du marker
    MarkerSizeHauteur = 1.0, -- Hauteur du marker
    MarkerDistance = 15.0, -- Distane de visibiliter du marker (1.0 = 1 mètre)
    MarkerOpacite = 150, -- Opacité du marker (min: 0, max: 255)
    MarkerSaute = false, -- Si le marker saute (true = oui, false = non)
    MarkerTourne = true, -- Si le marker tourne (true = oui, false = non)
    OldESXSyst = false, -- Use old ESX ShareObject system (Before version 1.9)

    Positions = { -- Position du menu astuce sur la map
        PED = { -- Points d'apparition du PED Garagiste
            {pedorient = vector4(-349.25, -874.90, 30.33, 88.30), spawnpoint = vector3(-349.25, -874.90, 30.33), garageID = 'A'}, -- PC
            {pedorient = vector4(1036.47, -763.31, 57.00, 240.55), spawnpoint = vector3(1036.47, -763.31, 57.00), garageID = 'B'}, -- Mirror Park
            {pedorient = vector4(-1585.59, -1058.15, 12.03, 5.06), spawnpoint = vector3(-1585.59, -1058.15, 12.03), garageID = 'C'}, -- Del Pero
            {pedorient = vector4(596.91, 91.40, 92.14, 250.40), spawnpoint = vector3(596.91, 91.40, 92.14), garageID = 'D'}, -- Vinehood
            {pedorient = vector4(1529.04, 3778.58, 33.52, 215.55), spawnpoint = vector3(1529.04, 3778.58, 33.52), garageID = 'E'}, -- Sandy Shore
            {pedorient = vector4(83.66, 6420.55, 30.77, 312.81), spawnpoint = vector3(83.66, 6420.55, 30.77), garageID = 'F'}, -- Paleto
        },
        Garage = { -- Points de spawn du véhicule
            {spawnzone = vector3(-353.23, -875.05, 31.07), heading = 350.00}, -- PC
            {spawnzone = vector3(1039.79, -769.65, 58.02), heading = 350.00}, -- Mirror Park
            {spawnzone = vector3(-1579.52, -1054.20, 13.02), heading = 78.00}, -- Del Pero
            {spawnzone = vector3(596.42, 84.76, 92.80), heading = 254.00}, -- Vinehood
            {spawnzone = vector3(1536.52, 3770.17, 34.05), heading = 122.00}, -- Sandy Shore
            {spawnzone = vector3(88.14, 6424.80, 31.37), heading = 48.00}, -- Paleto
        },
        Pound = { -- Fourrière
            vector3(415.61, -1632.47, 29.29), 
        },
        Return = { -- Dépose véhicule
            {returnzone = vector3(-343.79, -876.28, 30.08), garageID = 'A'}, -- PC
            {returnzone = vector3(1028.69, -763.65, 57.00), garageID = 'B'}, -- Mirror Park
            {returnzone = vector3(-1589.35, -1056.20, 12.03), garageID = 'C'}, -- Del Pero
            {returnzone = vector3(599.04, 98.30, 91.92), garageID = 'D'}, -- Vinehood
            {returnzone = vector3(1517.20, 3763.05, 33.06), garageID = 'E'}, -- Sandy Shore
            {returnzone = vector3(72.28, 6403.77, 30.25), garageID = 'F'}, -- Paleto
        }
    }
}