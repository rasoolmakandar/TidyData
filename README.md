The sccript run_analysis.R is a complete self contained script which generates tidy data as required in the assignment.

					IMPORTANT: For the script run_analysis.R to work, you have to copy the script in the root directory of the data set.(getdata_projectfiles_UCI HAR Dataset\UCI HAR Dataset) 
						The script has following functions -

						1.This function creates a tidy dataset from the test data
							create_dataset<-function(file_X = "./test/X_test.txt", 
                         file_Y= "./test/y_test.txt", 
                         file_subject = "./test/subject_test.txt",
                         features = "features.txt")

						2.This function merges two data sets(test and train) by rows and sorts them by Subject .
						merge_dataset <- function(data1,data2)

						3.This funcion identifies mean and std values for each variable. Creates a subset of main data set containing mean and std values.
						subset_mean_std <- function(data)

						4.This function creates the tidy data set as required by the assignment.
						tidy_dataset <- function(data)

						5. This is an example application function to create the output required for the assignement.The app assumes that it is run from the root directory of dataset.
						app_tidy_data<-function()

						Instructions to run -
						1. Copy the script to root directory(getdata_projectfiles_UCI HAR Dataset\UCI HAR Dataset) of the data set.
						2. Load the script into your R - console.
						3. Run - #app_tidy_data()
						4. Now you should see the tidy data set in the working directory - tidy_data.txt
