#getting and cleaning data project
#read data
setwd('F://document//R learning//cousera r programming//data cleaning course//quiz4//UCI HAR Dataset')

#read train data set
features <- read.table("features.txt")
xtrain <- read.table("./train/X_train.txt")
colnames(xtrain) <- features$V2
ytrain <- read.table("./train/y_train.txt")
subject_train <- read.table("./train/subject_train.txt")
xtrain$activity <- ytrain$V1
xtrain$subject <- subject_train$V1

#read test set
xtest <- read.table("./test/X_test.txt")
colnames(xtest) <- features$V2
ytest <- read.table("./test/y_test.txt")
subject_test <- read.table("./test/subject_test.txt")
xtest$activity <- ytest$V1
xtest$subject <- subject_test$V1

#merge xtrain and xtest
alldata <- rbind(xtrain, xtest)

#extracts measurements on mean and std
colnamesfilter <- colnames(alldata)[grep("mean\\(\\)|std\\(\\)|activity|subject"
                                         ,colnames(alldata))]
alldata.filter <- alldata[,colnamesfilter]  


#rename activity
x <- factor(alldata.filter$activity)
levels(x) <- list("walk"=1,"walkup"=2,"walkdown"=3,"sit"=4,"stand"=5,"lay"=6)
alldata.filter$activity <- x

#creates a tidy data set with the average of 
#each variable for each activity and each subject
library(reshape2)
alldata.filter.melt <- melt(alldata.filter,id=c("activity","subject"),measure.vars = colnames(alldata.filter)[1:66])
id.data <- reshape2::dcast(alldata.filter.melt,activity+subject ~ variable,mean)
#write the tidy data set
write.csv(id.data,file = "./tidydata.csv")
