##Checking for and creating directories

if(!file.exists("data")){
  dir.create("data")
}


##Getting data from the internet-download.file()
##download a file from the web 
##(baltimore cameras:https://data.baltimorecity.gov/Transportation/Baltimore-Fixed-Speed-Cameras/dz54-2aru)

fileUrl <- "https://data.baltimorecity.gov/api/views/dz54-2aru/rows.csv?accessType=DOWNLOAD"
download.file(fileUrl,destfile = "./data/cameras.csv",method = "curl") ##method es necesario en mac porque es una https
list.files("./data")


##asignar la fecha de la descarga a un objeto para hacer seguimiento

dateDownloaded<-date()
dateDownloaded

###############################################################
###Loading flat files - read.table()///read.csv() for csv files
##example Baltimore cameras 
#tip quote="" means no quote, and resolve problems such as ` and "

cameraData<-read.table("./data/cameras.csv", sep = ",",header = TRUE)
head(cameraData)

################################################################
###Excel files
#download file
excelfileUrl<-"https://data.baltimorecity.gov/api/views/dz54-2aru/rows.xlsx?accessType=DOWNLOAD"
download.file(excelfileUrl, destfile = "./data/cameras.xlsx",method = "curl")
downloadexcelfiledate<-date()
downloadexcelfiledate

#read excel files - read.xlsx() - read.xlsx2(){xlsx package}
#nota: la libreria xlsx no funciona en linux al parecer.
library(xlsx)
cameraDataExcel <- read.xlsx("./data/cameras.xlsx",sheetIndex=1, header=TRUE)
head(cameraDataExcel)

###############################################################
###Read XML files (Extensible markup language)

#example, breakfast menu: https://www.w3schools.com/xml/simple.xml
library(bitops)#for R version 3.4.1 before RCurl and XML libraries
library(RCurl)
library(XML)

XMLfileUrl<-getURL("https://www.w3schools.com/xml/simple.xml")
doc<-xmlTreeParse(XMLfileUrl, useInternalNodes = TRUE)
class(doc)
#save in object entire document 
rootNode<-xmlRoot(doc)
#to get the root node
xmlName(rootNode)
names(rootNode)
#first element of root
rootNode[[1]]
#first component in first element the root
rootNode[[1]][[1]]
##programatically extract parts of the file
xmlSApply(rootNode,xmlValue) # xmlValue is a function

##XPath 
#more info: http://www.stat.berkeley.edu/~statcur/Workshop2/Presentations/XML.pdf
#/node top level
#//node any level
#node[@attr-name] node with attribute name
#node[@attr-name="bob"] node with attribute name attr-name='bob'

##Get the items on the menu and prices
xpathApply(rootNode,"//name",xmlValue)
xpathApply(rootNode,"//price",xmlValue)

#####warning#####

#another example from espn web...no funciona la estructura de la pag cambio
fileUrlespn<-"http://www.espn.com.co/futbol/partido?juegoId=487576"
doc_espn <- htmlTreeParse(fileUrlespn,useInternalNodes = TRUE)
teams <- xpathApply(doc_espn,"span[@class='long-name']",xmlValue)
teams

####################################################################

#################
###Reading JSON##
#################
#reading data from JSON {jsonlite package}
#example
library(jsonlite)
jsonData<-fromJSON("https://api.github.com/users/jtleek/repos")
names(jsonData)

##Nested objects in JSON
#get acces to a particular varible (in this case owner is a Dframe inside another Dframe)
names(jsonData$owner)
#get acces to a variable inside owner Dframe
jsonData$owner$login

##writing data frames to JSON (iris is a dataframe from R library)
myjson<-toJSON(iris,pretty = TRUE)
cat(myjson)

##convert back to JSON to Dataframe
iris2<-fromJSON(myjson)
head(iris2)

#####################################################
####data.table###
#create data tables just like data frames
library(data.table)
#data frame
DF<- data.frame(x=rnorm(9),y=rep(c("a","b", "c,"),each=3),z=rnorm(9))
head(DF,3)
#data table
DT<- data.table(x=rnorm(9),y=rep(c("a","b", "c,"),each=3),z=rnorm(9))
head(DT,3)
#see all the data tables in memory
tables()
#subsetting rows
DT[2,]
DT[DT$y=="a",]
DT[c(2,3)]
#subsetting columns
DT[,c(2,3)]
###Calculating values for variables with expressions
DT[,list(mean(x),sum(z))]
DT[,table(y)]
###Adding new columns
DT[,w:=z^2]
DT
##Multiple operations
DT[,m:={tmp<-(x+z); log2(tmp+5)}]
DT
##plyr like operations
DT[,a:=x>0]
DT
DT[,b:= mean(x+w), by=a]
DT
#special variables .N an integer, containing the number of times that a particular group appears
set.seed(123);
DT<-data.table(x=sample(letters[1:3], 1E5,TRUE))
DT[,.N,by=x]
#keys for grouping
DT<- data.table(x=rep(c("a","b","c"),each=100),y=rnorm(300))
setkey(DT,x)
DT['a']
##joins with keys
DT1<- data.table(x=c("a","a","b","dt1"),y=1:4)
DT2<- data.table(x=c("a","b","dt2"),z=5:7)
setkey(DT1,x); setkey(DT2,x)
merge(DT1,DT2)
##Fast reading
big_df<-data.frame(x=rnorm(1E6),y=rnorm(1E6))
file<- tempfile()
write.table(big_df,file = file,row.names = FALSE, col.names = TRUE, sep = "\t", quote = FALSE)
system.time(fread(file))
#
system.time(read.table(file,header = TRUE,sep="\t"))


