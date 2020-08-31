
######################
## Clean
######################

library(raster)
library(modleR)
library(ntbox)

###### Read 

s_brasiliensi <- read.csv("./dados/Syzygiella_rubricaulis/Srubricaulis_gbif_speciesLink.csv", sep = ",", dec = ".")


predictors_list <- list.files("/home/taina/Documentos/Worldclim/RAW_current_21v_10km/wc2.1_5m_bio/", full.names = T, pattern = ".tif")

predictors <- stack(predictors_list)

sdmdata_s_brasiliense <- setup_sdmdata(species_name = unique(s_brasiliensi[2]),
                             occurrences = s_brasiliensi[3:4],
                             lon = "long",
                             lat = "lat",
                             predictors = predictors,
                             models_dir = "data_clean",
                             partition_type = "crossvalidation",
                             cv_partitions = 1,
                             cv_n = 1,
                             seed = 512,
                             buffer_type = "mean",
                             png_sdmdata = TRUE,
                             n_back = 1,
                             clean_dupl = T,
                             clean_uni = T,
                             clean_nas = T,
                             select_variables = F,
                             sample_proportion = 0.5,
                             cutoff = 0.7)