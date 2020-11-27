#######################
## Cluster analysis
## Author: Tainá Rocha
########################


#### Library
library(pvclust)
library(ggplot2)
library(ggdendro)
library(ape)
library(dendextend)


input_kmeans <- read.csv("./dados/Syzygiella_rubricaulis/pvclust/pvclust_input_country.csv")

###################### PVClust

clusterr <- pvclust(input_kmeans[,-1], method.hclust="average",
        method.dist="euclidean", use.cor="pairwise.complete.obs",
        nboot=1000, parallel=FALSE, r=seq(.5,1.4,by=.1),
        store=FALSE, weight=T, iseed=NULL, quiet=FALSE)


tiff(file="Cluster.tiff",
     width=15, height=12, units="in", res=150)
plot(clusterr, print.pv="au", print.num=FALSE, float=0.01,
     col.pv=c(si=4, au=2, bp=3, edge=8), cex.pv=0.4, font.pv=0.1,
     col=NULL, cex=0.6, font=NULL, lty=NULL, lwd=NULL, main=NULL,
     sub=NULL, xlab=NULL)
dev.off()

plot(clusterr,hang = -1, cex = 0.6, max.only=T, )


pvrect(clusterr, alpha=0.95)


parPvclust(cl=NULL, clusterr, method.hclust="average",
           method.dist="correlation", use.cor="pairwise.complete.obs",
           nboot=100, r=seq(.5,1.4,by=.1), store=FALSE, weight=FALSE,
           init.rand=NULL, iseed=NULL, quiet=FALSE)



##### hclust

dd <- dist(input_kmeans[-1], method = "euclidean")
hc <- hclust(dd, method = "average")

plot(x, labels = NULL, hang = 0.1, 
     main = "Cluster dendrogram", sub = NULL,
     xlab = NULL, ylab = "Height", ...)

# Put the labels at the same height: hang = -1
plot(hc, labels = input_kmeans$X,
     hang = -1, cex = 0.6)


ggdendrogram(hc, labels = input_kmeans$X, rotate = TRUE)


