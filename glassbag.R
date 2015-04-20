
#############################################
#####Import Glass dataset from mlbench#######
#############################################
library(mlbench)
data(Glass)


##############################################
#####Preliminary look at data
#####               And Pre-Processing########
##############################################

str(Glass)
Glass
nearZeroVar(Glass)
#No near-zero predictors

install.packages("reshape")
library(reshape)
meltedGlass <- melt(Glass, id.vars = "Type")
head(meltedGlass)
dim(meltedGlass)
meltedGlass[330,]

library(lattice)
pdf("glassDensityPlots.pdf")
densityplot(~value|variable, data = meltedGlass,
            ## Adjust each axis for each panel
            scales = list(x = list(relation = "free"),
                          y = list(relation = "free")),
            ## 'adjust' smooths the curve out
            adjust = 1.25,
            ##change the symbol on the rug for each data point.
            pch = "|",
            xlab = "Predictor")
dev.off()

### K and Mg second mode around zero
### Ca, Ba, Fe, RI signs of skewness
### one or tow outliers in K or natural skewness
### CA, RI, Na, Si distribution indicative of heavy-tails


### Quantify skewnesss
library(e1071) ##contains skewness function which calculates sample skewness for each predictor
skewValues <- apply(Glass[,-10], 2, skewness)
skewValues


pdf("glassSPM.pdf")
splom(~Glass[, -10], pch = 16, col = rgb(.2, .2, .2, .4), cex = .7)
dev.off()

## "mixture distribution" Mg, Fe, Ba, K (subpopulation of zeroes)
## only correlated are Ca/RI and Ca/Na
## many non-standard distributions pair-wise
## extreme value in K--oulier or evidence of skewed distribution? Need model resistant to outliers.

#### Investigate correlations
######between-predictor correlations
correlations <- cor(Glass[,-10])
dim(correlations)
correlations[1:4,1:4]

library(corrplot)
pdf("glasscorplot.pdf")
corrplot(correlations, order = "hclust")
dev.off()

highCorr <- findCorrelation(correlations, cutoff = .75)
length(highCorr)
highCorr
correlations
##Verifies high correlation between Ca/RI 

## Pre-processing
## Yeo-Johnson transformations (Zero predictor values preclude Box-Cox transformations)
library(caret)
yjTrans <- preProcess(Glass[,-10], method = "YeoJohnson")
yjData <- predict(yjTrans, newdata = Glass[,-10])
melted <- melt(yjData)
pdf("glassYJed.pdf")
densityplot(~value|variable, data = melted,
            ## Adjust each axis for each panel
            scales = list(x = list(relation = "free"),
                          y = list(relation = "free")),
            ## 'adjust' smooths the curve out
            adjust = 1.25,
            ##change the symbol on the rug for each data point.
            pch = "|",
            xlab = "Predictor")
dev.off()


centerScale <- preProcess(Glass[,-10], method=c("center","scale"))
csData <- predict(centerScale, newdata = Glass[,-10])
ssData <- spatialSign(csData)
pdf("glassCenterScale.pdf")
splom(~ssData, pch = 16, col = rgb(.2,.2,.2,.4), cex = .7)
dev.off()

ssGlass <- as.data.frame(cbind(ssData,Glass[,10]))
ssGlass[,10] <- factor(ssGlass[,10])
colnames(ssGlass)[10] <- c("Type")

####################################################
#######Sample Classification Trees For The #########
#######            Glass Dataset           #########
####################################################

testrows <- sample(1:nrow(Glass), size=20)
glass.tree <- rpart(Type~., data = Glass[-testrows,],
                    method = "class")
pdf("onetree.pdf")
plot(glass.tree)
text(glass.tree, use.n=TRUE, all=TRUE, cex=.8)
dev.off()

pdf("diffTrees.pdf")
par(mfrow=c(3,3))
for(i in 1:9){
testrows <- sample(1:nrow(Glass), size=20)
glass.tree2 <- rpart(Type~., data = Glass[-testrows,],
                    method = "class")
plot(glass.tree2)
}
dev.off()   


#####################################################
########Quantification of misclassification #########
########  Rates in Single and Bagged Trees  #########
#####################################################

library(rpart)
Serror <- function(learndata, testdata) {

glass.tree <- rpart( Type ~.,
                    data = learndata, method="class",
                    control = rpart.control(xval = 10))
pred <- predict(glass.tree, testdata)
return ( 1- (sum(as.numeric(apply(pred, 1, which.max) == testdata[, ncol(testdata)]))/dim(testdata)[1]))
}

library(adabag)

bagerror <- function(learndata, testdata) {
bagged.tree <- bagging(formula = Type ~.,
                       data = learndata, mfinal=50,
                       control = rpart.control(xval = 10))
pred <- predict.bagging(bagged.tree, newdata=testdata)
return(pred$error)
}


singleandbag <- function(dataset, testsize=20){
##Initialize variables to track misclassification.    
classErrors <- numeric(2)
singleerrors <- numeric(100)
baggederrors <- numeric(100)

   for (i in 1:100){
        testrows <- sample(1:nrow(dataset), size=testsize)
        singleerrors[i] <- Serror(dataset[-testrows,],dataset[testrows,])
        baggederrors[i] <- bagerror(dataset[-testrows,],dataset[testrows,])
    }
    classErrors[1] <- mean(singleerrors)
    classErrors[2] <- mean(baggederrors)
        
return (classErrors)
}

singleandbag(Glass)
#Results obtained 0.4845   0.2585
#Reduction of 46.7%

#4/20 Obtained 0.4815 0.2935
#Reduction of 39.0%


singleandbag(ssGlass)
##Results obtained 0.2915 0.2880
##Reduction of 1.2%








