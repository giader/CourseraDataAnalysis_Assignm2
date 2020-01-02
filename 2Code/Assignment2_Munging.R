## Data Analysis Assignment no.2
#Due date 8/12
# The data for this assignment are the Samsung activity data available from the course website: 
# https://spark-public.s3.amazonaws.com/dataanalysis/samsungData.rda
# These data are slightly processed to make them easier to load into R. You can also find the raw data here: 
# http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones 
# WORK 
setwd("C:/Users/Gianni/Dropbox/R_Coursera/DataAnalysis/Assignment2")
save.image("C:/Users/Gianni/Dropbox/R_Coursera/DataAnalysis/Assignment2/Assignment2_Munging.RData")
load("C:/Users/Gianni/Dropbox/R_Coursera/DataAnalysis/Assignment2/Assignment2_Munging.RData")
#load("./2data/samsungData.rda")
names(samsungData)[1:12]

# Exploring Data
##Plotting max acceleration for the first subject
# variabili MaxAcceleration :  
names(samsungData)[10:12]  #coordinate x,y, z
par(mfrow=c(1,2))
plot(samsungData[samsungData$subject==1,10],pch=19,col=numericActivity,ylab=names(samsungData)[10])
plot(samsungData[samsungData$subject==1,11],pch=19,col=numericActivity,ylab=names(samsungData)[11])
# la coordinata Z sembra ininfluente 

##Clustering based on maximum acceleration
source("http://dl.dropbox.com/u/7710864/courseraPublic/myplclust.R")
par(mfrow=c(1,2))
distanceMatrix <- dist(samsungData[samsungData$subject==1,10:12])
hclustering <- hclust(distanceMatrix)
myplclust(hclustering,lab.col=numericActivity)
par(mfrow=c(1,1))

# found variables with same name and different values
names(samsungData)[c(325,339)]
samsungData[1:100,c(325,339)]
samsungData[1:100,c(319,333)]
samsungDataN<-samsungData

ndup <- names(samsungDataN)
for (i in ndup[duplicated(ndup)]) {
  ndup[which(ndup==i)] <- make.names(ndup[which(ndup==i)], unique=TRUE)
}
names(samsungData) <- ndup
# colnames(samsungDataN) <- gsub('\\(|\\)', "", names(samsungDataN))
# colnames(samsungDataN) <- gsub('\\...', "-", names(samsungDataN))
# colnames(samsungDataN) <- gsub('\\,', "", names(samsungDataN))
# write.table(ndup,file="./2data/Ass2_Samsung_Newvar.csv",sep=",")

# data munging 
# Check fo Na or NaN
dataNa <- is.na(samsungData$activity)
sum(dataNa)
table(samsungData$activity, useNA="ifany")
table(samsungData$activity)
table(samsungData$subject)
samsungData1<- samsungData[,-c(562,563)]
colSums(samsungData1)

# Training & Test Data 
dataTrain <- with(samsungData, samsungData[subject %in% c(1,3,5,6), ])
dataTest <- with(samsungData, samsungData[subject %in% c(27,28,29,30), ])


