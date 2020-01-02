## Data Analysis Assignment no.2
# Due date 8/12
# The data for this assignment are the Samsung activity data available from the course website: 
# https://spark-public.s3.amazonaws.com/dataanalysis/samsungData.rda
# These data are slightly processed to make them easier to load into R. You can also find the raw data here: 
# http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones 
# WORK 
setwd("C:/Users/Gianni/Dropbox/R_Coursera/DataAnalysis/Assignment2")
save.image("C:/Users/Gianni/Dropbox/R_Coursera/DataAnalysis/Assignment2/DAA2.RData")
#load("C:/Users/Gianni/Dropbox/R_Coursera/DataAnalysis/Assignment2/DAA2.RData")
load("./2data/samsungData.rda")
library(Metrics)
library(tree)
# first data investigation
#str(samsungData)
summary(samsungData)
# check for NA occurences
sum(is.na(samsungData[, -c(562,563)]))

# REFERENCE: by Uwe F Mayer forum post: https://class.coursera.org/dataanalysis-002/forum/thread?thread_id=1237
# Fix the duplicate variable names
source("./DAA2_fixNameMapping.R")
names(samsungData) <- names(fixNameMapping(samsungData, overload = F))
samsungData$activity <- as.factor(samsungData$activity)

newNameMap<-names(samsungData)
write.table(newNameMap,file="./2data/newNameMap2.csv",sep=",")

# Training & Test Data 
dataTrain <- with(samsungData, na.omit(samsungData[subject %in% c(1,3,5,6,7,8,11,14), ]))
dataTest <- with(samsungData, na.omit(samsungData[subject %in% c(23,25,26,27,28,29,30), ]))
dataValid <- with(samsungData, na.omit(samsungData[!subject %in% c(1,3,5,6,7,8,11,14,23,25,26,27,28,29,30), ]))
summary(dataValid)
table(samsungData$activity, useNA="ifany")  # general
table(dataTrain$activity, useNA="ifany")
table(dataTest$activity, useNA="ifany")
table(dataValid$activity, useNA="ifany")
table(dataTrain$subject, useNA="ifany")
table(dataTest$subject, useNA="ifany")
table(dataValid$subject, useNA="ifany")


# Exploratory Data Analysis

# REFERENCE: by Uwe F Mayer forum post: https://class.coursera.org/dataanalysis-002/forum/thread?thread_id=1198
# "Assignment 2: some pointers on getting started"
source("./DAA2_allCharts.R")

setvar <- 50
column <- 1:561


# matrix with the mean for each activity / variable
#trainDev <- apply(dataTrain[ , 1:561], 2, sd)
trainMean <- apply(dataTrain[ , 1:561], 2, function(ncol) tapply(ncol, dataTrain$activity, mean))
trainSd <- apply(dataTrain[ , 1:561], 2, function(ncol) tapply(ncol, dataTrain$activity, sd))

# duplicate analysis
trainMeanT <- t(trainMean)
round(trainMeanT[duplicated(trainMeanT),],5) #list of duplicates

trainMeanT <- trainMeanT[!duplicated(trainMeanT), ]  # to eliminate duplicate rows with same means 
trainMean <- t(trainMeanT)

indx <- 1:561
#colindx <- sample(indx, 10) #sample randomly 10 variables 
set.seed(1122)
round(trainMean[1:6,sample(indx, 5)], digits = 5) #sample randomly 5 variables 

round(trainMean[1:6,1:5], digits = 5)  # first 5 variables 

#variance of means 
trainMeanDev <- apply(trainMean, 2, sd)  # Vector Deviance for each column (2= column)
trainMeanDevT <- apply(trainMeanT, 1, sd)  # Vector Deviance for each row (1= row)
sum(trainMeanDev-trainMeanDevT) # equal zero . Ok!

# sort the standard deviations decrescing to capture the first variables with more viariability
trainMeanDevSor <- order(trainMeanDev, decreasing=T)
# trainMeanT <- t(trainMean)
# trainMeanDevT <- apply(trainMeanT, 1, sd)  # Vector Deviance for each row (1= row)
trainMeanDev <- trainMeanDev[trainMeanDevSor]

round(trainMeanDev[1:12], 5)
####################################################################################
VarGroup1 <- 100
colInd <- 1:561

