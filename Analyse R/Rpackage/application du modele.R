# le classifieur retenu est l'arbre de décision rpart1. Je vais donc l'appliquer à marketing.

marketing$predictionCategorie  <- predict(tree_rp1, marketing, type="class")

# Nous pouvons maintenant consulter dans la table marketing les predictions dans une nouvelle colonne : predictionCategorie