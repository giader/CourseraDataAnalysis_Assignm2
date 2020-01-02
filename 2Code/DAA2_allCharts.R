# (1)
# REFERENCE: by Uwe F Mayer forum post: https://class.coursera.org/dataanalysis-002/forum/thread?thread_id=1198
# "Assignment 2: some pointers on getting started"

number.vars <- ncol(dataTrain) - 2
digits <- nchar(as.character(number.vars))
pad <- ""; for(i in 1:digits) pad = paste(pad, "0", sep="")
pb <- txtProgressBar(style=3)

for (i in 1:561){
  number=paste(pad, i, sep="");
  number = substring(number, nchar(number)-digits+1)
  
  filename = paste("./2figures/",number,"_chart.png", sep="")  # adjustment
  par(mfrow=c(1,2))
  hist(dataTrain[,i], main=names(dataTrain)[i],  # adjustment
       xlab=paste("dataTrain[,",i,"]",sep=""))
  
  boxplot(dataTrain[,i] ~ dataTrain$activity, 
          main=names(dataTrain)[i],
          las= 3)
  dev.copy(png,filename) # adjustment
  dev.off()
  setTxtProgressBar(pb, i/number.vars)
}
par(mfrow=c(1,1))
close(pb)