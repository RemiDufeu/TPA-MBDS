start-dfs.sh
start-yarn.sh


nohup hive --service metastore > /dev/null &
nohup hiveserver2 > /dev/null &

beeline -u jdbc:hive2://localhost:10000 vagrant

CREATE DATABASE IF NOT EXISTS TPA;

USE TPA;

all I had to do was run: sudo mongod --repair

then:

sudo mongod

DROP TABLE IF EXISTS catalogue_ext;

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

SELECT * FROM catalogue_ext;

DROP TABLE IF EXISTS immatriculation_ext;

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


SELECT * FROM immatriculation_ext;
