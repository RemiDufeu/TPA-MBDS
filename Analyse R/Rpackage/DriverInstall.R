install.packages('RJDBC')
library(RJDBC)
hiveDB <- dbConnect(odbc::odbc(), "Hive driver")
dbGetQuery(hiveDB,"select * from catalogue_h_ext")
