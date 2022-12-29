install.packages("kknn")
library(kknn)

? kknn()

knn1 <- kknn(categorie~., clientCat_EA, clientCat_ET, k = 10, distance = 1)
knn2 <- kknn(categorie~., clientCat_EA, clientCat_ET, k = 10, distance = 2)
knn3 <- kknn(categorie~., clientCat_EA, clientCat_ET, k = 10, distance = 3)
knn4 <- kknn(categorie~., clientCat_EA, clientCat_ET, k = 20, distance = 1)
knn5 <- kknn(categorie~., clientCat_EA, clientCat_ET, k = 20, distance = 2)
knn6 <- kknn(categorie~., clientCat_EA, clientCat_ET, k = 20, distance = 3)
knn7 <- kknn(categorie~., clientCat_EA, clientCat_ET, k = 3, distance = 2)

print(taux_knn1 <- nrow(clientCat_ET[clientCat_ET$categorie==knn1$fitted.values,])/nrow(clientCat_ET))
print(taux_knn2 <- nrow(clientCat_ET[clientCat_ET$categorie==knn2$fitted.values,])/nrow(clientCat_ET))
print(taux_knn3 <- nrow(clientCat_ET[clientCat_ET$categorie==knn3$fitted.values,])/nrow(clientCat_ET))
print(taux_knn4 <- nrow(clientCat_ET[clientCat_ET$categorie==knn4$fitted.values,])/nrow(clientCat_ET))
print(taux_knn5 <- nrow(clientCat_ET[clientCat_ET$categorie==knn5$fitted.values,])/nrow(clientCat_ET))
print(taux_knn6 <- nrow(clientCat_ET[clientCat_ET$categorie==knn6$fitted.values,])/nrow(clientCat_ET))
print(taux_knn7 <- nrow(clientCat_ET[clientCat_ET$categorie==knn6$fitted.values,])/nrow(clientCat_ET))

# on a un taux de succès de 0.833 environ donc pour l'instant tree est toujours a privillégier