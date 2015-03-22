library(plyr)
library(dplyr)

##This function creates a tidy dataset from the test data
create_dataset<-function(file_X = "./test/X_test.txt", file_Y= "./test/y_test.txt",
                         file_subject = "./test/subject_test.txt",
                         features = "features.txt")
{
    ##*****************Read Data Frame and assign Column Names ***************##
    x_data = read.table(file_X)    ## Read the data as data frame.
    ##Below 2 lines are for Step4 in assignment
    features = read.table("features.txt") ## Read the feature names.
    colnames(x_data) = features[,"V2"]  ## Assign the column names to data frame.

    ##****   Read Subject/Activity Labels and assign Columns in Data Frame ***##
    subject = read.table(file_subject)
    x_data$Subject = subject$V1
    x_data = x_data[,c(562,1:561)] ## Move subject column to the beginning
    
    label=read.table(file_Y)
    label$V1=as.factor(label$V1)
    
    ##Change levels to Activity - Step3 in assignement
    label$V1=revalue(label$V1, c("1"="WALKING", "2"="WALKING_UPSTAIRS", 
                                 "3"="WALKING_DOWNSTAIRS","4"="SITTING",
                                 "5"="STANDING","6"="LAYING"))
    x_data$Activity = label$V1
    x_data = x_data[,c(1,563,2:562)] ## Move Activity Column to second column
    
    ##Return The data
    x_data
}

## This function merges two data sets(test and train) by rows and sorts them by
## Subject 
merge_dataset <- function(data1,data2){
    print("Mergig Data")
    ##Step 1 in assignement
    data <- rbind(data1, data2)     ## Combine train and test data set
    data=data[order(data$Subject),] ## Sort according to subject, 1-top,30-last
    data ## Return merged data set
} 

## This funcion identifies mean and std values for each variable. Creates a 
##subset of main data set containing mean and std values
subset_mean_std <- function(data){
    print("Subsetiing mean() and std() ")
    
    ## Get column index of mean by using partial match to "-mean()" in col names
    j=grep("mean()", names(data), fixed=TRUE)
    data1 = data[,c(1,2,j)] ## Keep Col 1 & 2, append mean() columns
    
    ## Get column index of std by using partial match to "-std()" in col names
    i=grep("std()", names(data), fixed=TRUE)
    data2 = data[,c(i)] ## Keep Col 1 & 2, append mean() columns
    
    ## Create Combined Data with mean and std values. Step 2 in assignement
    tidy_data = cbind(data1,data2)
    
    tidy_data ##Return tidy data with mean and std values
    
}

##This function creates the tidy data set as required by the assignment
tidy_dataset <- function(data){
    print(" Creating final tidy data")
    tidy_data=data.frame()
    ##Get number of col in data
    num_col= ncol(data)
    
    ##Covert Subject to factor
    data$Subject=as.factor(data$Subject)
    
    for(i in 3:num_col)
    {
        ##Split data according to Subject and Activity for each variable
        m=split(data[,i], data$Subject:data$Activity)    
        n=lapply(m, mean) ## Calculate mean
        
        ## Start appending to the data frame
        tidy_data=rbind(tidy_data,as.data.frame(n, row.names=colnames(data)[i], optional=TRUE))        
    }
    
    ##Prefix Subject for easier understanding of the columns
    colnames(tidy_data) = paste("Subject", colnames(tidy_data), sep = "_")
    
    ##Return tidy_data
    tidy_data
}

##This is an example application to create the output required for the assignement
## The app assumes that it is run from the root directory of dataset where the 
## "README.txt" is present
app_tidy_data<-function(){
    print("Running App for Tidy Data")
    ## Read the test and train data
    ##Step4 & Step3 from assignment are done here.
    print("Creating test Data")
    test_data = create_dataset() 
    print("Creating train Data")
    train_data = create_dataset(file_X="./train/X_train.txt", file_Y="./train/y_train.txt",
            file_subject="./train/subject_train.txt", features="features.txt")
     
    ##Merge Data and sort according to subject
    ##Step1
    complete_data = merge_dataset(test_data,train_data)
    
    ##EXtract mean and std for each variable
    ##Step2
    complete_data_subset = subset_mean_std(complete_data)
    
    ##Create Tidy data set with the mean of each variable
    ##Step5
    tidy_data = tidy_dataset(complete_data_subset)
    print("****done****")
    write.table(tidy_data, file="tidy_data.txt")
}