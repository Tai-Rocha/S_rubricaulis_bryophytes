
######################
## Clean
######################

library(raster)
library(modleR)
library(ntbox)

###### Read 

s_brasiliensi <- read.csv("./dados/Syzygiella_rubricaulis/Srubricaulis_gbif_speciesLink.csv", sep = ",", dec = ".")


predictors_list <- list.files("./dados/RAW_Present_1970_200_version_2.1/", full.names = T, pattern = ".tif")

predictors <- stack()

sdmdata_s_brasiliense <- setup_sdmdata(species_name = species[1],
                             occurrences = occs,
                             predictors = example_vars,
                             models_dir = test_folder,
                             partition_type = "crossvalidation",
                             cv_partitions = 5,
                             cv_n = 1,
                             seed = 512,
                             buffer_type = "mean",
                             png_sdmdata = TRUE,
                             n_back = 500,
                             clean_dupl = FALSE,
                             clean_uni = FALSE,
                             clean_nas = FALSE,
                             geo_filt = FALSE,
                             geo_filt_dist = 10,
                             select_variables = TRUE,
                             sample_proportion = 0.5,
                             cutoff = 0.7)