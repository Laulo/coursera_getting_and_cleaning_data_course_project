# Getting and Cleaning Data - Course Project - README

## CodeBook

The final tidy data set `tidy.txt` contains a data.frame with 35 observations of 69 variables.
The variables are:

* `Subject`: containing suject IDs. Theses IDs come from the original `train/y_train.txt` and `test/y_test.txt` raw files.
* `Set`: indicates if the given subject belongs to the `Training` or `Test` data set.
* `Activity`: indicates the activity the subject was performing for these measurements. The activity names come from the original `activity_labels.txt` file. 
* all the other 66 columns are either `*-mean()` or `*-std()` measurements coming from the original `train/X_train.txt` and `test/X_test.txt` raw files. The title of each column come from the `features.txt` raw file.

## Instruction List

To use with the R script `run_analysis.R` located in the same directory

Steps undertake by the script `run_analysis.R`:

* By default, the script looks for the raw data in its own directory (`.`). Should the raw data be located somewhere else, it is possible to change the first line and set the variable `data.directory` to give the path to the raw data directory
* Create a data.frame from the file `features.txt` to get the names of each measurement, store it in a variable `feature.names`
* Select measurements of interest (i.e, featurenames like "*-mean()" or "*-std()"). Store it in a variable `columns.of.interest`
* Remove the "()" from the featurenames as these names will be used as column names in the tidy data set
* Create 2 data.frames from the files `train/X_train.txt` and `test/X_test.txt`. These files contain the measurements
* For each of them, select only the `columns.of.interest`, then `rbind()` them into a data.frame called `X`
* Create 2 data.frames from the files `train/y_train.txt` and `test/y_test.txt`. These files contain the `Activity.ID` for each measurement
* `rbind()` them into a data.frame called `y`
* Create a data.frame from the file `activity_labels.txt` called `activity`. It will be used to replace `Activity.ID` by real (and understandable) names in the tidy data set
* `merge()` `activity` and `y`, i.e. join them to add to `y` the `Activity` name corresponding to the `Activity.ID`
* remove the column `Activity.ID` which won't be useful anymore
* Create 2 data.frames from the files `train/subject_train.txt` and `test/subject_test.txt`
* Add a new column `Set` to memorize which set ("Training" or "Test") each subject come from
* `rbind()` them into a data.frame called `subject`
* Create a first tidy data set called `clean` by `cbind()`ing `subject`, `y` and `X`
* By uncommenting the next line, it if possible to write this data.frame to a file
* `aggregate()` the first three columns `Subject`, `Set`, `Activity` and compute the mean of every other columns (measurements)
* Order by subject number, then by activity
* Write out the data.frame to a file called `tidy.txt`
