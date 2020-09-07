


#### Library
library(pvclust)


input_kmeans <- read.csv("./dados/Syzygiella_rubricaulis/pvclust/extract_bilienar_bioINcols.csv")

clusterr <- pvclust(input_kmeans[,-1], method.hclust="centroid",
        method.dist="euclidean", use.cor="pairwise.complete.obs",
        nboot=100, parallel=FALSE, r=seq(.5,1.4,by=.1),
        store=FALSE, weight=T, iseed=NULL, quiet=FALSE)

plot(clusterr)
pvrect(clusterr, alpha=0.95)


parPvclust(cl=NULL, clusterr, method.hclust="average",
           method.dist="correlation", use.cor="pairwise.complete.obs",
           nboot=100, r=seq(.5,1.4,by=.1), store=FALSE, weight=FALSE,
           init.rand=NULL, iseed=NULL, quiet=FALSE)
