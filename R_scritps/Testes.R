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

list_records <- read.csv("./Clean_data/hcLust_input_test.csv", sep = ",")


##Cluster
input_kmeans <- read.csv("./Clean_data/teste_2.csv")

###################### PVClust

cluster <- pvclust(input_kmeans[,-1], method.hclust="average",
                   method.dist="euclidean", use.cor="pairwise.complete.obs",
                   nboot=1000, parallel=FALSE, r=seq(.5,1.4,by=.1),
                   store=FALSE, weight=T, iseed=NULL, quiet=FALSE)

## For test -> edit dendrogram
dend <- as.dendrogram(cluster)
cluster %>%
  as.dendrogram() %>%
  hang.dendrogram() %>%
  plot(main = "Cluster dendrogram with AU/BP values (%)")
cluster %>% text()
cluster %>% pvrect(alpha = 0.95)

dend %>%
  pvclust_show_signif(cluster) %>%
  plot()
dend %>%
  pvclust_show_signif(cluster, show_type = "lwd") %>%
  plot()
cluster %>% text()
cluster %>% pvrect(alpha = 0.95)

dend %>%
  pvclust_show_signif_gradient(cluster) %>%
  plot()

dend %>%
  pvclust_show_signif_gradient(cluster) %>%
  pvclust_show_signif(cluster) %>%
  plot(main = "Cluster dendrogram with AU/BP values (%)\n bp values are highlighted by signif")
cluster %>% text()
cluster %>% pvrect(alpha = 0.95)


### For test 2 with ggplot

library(ggplot2)
library(ggdendro)
library(plyr)
library(zoo)

cut <- 3
dendr <- dendro_data(dend, type = "rectangle") 
clust <- cutree(dend, k = cut)               # find 'cut' clusters
clust.df <- data.frame(label = names(clust), cluster = clust)
# Split dendrogram into upper grey section and lower coloured section
height <- unique(dendr$segments$y)[order(unique(dendr$segments$y), decreasing = TRUE)]
cut.height <- mean(c(height[cut], height[cut-1]))
dendr$segments$line <- ifelse(dendr$segments$y == dendr$segments$yend &
                                dendr$segments$y > cut.height, 1, 2)
dendr$segments$line <- ifelse(dendr$segments$yend  > cut.height, 1, dendr$segments$line)

# Number the clusters
dendr$segments$cluster <- c(-1, diff(dendr$segments$line))
change <- which(dendr$segments$cluster == 1)
for (i in 1:cut) dendr$segments$cluster[change[i]] = i + 1
dendr$segments$cluster <-  ifelse(dendr$segments$line == 1, 1, 
                                  ifelse(dendr$segments$cluster == 0, NA, dendr$segments$cluster))
dendr$segments$cluster <- na.locf(dendr$segments$cluster) 

# Consistent numbering between segment$cluster and label$cluster
clust.df$label <- factor(clust.df$label, levels = levels(dendr$labels$label))
clust.df <- arrange(clust.df, label)
clust.df$cluster <- factor((clust.df$cluster), levels = unique(clust.df$cluster), labels = (1:cut) + 1)
dendr[["labels"]] <- merge(dendr[["labels"]], clust.df, by = "label")

# Positions for cluster labels
n.rle <- rle(dendr$segments$cluster)
N <- cumsum(n.rle$lengths)
N <- N[seq(1, length(N), 2)] + 1
N.df <- dendr$segments[N, ]
N.df$cluster <- N.df$cluster - 1

# Plot the dendrogram
ggplot() + 
  geom_segment(data = segment(dendr), 
               aes(x=x, y=y, xend=xend, yend=yend, size=factor(line), colour=factor(cluster)), 
               lineend = "square", show.legend = FALSE) + 
  scale_colour_manual(values = c("grey60", rainbow(cut))) +
  scale_size_manual(values = c(.1, 1)) +
  geom_text(data = N.df, aes(x = x, y = y, label = factor(cluster),  colour = factor(cluster + 1)), 
            hjust = 1.5, show.legend = FALSE) +
  geom_text(data = label(dendr), aes(x, y, label = label, colour = factor(cluster)), 
            hjust = -0.2, size = 3, show.legend = FALSE) +
  scale_y_reverse(expand = c(0.2, 0)) + 
  labs(x = NULL, y = NULL) +
  coord_flip() +
  theme(axis.line.y = element_blank(),
        axis.ticks.y = element_blank(),
        axis.text.y = element_blank(),
        axis.title.y = element_blank(),
        panel.background = element_rect(fill = "white"),
        panel.grid = element_blank())



########Others


res <- hcut(list_records[,-1], k = 3, stand = TRUE, hc_method = "average", hc_metric= "euclidean")

res$labels <-list_records$Country_Map

fviz_dend(dend, rect = TRUE, cex = 0.5,
          k_colors = c("#00AFBB","#2E9FDF", "#E7B800"))


### Correlação
res.dist <- get_dist(list_records[6:26], stand = TRUE, method = "pearson")

fviz_dist(dend, 
          gradient = list(low = "#00AFBB", mid = "white", high = "#FC4E07"))


## Determining the optimal number of clusters: use factoextra::fviz_nbclust()

fviz_nbclust(list_records[6:26], kmeans, method = "gap_stat")


## Determining the optimal number of cluster _way 2

res_2<-NbClust(list_records[6:26], diss=NULL, distance = "euclidean", min.nc=2, max.nc=6, 
            method = c("median"), index = "kl") 
#####
