run_analysis.R
==============

About the Data:
---------------

The data is the Human Activity Recognition Using Smartphones Dataset, Version 1.0, from Jorge L. Reyes-Ortiz, Davide Anguita, Alessandro Ghio, Luca Oneto at Smartlab - Non Linear Complex Systems Laboratory (www.smartlab.ws).  Six activities were performed by thirty volunteers wearing a smartphone at the waist.  The 3-axial linear acceleration and 3-axial angular velocity were captured form the accelleroeter and gyroscope in the smartphone and processed. The data includes triaxial acceleration from the accelerometer (total acceleration),  the estimated body acceleration, triaxial angular velocity from the gyroscope.  Also included are a 561-feature vector with time and frequency domain variables, the activity labels and the subject identifiers. More information can be found in the readme.txt that comes with the data set.

This program uses melt and dcast from the reshape2 package.

Steps:
------

* Download and unzip the files (commented out; the program runs from the directory above the "UCI HAR Dataset" directory)
* Read in the column labels using read.table()
* Convert the column labels from a data frame to a character vector using as.character
* Strip parentheses from the labels using gsub, replacing () with "" and any stray ( or ) with -
* Read in the test and train data using read.table() with col.names set using the labels created the above step.
* Read in the subjects of the test and train activity sets via read.table()
* Use cbind() to merge the subject values to the corresponding data sets at the beginning of the data sets
* Read in the numeric activities for the test and train data using read.table()
* Read in the text equivalents for the activity labels using read.table()
* Convert the text equivalents (the second column of the activity labels) from factor to character using as.character()
* Replace the numeric values of the activities with their text equivalents in the test and train data sets:
  * loop over the length of each dataset via dim(activitytest/train)`[1]` (in this case, dim gives a length two vector and the number of rows (first item) is needed)
  * set the number of the current activity to a temporary variable
  * look up the activity label by the number and set the current activity test/train value to that label
* Use cbind() to merge the activity test and train values to the corresponding data sets at the beginning of the data sets
* Use rbind() to merge the test and train data sets
* Use grepl to choose the columns wanted by the column labels; grepl gives a True/False vector corresponding to the matches, and testTrain[grepl...] will give only the columns corresponding to true matches
  * !grepl("meanFreq", ignore.case = TRUE, names(testTrain)) removes the cases with "MeanFreq" in the names
  * !grepl("angle", ignore.case = TRUE, names(testTrain)) removes the cases with angle in the name (they are already averages)
  * grepl("subject|activity|mean|std", ignore.case = TRUE, names(testTrain)) gives the subject and activity columns as well as any columns containing mean or std in upper or lower case
* use melt to create a long dataset with columns for activity, subject, variable (type of measurement), and the value for that measurement
* use dcast to create a wide dataset with columns for activity, subject, and each type of measurement where the values for each combination of activity, subject, and measurement are the means of all the measurements for that particular combination
* Write the data to a tab-separated file (tidyData.txt) with no row names; this data can be read into R using read.table("tidyData.txt", sep = "\t")

Some of the files had extra whitespace, so strip.white = TRUE was used in the read.table() commands