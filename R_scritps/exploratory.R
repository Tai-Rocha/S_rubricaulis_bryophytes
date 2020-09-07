#########################################
## Exploratory analysis for Bryophytes
## Author: Tainá Rocha
#########################################

### Library
library(ntbox)
library(psych)
library(raster)
library(corrplot)
library(erer)

#run_ntbox() # just run for open shiny GUI 

## Read and Load data after clean (table of lat long)

s_rubricaulis <- read.csv("./dados/Syzygiella_rubricaulis/records/data_clean/ntbox/s_rubricaulis_clean.csv", sep = ",", dec = ".")

#rm(s_rubricaulis)

## Read and load envs data (all raster)

predictors_list <- list.files("./dados/Syzygiella_rubricaulis/envs/", full.names = T, pattern = ".tif")

predictors <- stack(predictors_list)

plot(predictors)

### Plotar pontos no mapa para verficar 



### Extract envs values from points using ratser pckg

envs_values_in_points <- raster::extract(predictors,
                                         s_rubricaulis[,c("longitude","latitude")],method="bilinear")

## NA remove
envs_values_in_points_2 <- na.omit(envs_values_in_points)

## Write the table of env values in lat long

write.csv(envs_values_in_points,"./dados/Syzygiella_rubricaulis/envs/envs_valus_point_bilinear_all.csv", sep = ",", dec = ".")

write.csv(envs_values_in_points_2,"./dados/Syzygiella_rubricaulis/envs/envs_valus_point_bilinear_NO_NA.csv", sep = ",", dec = ".")

### Fazer correlação
# Plot correlation matrix and univariate histograms- corrgram packg e corrgram function

matix_correlation <-corrgram(envs_values_in_points_2, lower.panel=panel.pts, upper.panel=panel.cor,diag.panel=panel.density,cor.method="spearman", pch=18, main="Correlation matrix") 

# Or More simple via cor function from stats (R base)

correlation_matrix <- cor(envs_values_in_points_2) 

## Strong correlation of ntbox packg

strong_correlation <- correlation_finder(cor_mat = correlation_matrix, threshold = 0.6, verbose = TRUE)

## cov_center

cov_center_ <- cov_center(envs_values_in_points_2, 
                          mve = T, 
                          level = 0.95, 
                          vars = c("bio3", "bio12", "bio15"))

## Write the cov_center_  using packg erer 

write.list(cov_center_, file= "./Results/S_rubricalis/New/cov_center.csv", t.name = NULL, row.names = FALSE)

### Fit elipsóide ##dando erro


elipse <- ellipsoidfit(
          predictors,
          centroid = cov_center_$centroid,
          covar= cov_center_$covariance,
          level = 0.99,
          plot = T,
          size=3,
         )



## ellipsoid_cluster_plot_3d

## read the K mean tables 

kmean_table  <- read.csv("./Results/S_rubricalis/old/_kmeans_data.csv")

cluster_5_test <- ellipsoid_cluster_plot_3d(
                  niche_data = envs_values_in_points_2,
                  cluster_ids = kmean_table$cluster,
                  x = "bio3",
                  y = "bio12",
                  z= "bio15",
                  mve = FALSE,
                  ellips = TRUE,
                  alpha = 0.25,
                  level = 0.975,
                  grupos = TRUE,
                  vgrupo = kmean_table$cluster,
                  cex1 = 0.25
                  )


write.list(cluster_5_test, file= "./Results/S_rubricalis/New/cluster.csv", t.name = NULL, row.names = FALSE)
