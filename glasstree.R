library(rpart)
#Data from http://ftp.ics.uci.edu/pub/machine-learning-databases/glass/glass.names
glass <- read.csv("glass.data.txt")
colnames(glass) <- c("Id","RefIndex","Na","Mg","Al","Si","K","Ca","Ba","Fe","Type")
##Type of glass: (class attribute)
#      -- 1 building_windows_float_processed
#      -- 2 building_windows_non_float_processed
#      -- 3 vehicle_windows_float_processed
#      -- 4 vehicle_windows_non_float_processed (none in this database)
#      -- 5 containers
#      -- 6 tableware
#      -- 7 headlamps

## Split data into Learning and Test datasets:
r01 <- sample(c(0,1), 213, replace=TRUE)
glass.L <- glass[r01 == 0,]
glass.T <- glass[r01 == 1,]
dim(glass.L)
dim(glass.T)

## Make the tree
?rpart
glass.tree <- rpart(Type ~ RefIndex + Na + Mg + Al + Si + K + Ca + Ba + Fe,
                    data = glass.L, method="class")

plot(glass.tree)
text(glass.tree, use.n=TRUE, all=TRUE, cex=.8)
?predict


#http://stackoverflow.com/questions/19620575/how-do-i-test-data-against-a-decision-tree-model-in-r
pred <- predict(glass.tree, glass.T)
pred
pred == glass.T[, ncol(glass.T)]
