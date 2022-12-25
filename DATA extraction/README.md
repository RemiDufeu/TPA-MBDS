# L'extraction des données et leurs traitements

## Source Orcale noSQL

### Import des données
Pour notre projet nous avons décidé de placer les données clients et marketing dans le serveur Oracle NOSQL. Pour cela nous avons développé deux scripts d'extraction : Clients.java et Marketing.java. Ces deux scripts sont présents dans le dossier "programmesExtraction". Pour les utiliser, veuillez suivre les instructions suivantes : 
- placer les fichiers Clients.txt, Marketing.txt, Clients.java et Marketing.java dans le repertoire de la machine vagrant.
- connecter vous à la machine vagrant avec la commande 
```bash 
vagrant ssh
```	
- Démarrer le serveur Oracle NOSQL (KV Store) avec la commande 
```bash
nohup java -Xmx64m -Xms64m -jar $KVHOME/lib/kvstore.jar kvlite -secure-config disable -root $KVROOT &
```
- réaliser l'import de Marketing
```bash
javac -g -cp $KVHOME/lib/kvclient.jar:. Marketing.java
java -cp $KVHOME/lib/kvclient.jar:. Marketing
```
- réaliser l'import de Clients
```bash
javac -g -cp $KVHOME/lib/kvclient.jar:. Clients.java
java -cp $KVHOME/lib/kvclient.jar:. Clients
```
Nous allons maintenant créer les tables externes sur HIVE pour pouvoir accéder aux données.

### Création des tables externes sur HIVE
Pour commencer, nous devons démarrer le serveur HIVE avec les commandes suivantes :  
```bash
start-dfs.sh
```
```bash
start-yarn.sh
```
```bash
nohup hive --service metastore > /dev/null &
```
```bash
nohup hiveserver2 > /dev/null &
```
- maintenant nous accédons à la console HIVE avec la commande : (il est possible que la commande ne fonctionne pas directement à cause du temps de lancement le mieux est d'attendre quelques secondes et de lancer la commande)
```bash
beeline -u jdbc:hive2://localhost:10000 vagrant
```
```bash
USE DEFAULT;
```
- script de création de la table Marketing

```bash
CREATE EXTERNAL TABLE IF NOT EXISTS MARKETING_H_EXT (
MARKETINGID INTEGER,
AGE INTEGER,
SEXE STRING,
TAUX INTEGER,
SITUATION_FAMILIALE STRING,
NBR_ENFANT INTEGER,
VOITURE_2 STRING
)
STORED BY 'oracle.kv.hadoop.hive.table.TableStorageHandler'
TBLPROPERTIES (
"oracle.kv.kvstore" = "kvstore",
"oracle.kv.hosts" = "localhost:5000",
"oracle.kv.tableName" = "Marketing"
);
```

- script de création de la table Clients

```bash
CREATE EXTERNAL TABLE IF NOT EXISTS Clients_H_EXT (
ClIENTID INTEGER,
AGE INTEGER,
SEXE STRING,
TAUX INTEGER,
SITUATION_FAMILIALE STRING,
NBR_ENFANT INTEGER,
VOITURE_2 STRING,
IMMATRICULATION STRING
)
STORED BY 'oracle.kv.hadoop.hive.table.TableStorageHandler'
TBLPROPERTIES (
"oracle.kv.kvstore" = "kvstore",
"oracle.kv.hosts" = "localhost:5000",
"oracle.kv.tableName" = "clients"
);
```

## Source Mongo DB

### Import des données

Pour notre projet nous avons décidé de placer les données de Catalogue et d'Immatriculations dans le serveur Mongo DB.

Pour réaliser l'import des données il est possible d'utiliser l'utilitaire mongoimport. Nous avons aussi développé un projet MAVEN qui permet de réaliser l'import des données. Ce projet est disponible dans le dossier "programmesExtraction/MONGODB/". Pour l'utiliser il faut configurer la machine vituelle sur virtualbox et rediriger le port 27018 de la machine hôte vers le port 27017 de la machine virtuelle. Il faut aussi modifier les chemins des fichiers d'extractions dans la classe Main.

### Création des tables externes sur HIVE

Pour démarrer et accéder à la console HIVE il faut suivre les mêmes instructions que pour la source Oracle NOSQL.

```bash
USE DEFAULT;
```

- script de création de la table Catalogue

```bash
CREATE EXTERNAL TABLE catalogue_ext ( 
id STRING, 
Marque STRING,
Nom STRING,
Puissance DOUBLE,
Longueur STRING,
NbPlaces INT,
NbPortes INT,
Couleur STRING,
Occasion BOOLEAN,
Prix DOUBLE )
STORED BY 'com.mongodb.hadoop.hive.MongoStorageHandler'
WITH SERDEPROPERTIES('mongo.columns.mapping'='{"id":"_id", "Marque":"Marque", "Nom" : "Nom", "Puissance": "Puissance", "Longueur" : "Longueur", "NbPlaces" : "NbPlaces", "NbPortes" : "NbPortes", "Couleur" : "Couleur", "Occasion" : "Occasion", "Prix" : "Prix"}')
TBLPROPERTIES('mongo.uri'='mongodb://localhost:27017/MBDSTPA.Catalogue');
```

- script de création de la table Immatriculation

```bash
CREATE EXTERNAL TABLE immatriculation_ext ( 
id STRING,
Immatriculation STRING, 
Marque STRING,
Nom STRING,
Puissance DOUBLE,
Longueur STRING,
NbPlaces INT,
NbPortes INT,
Couleur STRING,
Occasion BOOLEAN,
Prix DOUBLE )
STORED BY 'com.mongodb.hadoop.hive.MongoStorageHandler'
WITH SERDEPROPERTIES('mongo.columns.mapping'='{"id":"_id", "Immatriculation":"Immatriculation", "Marque":"Marque", "Nom" : "Nom", "Puissance": "Puissance", "Longueur" : "Longueur", "NbPlaces" : "NbPlaces", "NbPortes" : "NbPortes", "Couleur" : "Couleur", "Occasion" : "Occasion", "Prix" : "Prix"}')
TBLPROPERTIES('mongo.uri'='mongodb://localhost:27017/MBDSTPA.Immatriculation');
```