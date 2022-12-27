# Analyse

## Installation Driver Hive pour R

### Windows : 

- Sur ce [lien](https://www.cloudera.com/downloads/connectors/hive/jdbc/2-6-5.html) telecharger le Driver ODBC HIVE pour windows .

![image](https://user-images.githubusercontent.com/91131467/209726982-b60298ab-21f0-4853-8758-41b4840d3447.png)

- Dés que c'est fait, Aller sur [Control Panel -> System and Security -> Windows Tools] de votre ordi et lancer ODBC DATA SOURCE ADMINISTRATOR (XX-BITS) (32 ou 64 dépend de votre ordi) et cliquer sur le bouton "ADD":

![image](https://user-images.githubusercontent.com/91131467/209727218-025bea7a-c37a-41e2-83c4-226354a0fa7c.png)

![image](https://user-images.githubusercontent.com/91131467/209727290-4cbd0534-862f-4cde-86c5-0168bfea50a6.png)

Une fenetre sera alors s'affiché : 

- Sur USER DNS, Séléctionner Cloudera Driver que vous venez d'installer :

![image](https://user-images.githubusercontent.com/91131467/209727388-5ff3e2fd-3113-4cdd-825e-5eceff83ff78.png)

- Remplir avec les données suivantes :

![image](https://user-images.githubusercontent.com/91131467/209727452-7870569f-fe4b-4bd1-b308-dca9a4cbb61d.png)

![image](https://user-images.githubusercontent.com/91131467/209727508-56702cbe-ee01-4057-aa3f-9efb24da86ee.png)

- Faite la meme chose sur l'onglet SYSTEM DNS :

![image](https://user-images.githubusercontent.com/91131467/209727767-18c0a88e-ad9f-47de-9c1e-34ecc6bbecf3.png)

### R

Executer les lignes de commandes suivantes :

```r
install.packages('RJDBC')
library(RJDBC)
con <- dbConnect(odbc::odbc(), "Hive Driver")
```
Apres cette étape, si vous utilisez RStudio vous devez voir la connexion du HIVE comme suit : 

![image](https://user-images.githubusercontent.com/91131467/209728768-34d72463-8f90-4959-b9ea-ad52365e18fd.png)

Pour tester que tout marche bien on execute une simple requete SQL :

```r
dbGetQuery(con,"select * from catalogue_h_ext")
```

![image](https://user-images.githubusercontent.com/91131467/209729343-03073896-6f94-4016-a88e-a701597a0fae.png)








