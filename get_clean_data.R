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


###Loading flat files - read.table()///read.csv() for csv files
##example Baltimore cameras 
#tip quote="" means no quote, and resolve problems such as ` and "

cameraData<-read.table("./data/cameras.csv", sep = ",",header = TRUE)
head(cameraData)


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

###Read XML files (Extensible markup language)
#example: https://www.w3schools.com/xml/simple.xml
library(RCurl)
library(XML)
XMLfileUrl<-getURL("https://www.w3schools.com/xml/simple.xml")
doc<-xmlTreeParse(XMLfileUrl, useInternalNodes = TRUE)
class(doc)
rootNode<-xmlRoot(doc)
xmlName(rootNode)


