#------------------------#
# CHARGEMENT DES DONNÉES #
#------------------------#

# Chargement des donnees
catalogue <- dbGetQuery(hiveDB,"select 
                        catalogue_h_ext.id as id,
                        catalogue_h_ext.marque as marque,
                        catalogue_h_ext.nom as nom,
                        catalogue_h_ext.puissance as puissance,
                        catalogue_h_ext.longueur as longueur,
                        catalogue_h_ext.nbplaces as nbplaces,
                        catalogue_h_ext.nbportes as nbportes,
                        catalogue_h_ext.couleur as couleur,
                        catalogue_h_ext.occasion as occasion,
                        catalogue_h_ext.prix as prix
                        from catalogue_h_ext")

immatriculation <- dbGetQuery(hiveDB,"select 
                        immatriculation_h_ext.id as id,
                        immatriculation_h_ext.immatriculation as immatriculation,
                        immatriculation_h_ext.marque as marque,
                        immatriculation_h_ext.nom as nom,
                        immatriculation_h_ext.puissance as puissance,
                        immatriculation_h_ext.longueur as longueur,
                        immatriculation_h_ext.nbplaces as nbplaces,
                        immatriculation_h_ext.nbportes as nbportes,
                        immatriculation_h_ext.couleur as couleur,
                        immatriculation_h_ext.occasion as occasion,
                        immatriculation_h_ext.prix as prix
                        from immatriculation_h_ext LIMIT 5000")

co2table <- dbGetQuery(hiveDB,"select 
                  co2_hdfs_h_ext.carid as id,
                  co2_hdfs_h_ext.marque as marque,
                  co2_hdfs_h_ext.malusbonus as malusbonus,
                  co2_hdfs_h_ext.rejet as rejet,
                  co2_hdfs_h_ext.coutenergie as coutenergie
                  from co2_hdfs_h_ext")

marketing <- dbGetQuery(hiveDB,"select 
                  marketing_h_ext.marketingid as id,
                  marketing_h_ext.age as age,
                  marketing_h_ext.sexe as sexe,
                  marketing_h_ext.taux as taux,
                  marketing_h_ext.situation_familiale as situation_familiale,
                  marketing_h_ext.nbr_enfant as nbr_enfant,
                  marketing_h_ext.voiture_2 as voiture_2
                  from marketing_h_ext")

clients <- dbGetQuery(hiveDB,"select 
                  clients_h_ext.clientid as id,
                  clients_h_ext.age as age,
                  clients_h_ext.sexe as sexe,
                  clients_h_ext.taux as taux,
                  clients_h_ext.situation_familiale as situation_familiale,
                  clients_h_ext.nbr_enfant as nbr_enfant,
                  clients_h_ext.voiture_2 as voiture_2,
                  clients_h_ext.immatriculation as immatriculation
                  from clients_h_ext")




# Manipulations de base
str(catalogue)
names(catalogue)
summary(catalogue)

str(immatriculation)
names(immatriculation)
summary(immatriculation)

str(co2table)
names(co2table)
summary(co2table)

str(marketing)
names(marketing)
summary(marketing)

str(clients)
names(clients)
summary(clients)

# dans notre dataset 'très longue' correspond à 'tr'
immatriculation$longueur <- with(immatriculation,ifelse(longueur == 'tr',"très longue",longueur))
