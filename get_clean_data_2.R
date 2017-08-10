##MySQL

##set library
library(RMySQL)
#connecting and listing databases
ucscDb <- dbConnect(MySQL(),user="genome", host="genome-mysql.cse.ucsc.edu")
result <- dbGetQuery(ucscDb,"show databases;"); dbDisconnect(ucscDb);#it's very importan disconnect





