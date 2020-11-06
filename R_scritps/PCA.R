##############################
## PCA S. rubricaulis  
## Author: Tainá Rocha
## Date: 06 November 2020
##############################

## Librarys

library(raster)
library(dismo)
library(factoextra)
library(vegan)
library(spatstat)

## Pedra Bonita e Gávea

list_records <- read.csv("./dados/Syzygiella_rubricaulis/records/New/Data_Clean/Final_DataClean_Sdmatdata_Ntbox.csv", sep = ",")


## PCA
rubricaulis.pca <- prcomp(list_records[6:26],  scale = TRUE)

  fviz_pca_ind(rubricaulis.pca,
               label = "none",
               habillage= list_records$Country,
               geom = "point",
               col.var = "coord")
  
  
fviz_pca_ind(rubricaulis.pca, 
                    label="none", 
                    geom = c("point", "text"),
                    geom.ind = c("point", "text"),
                    habillage=list_records$Country,
                    addEllipses=TRUE, 
                    ellipse.level=0.90)


## Vizualize Image

tiff(file="PCA_rubricaulis.tiff",
     width=9, height=7, units="in", res=150)
fviz_pca_biplot(rubricaulis.pca, 
                axes = c(1, 2), 
                geom = c("point", "text"), 
                geom.ind = "point", 
                geom.var = c("arrow", "text"), 
                col.ind = "black", 
                fill.ind = "gray", 
                col.var = "gray", 
                fill.var = "white", 
                gradient.cols = NULL, 
                label = "all", 
                invisible = "none", 
                repel = FALSE, 
                habillage = list_records$Country, 
                palette = NULL, 
                addEllipses = FALSE, 
                title = "PCA_rubricualis")
dev.off()


### Var importance 

# Dimension 1

tiff(file="dim1_varContrib_gavbon.tiff",
     width=9, height=7, units="in", res=150)
fviz_contrib(rubricaulis.pca, choice="var", axes = 1, sort.val = "asc", fill = "gray")
dev.off()


# Dimension 2

tiff(file="dim2_varContrib_gavbon.tiff",
     width=9, height=7, units="in", res=150)
fviz_contrib(rubricaulis.pca, choice="var", axes = 2, sort.val = "asc", fill = "gray")
dev.off()
