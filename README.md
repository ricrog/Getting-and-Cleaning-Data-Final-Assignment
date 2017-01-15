## README
This file describe the analysis done on the data present in the UCI HAR Dataset. <br />
Data can be downloaded at: `https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip` <br />
The code that performs the analysis can be found in: `run_analysis.R`

The aim of the analysis is to extrapolate the value referring to the mean and the standard deviation merging 
the data coming from the test and train sets.

The analysis performs the following steps: <br />
1. Download the needed data <br />
2. Load the data <br />
3. Extract the values of interest <br />
4. Join horizontally the subject, activity and features values <br />
5. Vertically merge the data coming from the train and test sets <br />
6. Substitute the variable names with descriptive and more readable names <br />
7. Compute the mean for each activity of each subject <br />
8. Write the computed value on a new data set to be found in `tidy_data.txt` <br />
