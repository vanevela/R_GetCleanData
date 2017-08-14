#subsetting-quick review

set.seed(13435)
x <-data.frame("var1" = sample(1:5), "var2" = sample(6:10), "var3" = sample(11:15))
x <- x[sample(1:5),]; x$var2[c(1,3)] = NA
x

x[,1] #open the first column

x[,"var1"] #also open the first column

x[1:2,"var2"] # row 1, 2 and column 2

#logicals ands and ors

x[(x$var1 <= 3 & x$var3 > 11),] #ands

x[(x$var1 <= 3 | x$var3 > 15),] #ors

#Dealing with missing values

x[which(x$var2>8),]

#sorting

sort(x$var1)
sort(x$var1,decreasing = TRUE)
sort(x$var2,na.last = TRUE)




