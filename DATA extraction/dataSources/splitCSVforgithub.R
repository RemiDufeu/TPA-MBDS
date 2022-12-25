immatriculation <- read.csv("C:/Users/dufeu/Downloads/Immatriculations.csv", header = TRUE, sep = ",", dec = ".") 

immatriculation1 <- immatriculation[1:1000000,]
immatriculation2 <- immatriculation[1000001:2000000,]

write.csv(immatriculation1,file='C:/Users/dufeu/Downloads/Immatriculations1.csv', row.names=FALSE, quote=FALSE, fileEncoding = "WINDOWS-1252")

write.csv(immatriculation2,file='C:/Users/dufeu/Downloads/Immatriculations2.csv', row.names=FALSE, quote=FALSE, fileEncoding = "WINDOWS-1252")