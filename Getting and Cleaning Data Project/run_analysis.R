tidySamsungData <- function(outname) {
     ## Setting up data frame for the test group
     testDF <- read.table("./UCI HAR Dataset/test/subject_test.txt")
     names(testDF) <- "subject"
     testDF$group <- rep("test",nrow(testDF)) # make new column indicating the experimental group
     testCase <- read.table("./UCI HAR Dataset/test/y_test.txt")
     names(testCase) <- "actionLabel"
     testDF <- cbind(testDF, testCase)
     
     ## Creating a temporary data frame for data manipulation before binding to testDF
     testTemp <- read.table("./UCI HAR Dataset/test/X_test.txt")
     varDF <- read.table("./UCI HAR Dataset/features.txt")
     var.names <- varDF$V2
     colnames(testTemp) <- var.names
     tst1 <- testTemp[grep("mean", colnames(testTemp))] ## temp frame keeping only the mean data with colnames 
                                                        ##containing string "mean" 
     tst2 <- testTemp[grep("std", colnames(testTemp))] ## temp frame keeping only the standard deviation data
     tst3 <- testTemp[grep("Mean", colnames(testTemp))] ## temp frame keeping only the mean data with colnames 
                                                        ## containing string "Mean"
     
     ## cbind data frames to testDF
     TestData <- cbind(testDF, tst1, tst2, tst3)
     
     ## Setting up data frame for the train group
     trainDF <- read.table("./UCI HAR Dataset/train/subject_train.txt")
     names(trainDF) <- "subject"
     trainDF$group <- rep("train",nrow(trainDF)) # make new column indicating the experimental group
     trainCase <- read.table("./UCI HAR Dataset/train/y_train.txt")
     names(trainCase) <- "actionLabel"
     trainDF <- cbind(trainDF, trainCase)
     
     ## Creating a temporary data frame for data manipulation before binding to trainDF
     trainTemp <- read.table("./UCI HAR Dataset/train/X_train.txt")
     colnames(trainTemp) <- var.names
     trn1 <- trainTemp[grep("mean", colnames(trainTemp))] ## temp frame keeping only the mean data with 
                                                          ## colnames containing string "mean" 
     trn2 <- trainTemp[grep("std", colnames(trainTemp))] ## temp frame keeping only the standard deviation data
     trn3 <- trainTemp[grep("Mean", colnames(trainTemp))] ## temp frame keeping only the mean data with 
                                                          ## colnames containing string "Mean"
     
     ## cbind data frames to testDF
     TrainData <- cbind(trainDF, trn1, trn2, trn3)
     
     ## rbind Test and Train data to form complete data frame
     CompleteData <- rbind(TestData, TrainData)
     
     ## replacing action label with descriptive variable names
     CompleteData$actionLabel <- factor(CompleteData$actionLabel, levels = c(1,2,3,4,5,6), 
                               labels = c("walking", "walking_upstairs", "walking_downstairs", "sitting", 
                                          "standing", "laying"))
     
     ## create frame containing data set with the average of each variable for each activity and each subject
     AverageDataSet <- CompleteData %>% group_by(subject, group, actionLabel) %>% summarise_each(funs(mean))
     
     write.table(AverageDataSet, file = outname, row.names = FALSE) ## create .txt file for the above data frame
}