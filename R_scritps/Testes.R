## Library

library(cluster)
library(factoextra)
library(magrittr)
library(NbClust)

# Distance measures
# The classification of objects, into clusters, requires some methods for measuring the distance or the (dis)similarity between the objects. Chapter Clustering Distance Measures Essentials covers the common distance measures used for assessing similarity between observations.

# It’s simple to compute and visualize distance matrix using the functions get_dist() and fviz_dist() [factoextra R package]:
  
# get_dist(): for computing a distance matrix between the rows of a data matrix. Compared to the standard dist() function, it supports correlation-based distance measures including “pearson”, “kendall” and “spearman” methods.

#fviz_dist(): for visualizing a distance matrix

list_records <- read.csv("./Clean_data/Final_DataClean_Sdmatdata_Ntbox.csv", sep = ",")

res.dist <- get_dist(list_records[6:26], stand = TRUE, method = "pearson")

fviz_dist(res.dist, 
          gradient = list(low = "#00AFBB", mid = "white", high = "#FC4E07"))


## Determining the optimal number of clusters: use factoextra::fviz_nbclust()

fviz_nbclust(list_records[6:26], kmeans, method = "gap_stat")


######

res_2<-NbClust(list_records[6:26], diss=NULL, distance = "euclidean", min.nc=2, max.nc=6, 
            method = c("median"), index = "kl") 
#####

res <- hcut(list_records[6:26], k = 3, stand = TRUE)
fviz_dend(res, rect = TRUE, cex = 0.5,
          k_colors = c("#00AFBB","#2E9FDF", "#E7B800"))
