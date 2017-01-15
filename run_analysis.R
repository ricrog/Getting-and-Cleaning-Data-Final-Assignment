library(dplyr)
library(plyr)

## Download zip packages
if(!file.exists("Dataset.zip")){
        fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
        download.file(fileUrl,destfile="./Dataset.zip")
        unzip("Dataset.zip")
}

## Load data

# Initialize lists 
j <-1; y <- list(); x <- list(); subject <- list(); x_red <- list(); merged_data <- list()

# Download activity and features
activity_labels <- read.table("UCI HAR Dataset/activity_labels.txt",col.names = c("Activity_Number","Activity"))
features <- read.table("UCI HAR Dataset/features.txt")

# Create a logical vector to extract only the wanted values
to_extract <- grepl("mean\\(\\)",features[,2]) | grepl("std\\(\\)",features[,2])

# Loop for loading train and test data
for (i in c("train", "test")) {
        
        # Load Activities (y), Features values (x) and Subject (subject)
        y[[j]] <- read.table(paste("UCI HAR Dataset/", i, "/y_",i,".txt",sep=""))
        x[[j]] <- read.table(paste("UCI HAR Dataset/", i, "/x_",i,".txt",sep=""))
        subject[[j]] <- read.table(paste("UCI HAR Dataset/",i,"/subject_",i,".txt",sep = ""),col.names = "Subject",stringsAsFactors = FALSE)
        
        # Give the correct name of the features value
        names(x[[j]]) <- features[,2]
        
        # Rename correctly the activities
        y[[j]] <- mapvalues(y[[j]][,1],activity_labels$Activity_Number,as.character(activity_labels$Activity))
        
        # Extract values
        x_red[[j]] <- x[[j]][,to_extract]
        
        # Variable that define if data comes from test or train
        Set <- rep(i,length(y[[j]]))
        
        # Merge horizontally the data
        merged_data[[j]] <- cbind(subject[[j]],Set, y[[j]], x_red[[j]]); names(merged_data[[j]])[3] <- "Activity"
        
        j <- j+1
        
}


## Merge of the train and test dataset and order by subject
clean_data_set <- rbind(merged_data[[1]],merged_data[[2]]); 
clean_data_set <- arrange(clean_data_set,Subject)

## Substitution of column name with descriptive names
names_df <- names(clean_data_set)
from_str <- c("^t","^f","\\-mean\\(\\)","\\-std\\(\\)","Acc","Gyro","Jerk","Mag")
to_str <- c("Time_","Freq_","_Mean","_St.Dev","_Acceleration","_Gyroscope","_Jerk","_Magnitude")
for (i in from_str) {
        pos <- match(i,from_str)
        names_df <- gsub(from_str[[pos]],to_str[[pos]],names_df)
}
names(clean_data_set) <- names_df

## Creation of a second data set with average value 
grouped_data <- group_by(clean_data_set,Subject, Set, Activity)
mean_data <- summarise_all(grouped_data,mean)

# Write data table to file
write.table(mean_data,file = "tidy_data.txt", row.names = FALSE)