##### Predicting with Regression models (Linear Least Squared (lm function))
set.seed(12345)
colIndx <- sample(colInd, VarGroup1) # sample of columns
# stringa <- as.formula(paste0("as.numeric(activity) ~ ", paste(names(dataTrain[, colIndx]), collapse="+")))
string <- as.formula(paste0("as.numeric(activity) ~ ", paste(names(dataTrain[, colIndx]), collapse="+")))

testModel <- lm(string, data = dataTrain)
summary(testModel)

BestMod <- step(testModel, trace = 0)
summary(BestMod)
##Prediction with Training SET
predict1 <- round(predict(BestMod, dataTrain))
table(dataTrain$activity, predict1)
# found predicted values greater than 6 and less than 1 
predict1 <- replace(predict1, predict1==0,1)
predict1 <- replace(predict1, predict1>6,6)
table(dataTrain$activity, predict1)
t(table(dataTrain$activity, predict1))
#actual <- as.numeric(dataTrain$activity)
#table(actual, predict1)

#Training Set Errors
actual <- as.numeric(dataTrain$activity)
rmse(actual,predict1)
# FIG. 3 Pairs Plot for those variables with lower p-values
pairs(formula = ~actual + fBodyGyro.bandsEnergy.Z.17.24 + fBodyGyro.mean.Z  + 
        tBodyGyro.min.Z + fBodyAccJerk.mean.Z + 
        tBodyAcc.std.X  + tBodyGyro.min.Z + tBodyGyroJerk.entropy.X ,
      data = dataTrain, main = "Scatterplot Matrix")
dev.copy(png,'./2figures/fig4-Scatterplot Matrix.png')
dev.off()

par(mfrow = c(2, 2))
plot(testModel)
dev.copy(png,'./2figures/fig5-PlotModel.png')
dev.off()
##Prediction with Test SET
predict2 <- round(predict(BestMod, dataTest))
table(dataTest$activity, predict2)
# found predicted values greater than 6 and less than 1 
predict2 <- replace(predict2, predict2<0,1)
predict2 <- replace(predict2, predict2>6,6)
table(dataTest$activity, predict2)
t(table(dataTest$activity, predict2))

actual2 <- as.numeric(dataTest$activity)

rmse(actual2,predict2)
# Pairs Plot for those variables with lower p-values
pairs(formula = ~actual2 + fBodyGyro.bandsEnergy.Z.17.24 + fBodyGyro.mean.Z  + 
        tBodyGyro.min.Z + fBodyAccJerk.mean.Z + 
        tBodyAcc.std.X  + tBodyGyro.min.Z + tBodyGyroJerk.entropy.X ,
      data = dataTest, main = "Scatterplot Matrix")

#####  Predicting with TREEs 
VarGroup2 <- 500

colInd <- 1:561

set.seed(12345)
colIndx <- sample(colInd, VarGroup2) # sample of columns
stringTree <- as.formula(paste0("activity~ ", paste(names(dataTrain[, colIndx]), collapse="+")))


testModelTree <- tree(stringTree, data = dataTrain)
#modelStep <- modelTest
summary(testModelTree)
# FIG. 5
par(mfrow = c(1,1))
plot(testModelTree)
text(testModelTree, cex=0.6)
dev.copy(png,'./2figures/fig5-Plot Tree.png')
dev.off()

# FIG. 6  Plot errors
par(mfrow=c(1,2))
plot(cv.tree(testModelTree, FUN=prune.tree, method="misclass"))
plot(cv.tree(testModelTree))
dev.copy(png,'./2figures/fig6-Plot Errors.png')
dev.off()
# FIG. 7  Prune the tree 
pruneTree <- prune.tree(testModelTree, best=8)
par(mfrow=c(1,1))
plot(pruneTree)
text(pruneTree, cex=0.6)
dev.copy(png,'./2figures/fig7-Prune the Tree.png')
dev.off()
par(mfrow=c(1,1))

summary(pruneTree)

predictTrain <- predict(pruneTree, dataTrain, type="class")
#actual <- samTrain$activity
actualTrain <- dataTrain$activity
table(actualTrain, predictTrain)
rmse1<-rmse(as.numeric(actualTrain),as.numeric(predictTrain))
rmse1

## Prediction Tree with Test SET
predictTest<- predict(pruneTree, dataTest, type="class")
actualTest <- dataTest$activity

table(actualTest, predictTest)
rmse2<-rmse(as.numeric(actualTest),as.numeric(predictTest))
rmse2
