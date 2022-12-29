install.packages("randomForest")
library(randomForest)


? randomForest()

# Apprentissage des classifeurs
rf1 <- randomForest(categorie~., clientCat_EA, ntree = 300, mtry = 3)
rf2 <- randomForest(categorie~., clientCat_EA, ntree = 300, mtry = 5)
rf3 <- randomForest(categorie~., clientCat_EA, ntree = 500, mtry = 3)
rf4 <- randomForest(categorie~., clientCat_EA, ntree = 500, mtry = 5)

# Test des classifeurs
rf1_class <- predict(rf1,clientCat_ET, type="response")
rf2_class <- predict(rf2,clientCat_ET, type="response")
rf3_class <- predict(rf3,clientCat_ET, type="response")
rf4_class <- predict(rf4,clientCat_ET, type="response")

print(taux_rf1 <- nrow(clientCat_ET[clientCat_ET$categorie==rf1_class,])/nrow(clientCat_ET))
print(taux_rf2 <- nrow(clientCat_ET[clientCat_ET$categorie==rf2_class,])/nrow(clientCat_ET))
print(taux_rf3 <- nrow(clientCat_ET[clientCat_ET$categorie==rf3_class,])/nrow(clientCat_ET))
print(taux_rf4 <- nrow(clientCat_ET[clientCat_ET$categorie==rf4_class,])/nrow(clientCat_ET))

# j'obtient des resultat de prediction de l'ordre de 84%. Cette méthode ne sera pas retenu par rapport aux arbres.
