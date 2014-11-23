#-----Coverting all the .txt file to tables-------------------
#----Getting data for training------------
feature = read.table(file = '/Users/mayankpundir/UCI HAR Dataset/features.txt',sep="",col.names=c("sno","colnames"),fill=TRUE,strip.white=TRUE,blank.lines.skip = TRUE)
lable_name = read.table(file = '/Users/mayankpundir/UCI HAR Dataset/activity_labels.txt',sep="",col.names=c("lable","lable_name"),fill=TRUE,strip.white=TRUE,blank.lines.skip = TRUE)
subject_tr = read.table(file = '/Users/mayankpundir/UCI HAR Dataset/train/subject_train.txt',col.names=c("Subject"), stringsAsFactors=F,sep="",fill=TRUE,strip.white=TRUE,blank.lines.skip = TRUE)
y_train = read.table(file = '/Users/mayankpundir/UCI HAR Dataset/train/y_train.txt',col.names=c("lable"), stringsAsFactors=F,sep="",fill=TRUE,strip.white=TRUE,blank.lines.skip = TRUE)
X_train = read.table(file = '/Users/mayankpundir/UCI HAR Dataset/train/X_train.txt',col.names=t(feature[,c("colnames")]), stringsAsFactors=F,sep="",fill=TRUE,strip.white=TRUE,blank.lines.skip = TRUE)
#-----Merging data by Columns from Subject training data set,Y training Data set and X training Data set into result1---------
result1 <- cbind(subject_tr,y_train,X_train)
#-----Getting data for test------------
subject_te = read.table(file = '/Users/mayankpundir/UCI HAR Dataset/test/subject_test.txt',col.names=c("Subject"), stringsAsFactors=F,sep="",fill=TRUE,strip.white=TRUE,blank.lines.skip = TRUE)
y_test = read.table(file = '/Users/mayankpundir/UCI HAR Dataset/test/y_test.txt',col.names=c("lable"), stringsAsFactors=F,sep="",fill=TRUE,strip.white=TRUE,blank.lines.skip = TRUE)
X_test = read.table(file = '/Users/mayankpundir/UCI HAR Dataset/test/X_test.txt',col.names=t(feature[,c("colnames")]), stringsAsFactors=F,sep="",fill=TRUE,strip.white=TRUE,blank.lines.skip = TRUE)
#------- Merging data by Columns from Subject test data set,Y test Data set and X test Data set into result2---------
result2 <- cbind(subject_te,y_test,X_test)
#-------Mering Data from Training and Test------------
merged <- rbind(result1,result2)
#--- Getting only Mean and standard deviation for each measurement--------------------
extract <- cbind(merged[,c(1,2)],merged[,grep(c("mean"),names(merged),value = TRUE)],merged[,grep(c("std"),names(merged),value = TRUE)])
#------Remvoing . from the Colnames of Extract data set----------
names(extract) <- gsub("\\.","",names(extract))
library(sqldf)
#------Getting Lable Names in the final data set---------
final <- sqldf("select b.lable_name,a.* from extract a left outer join lable_name b on a.lable = b.lable order by a.lable")
#---------Getting Average of all variable for each activity and each subject----------
tidy_data <- as.data.frame(aggregate(x = final[,c(3:82)], by = list(final$"lable_name",final$"Subject"), FUN = "mean", na.rm = T))
#---------Writing data in to a txt file--------
write.table(tidy_data,file = "/Users/mayankpundir/Desktop/tiday_data.txt",sep="",row.names=FALSE)

