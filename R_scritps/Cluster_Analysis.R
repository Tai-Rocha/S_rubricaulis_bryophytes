##################################################################################################

## Cluster analysis
## Author: Tainá Rocha
## pvclust provides two types of p-values: AU (Approximately Unbiased) p-value and BP (Bootstrap Probability) value. AU p-value, which is computed by multiscale bootstrap resampling, is a better approximation to unbiased p-value than BP value computed by normal bootstrap resampling.

## To build the cluster we take into account the correlation with all variables and their importance in previous principal component analysis (PCA). Thus, we select only variables important to our dataset with no collinearity. The variables are : 

# Water Vapor pressure

##################################################################################################


#### Library
library(pvclust)
library(ggplot2)
library(ggdendro)
library(ape)
library(dendextend)


#input_kmeans <- read.csv("./Clean_data/teste_2.csv")
input_kmeans <- read.csv("./Clean_data/no_correlatiuon_our_choose.csv")

###################### PVClust

cluster <- pvclust(input_kmeans[,-1], method.hclust="average",
        method.dist="euclidean", use.cor="pairwise.complete.obs",
        nboot=1000, parallel=FALSE, r=seq(.5,1.4,by=.1),
        store=FALSE, weight=T, iseed=NULL, quiet=FALSE)

tiff(file="Cluster.tiff",
     width=15, height=12, units="in", res=150)
plot(cluster, print.pv=c("au","bp"), print.num=FALSE, float=0.01,
     col.pv=c(si=4, au=2, bp=3, edge=8), cex.pv=0.4, font.pv=0.1,
     col=NULL, cex=0.6, font=NULL, lty=NULL, lwd=NULL, main=NULL,
     sub=NULL, xlab=NULL)
dev.off()

plot(clusterr,hang = -1, cex = 0.6, max.only=T, )

########## 

pvrect(clusterr, alpha=0.90)


parPvclust(cl=NULL, clusterr, method.hclust="average",
           method.dist="correlation", use.cor="pairwise.complete.obs",
           nboot=100, r=seq(.5,1.4,by=.1), store=FALSE, weight=FALSE,
           init.rand=NULL, iseed=NULL, quiet=FALSE)


################## ENd