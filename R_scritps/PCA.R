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

#list_records <- read.csv("./S_rubricaulis_bryophytes_old/dados/Syzygiella_rubricaulis/PCA/Final_DataClean_Sdmatdata_Ntbox_PCA.csv", sep = ",")

list_records <- read.csv("./Clean_data/climatic_elevation_final.csv", sep = ",")


## PCA
rubricaulis.pca <- prcomp(list_records[,5:25],  scale = TRUE)

#fviz_pca_ind(rubricaulis.pca,
#               label = "none",
#               habillage= list_records$Country,
#               geom = "point",
#               col.var = "coord")
  
  
#fviz_pca_ind(rubricaulis.pca, 
#                   label="none", 
#                    geom = c("point", "text"),
#                    geom.ind = c("point", "text"),
#                   habillage=list_records$Country,
#                    addEllipses=TRUE, 
#                    ellipse.level=0.90)


## Vizualize Image

tiff(file="PCA_rubricaulis.tiff",
     width=12, height=10, units="in", res=150)
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
                title = "PCA")
dev.off()


### Var importance 

# Dimension 1

tiff(file="dim1.tiff",
     width=9, height=7, units="in", res=150)
fviz_contrib(rubricaulis.pca, choice="var", axes = 1, sort.val = "asc", fill = "gray")
dev.off()


# Dimension 2

tiff(file="dim2.tiff",
     width=9, height=7, units="in", res=150)
fviz_contrib(rubricaulis.pca, choice="var", axes = 2, sort.val = "asc", fill = "gray")
dev.off()


## Eingvalues

get_engivalues <- get_eigenvalue(rubricaulis.pca)
get_engivalues

# Results for Variables
res.var <- get_pca_var(rubricaulis.pca)
res.var

res.var$coord          # Coordinates
res.var$contrib        # Contributions to the PCs
res.var$cos2           # Quality of representation 
# Results for individuals
res.ind <- get_pca_ind(rubricaulis.pca)
res.ind$coord          # Coordinates
res.ind$contrib        # Contributions to the PCs
res.ind$cos2           # Quality of representation 
  
## loadings
tiff(file="Loadings_rubricaulis.tiff",
     width=12, height=10, units="in", res=150)
fviz_eig(rubricaulis.pca)
dev.off()

################################################################## To fix

# Centering and scaling the supplementary individuals 
ind.scaled <- scale(ind.sup, 
                    center = res.pca$center,
                    scale = res.pca$scale)
# Coordinates of the individividuals
coord_func <- function(ind, loadings){
  r <- loadings*ind
  apply(r, 2, sum)
}
pca.loadings <- res.pca$rotation
ind.sup.coord <- t(apply(ind.scaled, 1, coord_func, pca.loadings ))
ind.sup.coord[, 1:4]
