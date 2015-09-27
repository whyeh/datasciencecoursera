## Read me

### Tidy data cook book

run_analysis.R sets up tidy data set for the Samsung Galaxy S accelerometers data. This file describes how the script works to generate the tidy data set. See code book for variable and file description.

* This script requires the dplyr package to work.
* tidySamsungData(outname) [outname = the file name for the output file at the end of the script. e.g. "abc.txt"]

run_analysis.R steps and description: 

1. Set up data frame for each experimental group: test and train

	a. For the test group data frame (TestData), read files from the "test" folder
	
		1. Read the subject_test.txt file into testDF and append the "group" column filled with the "test" value. 
		2. Read the y_test.txt file, which contains the case labels of the experiments, into testCase data frame.
		3. Column bind testCase df to testDF
		4. Create a temporary df (testTemp)for data manipulation before binding to testDF
			
			a. Read X_test.txt (complete data for the test group) into testTemp df.
			b. Read features.txt into varDF to create a vector (var.names) containing variable names for the data contained in X_test.txt.
			c. Rename each column of testTemp with strings stored in the var.names vector. 
			d. Create three sub data frames, tst1, tst2, and tst3 from testTemp. These three data frames have column names containing the string "mean", "std", and "Mean", respectively
		
		5. Column bind tst1, tst2, and tst3 df to testDF to form a complete data frame for the test group
	
	b. For the train group data frame (TrainData), repeat the above steps to form a complete data frame for the train group
2. Row bind TestData and TrainData data frames to form one complete data frame CompleteData
3. Replace case labels (1, 2, 3, 4, 5, 6) with descriptive strings (walking, walking_upstairs, walking_downstairs, sitting, standing, laying).
4. Create another data frame (AverageDataSet) with the average of each variable for each activity and each subject.
5. Create text file for the AverageDataSet data frame.      