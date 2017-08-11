##MySQL

##set library
library(RMySQL)

#connecting and listing databases
ucscDb <- dbConnect(MySQL(),user="genome", host="genome-mysql.cse.ucsc.edu")
result <- dbGetQuery(ucscDb,"show databases;"); dbDisconnect(ucscDb);#it's very importan disconnect
result 
#connecting to hg19 dataBase and listing his tables
hg19<- dbConnect(MySQL(),user="genome", db ="hg19", host = "genome-mysql.cse.ucsc.edu")
allTables <- dbListTables(hg19)#save all tables of hg19 dtaB
length(allTables)
allTables[1:5]

#Get dimensions of specific table "affyU133Plus" in hg19 DB
dbListFields(hg19,"affyU133Plus2") #fields: columns
dbGetQuery(hg19, "select count(*)from affyU133Plus2") #count how many rows are in affy..table

#Read and extrac like a DataFrame  affy's..table from hg19 DB
affyData <- dbReadTable(hg19,"affyU133Plus2")
head(affyData) #inspect dataFrame

#Select a specific subset
query <- dbSendQuery(hg19,"select * from affyU133Plus2 where misMatches between 1 and 3")
affyMis <- fetch(query); quantile(affyMis$misMatches)
affyMisSmall <- fetch(query,n=10); dbClearResult(query);#save a sample
dim(affyMisSmall)#dimensiones de MisSmall dataframe.

#Don't forget to close the connection
dbDisconnect(hg19)

####Reading Data for The Web (webscraping)
library(RCurl)
con <- url("https://scholar.google.com/citations?user=HI-I6C0AAAAJ", method = "libcurl")
htmlCode <- readLines(con)
