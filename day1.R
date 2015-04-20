#######################################
#
# Law School Data Analysis
#
######################################

load("law.rda")

plot(law,cex=1.5,col="blue",pch=19)

cor(law[,1],law[,2])

install.packages("boot")
library(boot)

my.cor <- function(data,indices) cor(data[indices,])

boot(law,my.cor,250)


my.cor <- function(ind) cor(law[ind,1], law[ind,2])
my.cor(1:15) # sample estimate
law.boot <- bootstrap(1:15, 2000, my.cor)
cor.boot <- law.boot$thetastar
hist(cor.boot,50,col="gray")
quantile(cor.boot,.95)

#---percentile method: This is accurate due to assymetry of the Normal theory density curve for \hat \rho
quantile(cor.boot,.05)
quantile(cor.boot,1-.05)

#--- BNormal GOF test

 install.packages("mvtnorm")
 library(mvtnorm)
 mu <- c(mean(law[,1]),mean(law[,2]))
 si <- as.matrix(cov(law))
 plot(rmvnorm(n = 15, mu, si))
 
 D.obs <- cor(law[,1],law[,2], method = "pearson") - cor(law[,1],law[,2], method = "spearman")
 
 #--parametric bootstrap/Monte Carlo Simulation
 
 B <- 1000
 D.boot <- rep(NA,B)
 for(i in 1:B){
 S<-rmvnorm(n = 15, mu, si) #sample size 15
 D.boot[i] <- cor(S[,1],S[,2], method = "pearson") - cor(S[,1],S[,2], method = "spearman")
 }
 
 
 hist(D.boot,40,main="D-Stat Bootstrap Distribution")
 abline(v=D.obs,col="red",lwd=2.5)
 pval <- sum(D.boot<D.obs)/B
 
 
 
 
 

