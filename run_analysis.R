require(reshape2)

#download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip", 
#              "getdata_projectfiles_UCI HAR Dataset.zip")

#unzip("getdata_projectfiles_UCI HAR Dataset", unzip = "unzip")

labels <- read.table("UCI HAR Dataset/features.txt", strip.white = TRUE)
labelsc <- as.character(labels[[2]])      #convert labels to a character vector
labelsc <- gsub("\\(\\)", "", labelsc)    #strip out ()
labelsc <- gsub("\\(|\\)", "-", labelsc)  #strip out any remaining parentheses

xtest <- read.table("UCI HAR Dataset/test/X_test.txt", col.names = labelsc, 
                    strip.white = TRUE)
xtrain <- read.table("UCI HAR Dataset/train/X_train.txt", col.names = labelsc, 
                     strip.white = TRUE)

subjecttest <- read.table("UCI HAR Dataset/test/subject_test.txt", 
                          col.names = c("subject"), strip.white = TRUE)
subjecttrain <- read.table("UCI HAR Dataset/train/subject_train.txt", 
                           col.names = c("subject"), strip.white = TRUE)
xtest <- cbind(subjecttest, xtest)
xtrain <- cbind(subjecttrain, xtrain)

activitytest <- read.table("UCI HAR Dataset/test/Y_test.txt", 
                           col.names = "activity", strip.white = TRUE)
activitytrain <- read.table("UCI HAR Dataset/train/Y_train.txt", 
                            col.names = "activity", strip.white = TRUE)
activitylabels <- read.table("UCI HAR Dataset/activity_labels.txt",
                             strip.white = TRUE)
activitylabels[, 2] <- as.character(activitylabels[, 2])

for (i in 1:dim(activitytest)[1]) {
    activity <- activitytest[i, ]
    activitytest[i, ] <- activitylabels[activity, 2]
}

for (i in 1:dim(activitytrain)[1]) {
    activity <- activitytrain[i, ]
    activitytrain[i, ] <- activitylabels[activity, 2]
}

xtest <- cbind(activitytest, xtest)
xtrain <- cbind(activitytrain, xtrain)

testTrain <- rbind(xtest, xtrain)

tidyData1 <- testTrain[!grepl("meanFreq", ignore.case = TRUE, names(testTrain)) &
                       !grepl("angle", ignore.case = TRUE, names(testTrain)) & 
                        grepl("subject|activity|mean|std", ignore.case = TRUE, names(testTrain))]

tidyMelt <- melt(tidyData1, id = c("activity", "subject"))
tidyData2 <- dcast(tidyMelt, activity + subject ~ variable, mean)
write.table(tidyData2, "tidyData.txt", row.names = FALSE, sep = "\t")