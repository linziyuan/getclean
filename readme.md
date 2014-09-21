# Readme: Course Project for "Getting and Cleaning Data"

*Done by Ziyuan Lin, 21 Sep 2014*

This file explains how the R script *run_analysis.R* achieves the objectives of this course project.

## Data sources

Data was collected from the accelerometers from Samsung Galaxy S smartphones carried by 30 subjects performing 6 activities of daily living. 70% of the subjects were selected for generating training data and 30% the test data. Sensor recordings of 561 features were made.

Full description at: [http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones](http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones)
Data for the project at: [https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip](https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip)

## Data structure

The top-level directory contains:
- *features.txt*: a single column of the description of each of the 561 feature measurements
- *activity_labels.txt*: a single column of the activity ID number for the 6 activities

Subjects are not described in detail but only known by ID numbers 1 to 30.

The test data are divided into 3 text files of 2947 rows each:
- *subject_test.txt*: a single column of the subject ID number
- *Y_test.txt*: a single column of the activity ID number
- *X_test.txt*: 561 columns of the feature measurements

The training data are similarly divided into 3 text files of 7352 rows each:
- *subject_train.txt*: a single column of the subject ID number
- *Y_train.txt*: a single column of the activity ID number
- *X_train.txt*: 561 columns of the feature measurements

## Solution

### 1. Merges the training and the test sets to create one data set.

The three test data files were read into R and bound into a single data frame with the columns arranged as follows.

A new column *TestOrTrain* was also created and populated with the value "test".

    +          +  [created]  + subject +  Y_test  +               X_test               +
    +          +             +  _test  +          +                                    +
    +----------+-------------+---------+----------+------------------------------------+
    | [Row ID] | TestOrTrain | Subject | Activity | ..Features..[561 cols]..Features.. |
    +----------+-------------+---------+----------+------------------------------------+
    |     1    |    test     |    2    |     5    | 0.2571778 | -0.02328523 | ........ |
    |     2    |    test     |    2    |     5    | 0.2860267 | -0.01316336 | ........ |
    |    ...   |    ...      |   ...   |    ...   |     ...   |      ...    | ........ |
    |    ...   |    ...      |   ...   |    ...   |     ...   |      ...    | ........ |
    |   2947   |    test     |   24    |     2    | 0.1536272 | -0.01843651 | ........ |
    +----------+-------------+---------+----------+------------------------------------+

The three training data files were likewise read into and bound into a data frame. The created column *TestOrTrain* was populated this time with the value "train".

    +          +  [created]  + subject + Y_train  +              X_train               +
    +          +             + _train  +          +                                    +
    +----------+-------------+---------+----------+------------------------------------+
    | [Row ID] | TestOrTrain | Subject | Activity | ..Features..[561 cols]..Features.. |
    +----------+-------------+---------+----------+------------------------------------+
    |     1    |    train    |    1    |     5    | 0.2885845 | -0.02029417 | ........ |
    |     2    |    train    |    1    |     5    | 0.2784188 | -0.01641057 | ........ |
    |    ...   |    ...      |   ...   |    ...   |     ...   |      ...    | ........ |
    |    ...   |    ...      |   ...   |    ...   |     ...   |      ...    | ........ |
    |   7352   |    train    |   30    |     2    | 0.3515035 |-0.012423118 | ........ |
    +----------+-------------+---------+----------+------------------------------------+

These two data frames were then simply merged using `rbind` as their columns were all aligned. The resulting data frame had 10299 rows (2947+7352) and 564 columns (TestOrTrain, Subject, Activity, and the 561 feature columns).

### 2. Extracts only the measurements on the mean and standard deviation for each measurement. 

The descriptive names of the feature measurements were first read from *features.txt*.

A `grep` command with the regular expression `"(mean\\(\\)|std\\(\\))"` was then run on them to find mean or standard deviation measurements. This regular expression excludes mean frequency measurements whose feature names were in the form `"..MeanFreq().."` which would otherwise be picked up.

66 columns were found to match this criteria. The index numbers of these columns were then saved to extract the appropriate data from the full data set.

### 3. Uses descriptive activity names to name the activities in the data set

The following activity names were read from *activity_labels.txt* into a vector. The Activity column in the merged data set was then converted into a factor with levels using the activity names.

1 WALKING

2 WALKING_UPSTAIRS

3 WALKING_DOWNSTAIRS

4 SITTING

5 STANDING

6 LAYING

### 4. Appropriately labels the data set with descriptive variable names. 

As mentioned above, the descriptive variable names were extracted from *features.txt* and used for the column names of the merged data set.

### 5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

Using the `data.table` library, the data set was converted into a data table. It was summarised by Subject and Activity, the `mean` function was applied to each of the 561 feature columns, and the results were ordered by Subject and Activity. This new tidy data set was then exported as the file *tidydataset.txt*.

The second data set has 180 rows (30 subjects x 6 activities) and 68 columns - the Subject ID, Activity Name, and 66 features. The format of the second data set is as follows:

    +----------+---------+-------------------+-------------------+-------------------+-------------------------+
    | [Row ID] | Subject | Activity          | tBodyAcc-mean()-X | tBodyAcc-mean()-Y | ...[Other features] ... +
    +----------+---------+-------------------+-------------------+-------------------+-------------------------+
    |     1    |    1    |          WALKING  |         0.2773308 |      -0.017383819 | ....................... |
    |     2    |    1    | WALKING_UPSTAIRS  |         0.2554617 |      -0.023953149 | ....................... |
    |    ...   |   ...   |        ...        |         ...       |      ...          | ....................... |
    |    179   |   30    |         STANDING  |         0.2771127 |      -0.017016389 | ....................... |
    |    180   |   30    |           LAYING  |         0.2810339 |      -0.019449410 | ....................... |
    +----------+---------+-------------------+-------------------+-------------------+-------------------------+
