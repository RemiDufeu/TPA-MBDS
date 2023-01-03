# TPA master MIAGE mbds

## Consigne du projet du projet

Vous avez été contacté par un concessionnaire automobile afin de l'aider à mieux cibler les véhicules 
susceptibles d'intéresser ses clients. Pour cela il met à votre disposition : 
- Son catalogue de véhicules 
- Son fichier clients concernant les achats de l'année en cours 
- Un accès à toutes les informations sur les immatriculations effectuées cette année 
- Une brève documentation des données 
- Un vendeur (voir son interview ci-dessous) 
Votre client sera satisfait si vous lui proposez un moyen afin : 
- Qu'un vendeur puisse en quelques secondes évaluer le type de véhicule le plus susceptible d'intéresser des clients qui se présentent dans la concession 
- Qu'il puisse envoyer une documentation précise sur le véhicule le plus adéquat pour des clients sélectionnés par son service marketing (voir ci-dessous)

## Notre solution
Pour réaliser notre projet, nous avons décomposé le problème en trois parties :
- L'import et la mise en forme des données dans notre projet [DATA Extraction](https://github.com/RemiDufeu/TPA-MBDS/tree/main/DATA%20extraction) où nous détaillons les différentes étapes de l'import des données.
- L'analyse des données avec R dans le repertoire [Analyse R](https://github.com/RemiDufeu/TPA-MBDS/tree/main/Analyse%20R) où nous analysons notre ensemble de données en détail.
- La visualisation des données à l'aide de techniques de visualisation dans le repertoire [Vizualtion](https://github.com/RemiDufeu/TPA-MBDS/tree/main/Vizualisation).

## L'architecture de notre projet

Notre projet s'appuye sur la machine vagrant configuré par notre professeur [SergioSim](https://github.com/SergioSim) dont vous pouvez consulter le répertoire à l'adresse suivante : https://github.com/SergioSim/vagrant-projects/tree/staging/OracleDatabase/21.3.0.

- Pour notre projet les données catalogue et immatriculation sont contenus dans le serveur MongoDB. 
- Les données O2 sont placées dans le Hadoop Distributed File System (HDFS)
- Les données clients et marketing se situent dans le serveur Oracle NOSQL.

L'ensemble des données sont accessibles via l'intermédiaire de HIVE à l'aide de table externes.


![Architecture Gloable du projet](https://github.com/RemiDufeu/TPA-MBDS/blob/main/Architecture%20Globale.jpg?raw=true)
