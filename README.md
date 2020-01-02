# CourseraDataAnalysis_Assignm2
Predictive model for Human Activity Recognition 
Introduction

This assignment grow out of an experiment [1] that have been carried out with a group of 30 volunteers within an age bracket of 19-48 years. Each person performed the six physical activities (standing, walking, laying, walking, walking upstairs, walking downstairs) wearing the smartphone Samsung Galaxy S2 on the waist. Using its embedded accelerometer and gyroscope, the authors captured 3-axial linear acceleration and 3-axial angular velocity at a constant rate of 50Hz through 
a smartphone application based on the Google Android O.S., developed by themselves [1], for the acquisition of the sensor signals pre-processed and transformed for finding the signal frequency components. 
 

The purpose of this assignment is to provide a predictive model able to identify the correct action (activity) performed by a person (subject) from the data associated with his movements as provided by the sensors of the smartphone. 

Methods:

Data Collection 
For our analysis we used the Samsung activity dataset available from the course website:
https://spark-public.s3.amazonaws.com/dataanalysis/samsungData.rda
These data are slightly processed to make them easier to load into R. Is possible also find the raw data here:
http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones

All of the columns of the data set (except the last two: subject, activity) represents one measurement from the Samsung phone. The variable subject indicates which subject was performing the tasks when the measurements were taken. The variable activity tells what activity they were performing, that is : laying, setting, standing, walk, walk downstairs and walk upstairs.

The dataset consists of 561 relevant independent variables over 7,352 observations!  So the first issue is to reduce the number of variables.
In this analysis I will not deal with the best strategy to choose the basket of variables with more variability.

The contest was designed in a Training and Testing Data Sets format to include the data: 
-	from subjects 1,3,5,6,7,8,11,14 for the Training Data with 2543 observations: 
dataTrain <-with(samsungData, na.omit(samsungData[subject %in% c(1,3,5,6,7,8,11,14),]))
-	from subjects 23,25,26,27,28,29,30 for the Testing Data with 2658 observations: 
dataTest <-with(samsungData, na.omit(samsungData[subject %in% c(23,25,26,27,28,29,30),]))

References:
[1] Davide Anguita, Alessandro Ghio, Luca Oneto, Xavier Parra and Jorge L. Reyes-Ortiz. Human Activity Recognition on Smartphones using a Multiclass Hardware-Friendly Support Vector Machine. International Workshop of Ambient Assisted Living (IWAAL 2012). Vitoria-Gasteiz, Spain. Dec 2012.
[2] by Uwe F Mayer forum post: https://class.coursera.org/dataanalysis-002/forum/thread?thread_id=1237
[3] by Uwe F Mayer forum post: https://class.coursera.org/dataanalysis-002/forum/thread?thread_id=1198


