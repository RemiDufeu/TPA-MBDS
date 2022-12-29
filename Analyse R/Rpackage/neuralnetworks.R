install.packages("nnet")
library(nnet)

sink('output.txt', append=T)

# Apprentissage du classifeur 
nn1 <- nnet(categorie~., clientCat_EA, size = 50, decay = 0.01, maxit=100)
nn2 <- nnet(categorie~., clientCat_EA, size = 30, decay = 0.01, maxit=100)
nn3 <- nnet(categorie~., clientCat_EA, size = 20, decay = 0.01, maxit=100)
nn4 <- nnet(categorie~., clientCat_EA, size = 25, decay = 0.01, maxit=100)
nn5 <- nnet(categorie~., clientCat_EA, size = 20, decay = 0.01, maxit=300)

sink(file = NULL)

# Test du classifeur : classe predite
nn_class1 <- predict(nn1, clientCat_ET, type="class")
nn_class2 <- predict(nn2, clientCat_ET, type="class")
nn_class3 <- predict(nn3, clientCat_ET, type="class")
nn_class4 <- predict(nn4, clientCat_ET, type="class")
nn_class5 <- predict(nn5, clientCat_ET, type="class")

print(tauxnn1 <- nrow(clientCat_ET[clientCat_ET$categorie==nn_class1,])/nrow(clientCat_ET))
print(tauxnn2 <- nrow(clientCat_ET[clientCat_ET$categorie==nn_class2,])/nrow(clientCat_ET))
print(tauxnn3 <- nrow(clientCat_ET[clientCat_ET$categorie==nn_class3,])/nrow(clientCat_ET))
print(tauxnn4 <- nrow(clientCat_ET[clientCat_ET$categorie==nn_class4,])/nrow(clientCat_ET))
print(tauxnn5 <- nrow(clientCat_ET[clientCat_ET$categorie==nn_class5,])/nrow(clientCat_ET))

# le reseau neuronal monte a 86.5% ce qui est similaire à l'arbre de décision.
# l'arbre de décision semble préférable car il est plus transparent