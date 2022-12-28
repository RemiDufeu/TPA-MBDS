#commencons par identifier des catégories

names(catalogue)

# si on inspecte les attributs d'un véhicule certaines propriétés ne sont pas pertinentes pour l'analyse.
# on retient donc -puissance -longueur -nbplaces -nbportes

#citadine - courte et pas beaucoup de cheveaux

#sportive - beaucoup de cheveaux & 3 portes

#familiale - 7 places + pas puissante et très longue / longue / moyenne

#confort - longue et puissante tres longue avec des cheveaux & prix & 5 portes

#classic - le reste (5 portes, courte / moyenne / longue, puissance moyenne)

catalogue$categorie <- with(catalogue,
    ifelse(puissance <=  150 & longueur %in% c("courte","moyenne"), "citadine", 
    ifelse(puissance >  200 & nbportes == 3,"sportive",
    ifelse(nbplaces > 5 | (puissance <=200 & longueur %in% c("longue","moyenne","très longue")) ,"familiale",
    ifelse(longueur %in% c("longue","moyenne","très longue") & puissance > 200,"confort",
    "indefini")))))

nrow(subset(catalogue,categorie == "citadine")) # 130 citadine
nrow(subset(catalogue,categorie == "sportive")) # 0 sportives
nrow(subset(catalogue,categorie == "familiale")) # 100 familiale
nrow(subset(catalogue,categorie == "confort")) # 40 confort
nrow(subset(catalogue,categorie == "indefini")) # 0 indéfini

# on a 0 indéfini donc nos critères couvrent bien le catalogue
# l'abscence de sportive peut remettre en cause cette catégorie mais 
# après exploration du catalogue on remarque que les modèles puissant 
# sont des voitures à 5 portes type M5 Mercedes et donc pour nous la classification 
# sportive représente une catégorie a part non présente dans le catalogue.



immatriculation$categorie <- with(immatriculation,
    ifelse(puissance <=  150 & longueur %in% c("courte","moyenne"), "citadine", 
    ifelse(puissance >  200 & nbportes == 3,"sportive",
    ifelse(nbplaces > 5 | (puissance <=200 & longueur %in% c("longue","moyenne","très longue")) ,"familiale",
    ifelse(longueur %in% c("longue","moyenne","très longue") & puissance > 200,"confort",
    "indefini")))))

nrow(subset(immatriculation,categorie == "citadine")) # 1958 citadine
nrow(subset(immatriculation,categorie == "sportive")) # 0 sportives
nrow(subset(immatriculation,categorie == "familiale")) # 1540 familiale
nrow(subset(immatriculation,categorie == "confort")) # 1502 confort
nrow(subset(immatriculation,categorie == "indefini")) # 0 indéfini

# on a 0 indéfini donc nos critères couvrent bien léchantillion d'immatriculation


# etant donné le volume de donnée import d'immatriculation, j'ai fait le choix d'importer les tâbles jointes avec HIVE :
#on réalise une fusion entre clients et immatriculations
clientImmat <- dbGetQuery(hiveDB,"select 
                  clients_h_ext.clientid as id,
                  clients_h_ext.age as age,
                  clients_h_ext.sexe as sexe,
                  clients_h_ext.taux as taux,
                  clients_h_ext.situation_familiale as situation_familiale,
                  clients_h_ext.nbr_enfant as nbr_enfant,
                  clients_h_ext.voiture_2 as voiture_2,
                  clients_h_ext.immatriculation as immatriculation,
                  immatriculation_h_ext.marque as marque,
                  immatriculation_h_ext.nom as nom,
                  immatriculation_h_ext.puissance as puissance,
                  immatriculation_h_ext.longueur as longueur,
                  immatriculation_h_ext.nbplaces as nbplaces,
                  immatriculation_h_ext.nbportes as nbportes,
                  immatriculation_h_ext.couleur as couleur,
                  immatriculation_h_ext.occasion as occasion,
                  immatriculation_h_ext.prix as prix
                  from clients_h_ext inner join immatriculation_h_ext
                  on clients_h_ext.immatriculation = immatriculation_h_ext.immatriculation")

clientImmat$longueur <- with(clientImmat,ifelse(longueur == 'tr',"très longue",longueur))

clientImmat$categorie <- with(clientImmat,
            ifelse(puissance <=  150 & longueur %in% c("courte","moyenne"), "citadine", 
            ifelse(puissance >  200 & nbportes == 3,"sportive",
            ifelse(nbplaces > 5 | (puissance <=200 & longueur %in% c("longue","moyenne","très longue")) ,"familiale",
            ifelse(longueur %in% c("longue","moyenne","très longue") & puissance > 200,"confort",
            "indefini")))))

nrow(subset(clientImmat,categorie == "citadine")) # 78107 citadine
nrow(subset(clientImmat,categorie == "sportive")) # 0 sportives
nrow(subset(clientImmat,categorie == "familiale")) # 6110 familiale
nrow(subset(clientImmat,categorie == "confort")) # 60794 confort
nrow(subset(clientImmat,categorie == "indefini")) # 0 indéfini

# on a 0 indéfini donc nos critères couvrent bien les clients