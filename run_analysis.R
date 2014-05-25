# set the data.directory where the raw data are located
data.directory <- "."

# 1. merge training and test data sets
# get features for the col.names
feature <- read.table(file.path(data.directory, "features.txt"),
                      colClasses = c("numeric", "character"),
                      col.names=c("Feature.ID", "Feature"))
feature.names <- as.vector(feature$"Feature")

# select columns of interest: feature.names like "*-mean()" or "*-std()"
columns.of.interest <- grep('mean[(]|std[(]', feature.names)

# clean feature.names, removing "()"
feature.names <- gsub("\\(\\)", "", feature.names)

# X_*.txt
X1 <- read.table(file.path(data.directory, "train", "X_train.txt"),
                 colClasses="numeric",
                 col.names=feature.names)
X2 <- read.table(file.path(data.directory, "test", "X_test.txt"),
                 colClasses="numeric",
                 col.names=feature.names)

# 2. extract the measurements for the mean and std deviation
X <- rbind(X1[, columns.of.interest], X2[, columns.of.interest])

# y_*.txt
y1 <- read.table(file.path(data.directory, "train", "y_train.txt"),
                 col.names="Activity.ID")
y2 <- read.table(file.path(data.directory, "test", "y_test.txt"),
                 col.names="Activity.ID")
y <- rbind(y1, y2)

# 3. get descriptive activity names
# activities
activity <- read.table(file.path(data.directory, "activity_labels.txt"),
                       colClasses = c("numeric", "character"),
                       col.names=c("Activity.ID", "Activity"))

# 4. Replace Activity.ID by descriptive Activity name
y <- merge(y, activity, all=TRUE)
y$Activity.ID <- NULL

# subject_*.txt
s1 <- read.table(file.path(data.directory, "train", "subject_train.txt"),
                 col.names="Subject")
s2 <- read.table(file.path(data.directory, "test", "subject_test.txt"),
                 col.names="Subject")

# add new column to remember which set the data come from
s1$Set <- rep("Training", nrow(s1))
s2$Set <- rep("Test", nrow(s2))
subject <- rbind(s1, s2)

# merge the 3 tables together
clean <- cbind(subject, y, X)

# uncomment to write out the first tidy data set
# write.table(clean, file=file.path("clean1.txt"), row.names=F)

# 5. tiny data set with average by Activity and Subject
average <- aggregate(clean[4:length(clean)],
                     by=list(Subject=clean$Subject,
                             Set=clean$Set,
                             Activity=clean$Activity),
                     FUN=mean)
average <- average[order(average$Subject, average$Activity), ]
write.table(average, file=file.path("tidy.txt"), row.names=F)
