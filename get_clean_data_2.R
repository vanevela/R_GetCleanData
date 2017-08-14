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
close(con)#always close de connection
htmlCode

#Parsing with XML 
library(RCurl)
library(XML)
url <-"https://scholar.google.com/citations?user=HI-I6C0AAAAJ"
html <-htmlTreeParse(url,useInternalNodes = TRUE)
xpathSApply(html,"//title",xmlValue)
xpathSApply(html,"//td[@id='citedby']",xmlValue)

#GET fron the httrpackage (this method works fine, better than last one )

library(httr)
html2 <- GET(url)
content2 <- content(html2, as= "text")
parsedHtml <- htmlParse(content2,asText = TRUE)
xpathSApply(parsedHtml,"//title", xmlValue)
xpathSApply(parsedHtml,"//td[@id='citedby']",xmlValue)

#Accessing websites with passwords
pg2 <- GET("http://httpbin.org/basic-auth/user/passwd", authenticate("user","passwd"))
pg2
names(pg2)

#Using handles
google <- handle("http;//google.com")
pg1 <- GET(handle = google, path = "/")
pg2 <- GET(handle = google, path = "search")

#Readin From APIs (Aplication programming interfaces)

##  the OAuth application -> oauth_app
#   The OAuth framework doesn't match perfectly to use from R. 
#   Each user of the package for a particular OAuth enabled site must create
#   their own application. See the demos for instructions on 
#   how to do this for linkedin, twitter, vimeo, facebook, github and google.
