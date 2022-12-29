clientCat <- clientImmat[,!names(clientImmat) %in% 
c("id","immatriculation", "marque", "nom","puissance","longueur","nbplaces","nbportes","couleur","occasion","prix")]

clientCat$sexe<-as.factor(clientCat$sexe)
clientCat$sexe<-as.factor(clientCat$sexe)

clientCat$situation_familiale<-as.factor(clientCat$situation_familiale)
clientCat$situation_familiale<-as.factor(clientCat$situation_familiale)

clientCat$voiture_2<-as.factor(clientCat$voiture_2)
clientCat$voiture_2<-as.factor(clientCat$voiture_2)

clientCat$categorie<-as.factor(clientCat$categorie)
clientCat$categorie<-as.factor(clientCat$categorie)

# arbre de décision
clientCat_EA <- clientCat[1:1400,]
clientCat_ET <- clientCat[1401:2000,]

install.packages("rpart")
install.packages("C50")
install.packages("tree")

# Activation des librairies
library(rpart)
library(C50)
library(tree)

? rpart()

# Selection d'attribut par Coefficient de Gini et effectif minimal d'un noeud de 10
tree_rp1 <- rpart(categorie~., clientCat_EA, parms = list(split = "gini"), control = rpart.control(minbucket = 10))
plot(tree_rp1)
text(tree_rp1, pretty = 0)

# Selection d'attribut par Coefficient de Gini et effectif minimal d'un noeud de 5
tree_rp2 <- rpart(categorie~., clientCat_EA, parms = list(split = "gini"), control = rpart.control(minbucket = 5))
plot(tree_rp2)
text(tree_rp2, pretty = 0)

# Selection d'attribut par Information Gain et effectif minimal d'un noeud de 10
tree_rp3 <- rpart(categorie~., clientCat_EA, parms = list(split = "information"), control = rpart.control(minbucket = 10))
plot(tree_rp3)
text(tree_rp3, pretty = 0)

# Selection d'attribut par Information Gain et effectif minimal d'un noeud de 5
tree_rp4 <- rpart(Produit~., produit_EA, parms = list(split = "information"), control = rpart.control(minbucket = 5))
plot(tree_rp4)
text(tree_rp4, pretty = 0)


#----------------------------------------------------------------#
# TEST DES DES CLASSIFIEURS rpart() ET CALCUL DES TAUX DE SUCCES #
#----------------------------------------------------------------#


# Application de tree_rp1 (identique a tree_rp2) a l'ensemble de test
test_rp1 <- predict(tree_rp1, clientCat_ET, type="class")
# Calcul du taux de succes : nombre de succes sur nombre total d'exemples de test
print(taux_rp1 <- nrow(clientCat_ET[clientCat_ET$categorie==test_rp1,])/nrow(clientCat_ET))

# Application de tree3 (identique a tree_rp4) a l'ensemble de test
test_rp3 <- predict(tree_rp3, clientCat_ET, type="class")
# Calcul du taux de succes : nombre de succes sur nombre total d'exemples de test
print(taux_rp3 <- nrow(clientCat_ET[clientCat_ET$categorie==test_rp3,])/nrow(clientCat_ET))

#le taux de succès est identique entre rp1 et rp3

#--------------------------------------------------------------------#
# APPRENTISSAGE DES CLASSIFIEURS C5.0() AVEC DIFFERENTS PARAMETRAGES #
#--------------------------------------------------------------------#

# Apprentissage 1er parametrage pour C5.0
tree_C51 <- C5.0(categorie~., clientCat_EA, control = C5.0Control(minCases = 10, noGlobalPruning = T))
plot(tree_C51, type="simple")

# Apprentissage 2nd parametrage pour C5.0
tree_C52 <- C5.0(categorie~., clientCat_EA, control = C5.0Control(minCases = 10, noGlobalPruning = F))
plot(tree_C52, type="simple")

# Apprentissage 3eme parametrage pour C5.0
tree_C53 <- C5.0(categorie~., clientCat_EA, control = C5.0Control(minCases = 5, noGlobalPruning = T))
plot(tree_C53, type="simple")

# Apprentissage 4eme param�parametrage pour C5.0
tree_C54 <- C5.0(categorie~., clientCat_EA, control = C5.0Control(minCases = 5, noGlobalPruning = F))
plot(tree_C54, type="simple")

#----------------------------------------------------------------#
# TEST DES DES CLASSIFIEURS C5.0() ET CALCUL DES TAUX DE SUCCES #
#----------------------------------------------------------------#

# Test et taux de succes pour le 1er param�trage pour C5.0()
test_C51 <- predict(tree_C51, clientCat_ET, type="class")
print(taux_C51 <- nrow(clientCat_ET[clientCat_ET$categorie==test_C51,])/nrow(clientCat_ET))

# Test et taux de succes pour le 2nd param�trage pour C5.0()
test_C52 <- predict(tree_C52, clientCat_ET, type="class")
print(taux_C52 <- nrow(clientCat_ET[clientCat_ET$categorie==test_C52,])/nrow(clientCat_ET))

# Test et taux de succes pour le 3eme param�trage pour C5.0()
test_C53 <- predict(tree_C53, clientCat_ET, type="class")
print(taux_C53 <- nrow(clientCat_ET[clientCat_ET$categorie==test_C53,])/nrow(clientCat_ET))

# Test et taux de succes pour le 4eme param�trage pour C5.0()
test_C54 <- predict(tree_C54, clientCat_ET, type="class")
print(taux_C54 <- nrow(clientCat_ET[clientCat_ET$categorie==test_C54,])/nrow(clientCat_ET))

# l'arbre C5 donne des performance similaire. Je préfère l'arbre rpart car le graphe est plus lisible.

#--------------------------------------------------------------------#
# APPRENTISSAGE DES CLASSIFIEURS tree() AVEC DIFFERENTS PARAMETRAGES #
#--------------------------------------------------------------------#

# Affichage de l'aide 
? tree()

# Apprentissage 1er parametrage pour tree()
tree_tr1 <- tree(categorie~., clientCat_EA, split = "deviance", control = tree.control(nrow(clientCat_EA), mincut = 10))
plot(tree_tr1)
text(tree_tr1, pretty = 0)

# Apprentissage 2nd parametrage pour tree()
tree_tr2 <- tree(categorie~., clientCat_EA, split = "deviance", control = tree.control(nrow(clientCat_EA), mincut = 5))
plot(tree_tr2)
text(tree_tr2, pretty = 0)


# Test et taux de succes pour le 1er paramétrage pour tree()
test_tr1 <- predict(tree_tr1, clientCat_ET, type="class")
print(taux_tr1 <- nrow(clientCat_ET[clientCat_ET$categorie==test_tr1,])/nrow(clientCat_ET))

# Test et taux de succes pour le 2nd paramétrage pour tree()
test_tr2 <- predict(tree_tr2, clientCat_ET, type="class")
print(taux_tr2 <- nrow(clientCat_ET[clientCat_ET$categorie==test_tr2,])/nrow(clientCat_ET))

# Concernant la classification arbre, la première classification est plus performante et lisible.
# Je préfère donc le tree rp1 avec un succès de 86.5%


