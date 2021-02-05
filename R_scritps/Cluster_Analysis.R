##################################################################################################

## Cluster analysis
## Author: Tainá Rocha
## pvclust provides two types of p-values: AU (Approximately Unbiased) p-value and BP (Bootstrap Probability) value. AU p-value, which is computed by multiscale bootstrap resampling, is a better approximation to unbiased p-value than BP value computed by normal bootstrap resampling.

## To build the cluster we take into account the correlation with all variables and their importance in previous principal component analysis (PCA). Thus, we select only variables important to our dataset with no collinearity. The variables are : 

# Water Vapor pressure
# Anual Precippitaltions (bio12)
# Temperature annual range (bio7)
# Precipitation Seasonality (bio15)
# Precipitation of Coldest Quarter (bio19)
##################################################################################################


#### Library
library(pvclust)
library(ggplot2)
library(ggdendro)
library(ape)
library(dendextend)


#input_kmeans <- read.csv("./Clean_data/teste_2.csv")

input_kmeans <- read.csv("./Clean_data/final_set_pvclust_5vars.csv")

###################### PVClust

cluster <- pvclust(input_kmeans[,-1], method.hclust="average",
        method.dist="euclidean", use.cor="pairwise.complete.obs",
        nboot=1000, parallel=FALSE, r=seq(.5,1.4,by=.1),
        store=FALSE, weight=T, iseed=NULL, quiet=FALSE)

tiff(file="Cluster.tiff",
     width=15, height=12, units="in", res=150)
plot(cluster, print.pv="au", print.num=FALSE, float=0.01,
     col.pv=c(si=4, au=2, bp=3, edge=8), cex.pv=0.4, font.pv=0.1,
     col=NULL, cex=0.6, font=NULL, lty=NULL, lwd=NULL, main=NULL,
     sub=NULL, xlab=NULL)
dev.off()

#################### End